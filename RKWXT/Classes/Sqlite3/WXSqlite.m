//
//  WXSqlite.m
//  SQLite
//
//  Created by le ting on 5/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXSqlite.h"
#import "WXSqliteItem.h"

#define kWXSqliteDataBaseName @"wxSqlite.db"
@implementation WXSqlite

- (void)dealloc{
    sqlite3_close(_dataBase);
//    [super dealloc];
}

+ (WXSqlite*)sharedSqlite{
    static dispatch_once_t onceToken;
    static WXSqlite *sharedSqlite = nil;
    dispatch_once(&onceToken, ^{
        sharedSqlite = [[WXSqlite alloc] init];
    });
    return sharedSqlite;
}

- (id)init{
    if(self = [super init]){
        [self createDataBase];
    }
    return self;
}

- (void)createDataBase{
    NSString *dataBasePath = [self dataBasePath];
    const char *dbPath = [dataBasePath UTF8String];
    NSLog(@"%@",dataBasePath);
    KFLog_Normal(YES, @"data base path = %@",dataBasePath);
    if(sqlite3_open_v2(dbPath, &_dataBase, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK){
        KFLog_Normal(YES, @"dataBase create Succeed");
    }else{
        KFLog_Normal(YES, @"dataBase create failed");
    }
}

//dataBase的地址~
- (NSString*)dataBasePath{
    NSString *docsDir = [UtilTool documentPath];
    return [docsDir stringByAppendingPathComponent:kWXSqliteDataBaseName];
}

- (BOOL)existTable:(NSString*)tableName{
    NSAssert(tableName != nil && [tableName length] > 0, @"tableName cannot be nil nor empty");
    sqlite3_stmt *statementChk;
    sqlite3_prepare_v2(_dataBase, "SELECT name FROM sqlite_master WHERE type='table' AND name='util_nums';", -1, &statementChk, nil);
    bool ret = FALSE;
    if (sqlite3_step(statementChk) == SQLITE_ROW) {
        KFLog_Normal(YES, @"table:%@ exist",tableName);
        ret = TRUE;
    }else{
        KFLog_Normal(YES, @"table:%@ not exist",tableName);
    }
    sqlite3_finalize(statementChk);
    
    return ret;
}

- (BOOL)removeTable:(NSString*)tableName{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    const char *cSql = [sql UTF8String];
    
    char *error = nil;
    BOOL ret = NO;
    if(sqlite3_exec(_dataBase, cSql, NULL, NULL, &error) == SQLITE_OK){
        ret = YES;
        KFLog_Normal(YES, @"remove table:%@ succeed",tableName);
    }else{
        KFLog_Normal(YES, @"remove table:%@ failed",tableName);
        if(error){
            KFLog_Normal(YES, @"remove table:%@ failed reson:%s",tableName,error);
            sqlite3_free(error);
        }
    }
    return ret;
}

//创建表格
- (BOOL)createSqliteTable:(NSString*)tableName itemArray:(NSArray*)itemArray{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName];
    NSInteger count = [itemArray count];
    for(int i = 0; i < count; i++){
        WXSqliteItem *item = [itemArray objectAtIndex:i];
        [sql appendFormat:@"%@ ",item.identifier];
        [sql appendFormat:@"%@",[item dataTypeString]];
        if(i < count - 1){
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    
    BOOL ret = NO;
    char *errorMsg;
    if (sqlite3_exec(_dataBase, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
        KFLog_Normal(YES, @"Create table:%@ failed",tableName);
        if(errorMsg){
            KFLog_Normal(YES, @"failed error:%s",errorMsg);
            sqlite3_free(errorMsg);
        }
    }else{
        KFLog_Normal(NO, @"Create table:%@ succeed",tableName);
        ret = YES;
    }
    return ret;
}

//插入数据
- (NSInteger)insertTable:(NSString*)tableName itemDataArray:(NSArray*)itemArray{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT OR REPLACE INTO %@",tableName];
    [sql appendString:@"("];
    NSInteger count = [itemArray count];
    for(int i = 0; i < count; i++){
        WXSqliteItem *item = [itemArray objectAtIndex:i];
        [sql appendFormat:@"%@",item.identifier];
        if(i < count - 1){
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    
    [sql appendString:@" VALUES ("];
    for(int i = 0; i < count; i++){
        [sql appendString:@"?"];
        if(i < count - 1){
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    int ret = -1;
    sqlite3_stmt *stmt;
    int prepareRet = sqlite3_prepare_v2(_dataBase, [sql UTF8String], -1, &stmt, nil);
    if(SQLITE_OK == prepareRet){
        for(WXSqliteItem *item in itemArray){
            int index = (int)[itemArray indexOfObject:item] + 1;
            E_SQLITE_DATA_TYPE dataType = item.dataType;
            switch (dataType) {
                case E_SQLITE_DATA_INT:
                {
                    NSInteger data = [item.data integerValue];
                    sqlite3_bind_int(stmt, index, (int)data);
                }
                    break;
                case E_SQLITE_DATA_TXT:
                {
                    NSString *data = item.data;
                    sqlite3_bind_text(stmt, index, [data UTF8String], -1, NULL);
                }
                    
                    break;
                default:
                    break;
            }
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            KFLog_Normal(YES, @"插入数据失败");
        }else{
            ret = (int)sqlite3_last_insert_rowid(_dataBase);
            KFLog_Normal(YES, @"插入数据成功 index = %d",ret);
        }
        sqlite3_finalize(stmt);
    }else{
        KFLog_Normal(YES, @"insert sqlite3_prepare_v2 eorror");
    }
    return ret;
}

//加载数据
- (NSMutableArray*)loadData:(NSString*)tableName itemArray:(NSArray*)itemArray{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@",tableName];
    const char *query_stmt = [querySql UTF8String];
    sqlite3_stmt *statement;
    int ret = sqlite3_prepare_v2(_dataBase, query_stmt, -1, &statement, nil);
    
    NSMutableArray *sqliteDataArray = [NSMutableArray array];
    if(ret == SQLITE_OK){
        while (SQLITE_ROW == sqlite3_step(statement)) {
            //数据库每一行数据都用一个字典来表示~
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            for(WXSqliteItem *item in itemArray){
                E_SQLITE_DATA_TYPE dataType = item.dataType;
                int index = (int)[itemArray indexOfObject:item];
                id data = nil;
                switch (dataType) {
                    case E_SQLITE_DATA_INT:
                    {
                        int iData = sqlite3_column_int(statement, index);
                        data = [NSNumber numberWithInt:iData];
                    }
                        break;
                    case E_SQLITE_DATA_TXT:
                    {
                        const char *txt = (const char *)sqlite3_column_text(statement, index);
                        if(txt){
                            data = [NSString stringWithUTF8String:txt];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                if(data){
                    [dataDic setObject:data forKey:item.identifier];
                }else{
                    KFLog_Normal(YES, @"load empty data, key = %@",item.identifier);
                }
            }
            if([dataDic allKeys] && [[dataDic allKeys] count] > 0){
                [sqliteDataArray addObject:dataDic];
            }
        }
    }else{
        KFLog_Normal(YES, @"load data error");
    }
    if([sqliteDataArray count] > 0){
        return sqliteDataArray;
    }
    return nil;
}

- (NSString*)updateSqlForItem:(WXSqliteItem*)item{
    NSAssert(item, @"item can not be nil");
    NSString *identifier = item.identifier;
    id data = item.data;
    E_SQLITE_DATA_TYPE type = item.dataType;
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"%@=",identifier];
    switch (type) {
        case E_SQLITE_DATA_INT:
            [sql appendFormat:@"%ld",(long)[data integerValue]];
            break;
        case E_SQLITE_DATA_TXT:
            [sql appendFormat:@"'%@'",data];
            break;
        default:
            break;
    }
    return sql;
}

- (BOOL)updateData:(NSString*)tableName primaryItem:(id)primaryItem itemArray:(NSArray*)itemArray{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tableName];
    NSInteger count = [itemArray count];
    for(int i = 0; i < count; i++){
        WXSqliteItem *item = [itemArray objectAtIndex:i];
        [sql appendString:[self updateSqlForItem:item]];
        if(i < count -1){
            [sql appendString:@","];
        }
    }
    [sql appendString:@" WHERE "];
    
    WXSqliteItem *primary = primaryItem;
    [sql appendString:[self updateSqlForItem:primary]];
    BOOL ret = NO;
    
    char *errorMsg = NULL;
    if(sqlite3_exec(_dataBase, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
        ret = YES;
    }else{
        if(errorMsg){
            KFLog_Normal(YES, @"update data eorr = %s",errorMsg);
        }
    }
    
    return ret;
}

- (BOOL)deleteData:(NSString*)tableName itemDataArray:(NSArray*)itemArray{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE ",tableName];
    NSInteger count = [itemArray count];
    for(NSInteger index = 0; index < count; index++){
        WXSqliteItem *item = [itemArray objectAtIndex:index];
        NSString *aStr = [self updateSqlForItem:item];
        if(index != 0){
            [sql appendString:@" OR "];
        }
        [sql appendString:aStr];
    }
    char *errorMsg;
    BOOL ret = NO;
    if (sqlite3_exec(_dataBase, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
        ret = YES;
    }else{
        if(errorMsg){
            KFLog_Normal(YES, @"delete error:%s",errorMsg);
        }
    }
    return ret;
}

- (BOOL)deleteTableName:(NSString*)tableName PrimaryIDArray:(NSInteger*)primaryArray rowNumber:(NSInteger)number{
    NSMutableArray *itemArray = [NSMutableArray array];
    for(NSInteger i = 0; i < number; i++){
        NSInteger primaryID = primaryArray[i];
        WXSqliteItem *item = [[WXSqliteItem alloc] init];
        item.identifier = kPrimaryKey;
        item.data = [NSNumber numberWithInteger:primaryID];
        [itemArray addObject:item];
    }
    return [self deleteData:tableName itemDataArray:itemArray];
}
@end
