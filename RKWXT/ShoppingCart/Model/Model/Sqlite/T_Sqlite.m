//
//  T_Sqlite.m
//  Woxin3.0
//
//  Created by SHB on 15/1/28.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_Sqlite.h"

@implementation T_Sqlite
@synthesize all;

-(void)createOrOpendb{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docunments = [paths objectAtIndex:0];
    KFLog_Normal(YES,@"%@",docunments);
    
    NSString *database_path = [docunments stringByAppendingPathComponent:DBNAME];
    all = [[NSMutableArray alloc] init];
    if(sqlite3_open([database_path UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        KFLog_Normal(YES,@"打开数据库失败");
    }
}

-(void)createTable{
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS NEWMENUSTORE (ID INTEGER PRIMARY KEY AUTOINCREMENT, STOREGOODSNUM TEXT, STOREGOODSID TEXT ,STOREGOODSCOLOR TEXT)";
    [self execSql:sqlCreateTable];
}

-(NSMutableArray *)selectAll{
    NSString *sqlQuery = @"SELECT * FROM NEWMENUSTORE";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *num = (char *)sqlite3_column_text(statement, 1);
            NSString *_number = [[NSString alloc] initWithUTF8String:num];
            
            char *gid = (char *)sqlite3_column_text(statement, 2);
            NSString *_goodsID = [[NSString alloc] initWithUTF8String:gid];
            
            char *color = (char *)sqlite3_column_text(statement, 3);
            NSString *_colorText = [[NSString alloc] initWithUTF8String:color];
            
            KFLog_Normal(YES,@"number:%@ goodsID:%@",_number,_goodsID);
            T_MenuEntity *entity = [[T_MenuEntity alloc] init];
            entity.number = _number;
            entity.goodsID = _goodsID;
            entity.colorType = _colorText;
            [all addObject:entity];
        }
    }
    sqlite3_close(db);
    return all;
}

-(BOOL)execSql:(NSString *)sql{
    BOOL succeed = YES;
    char *err;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
        sqlite3_close(db);
        KFLog_Normal(YES,@"数据库操作失败:%s!",err);
        succeed = NO;
    }
    return succeed;
}

-(void)insert:(NSString *)sql{
    sqlite3_stmt *statement = NULL;
    char *err = NULL;
    int success2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL);
    if(success2 != SQLITE_OK){
        KFLog_Normal(YES,@"Error:failed to insert:testTable %s",err);
        sqlite3_close(db);
        return;
    }
    sqlite3_bind_text(statement, 1, [GoodsNumber UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [GoodsID UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [ColorText UTF8String], -1, SQLITE_TRANSIENT);
    success2 = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if(success2 == SQLITE_ERROR){
        KFLog_Normal(YES,@"Error: failed to insert into the database with message.%s",err);
        //关闭数据库
        sqlite3_close(db);
        return;
    }
    //关闭数据库
    sqlite3_close(db);
    return;
}

- (BOOL)deleteTestList:(T_MenuEntity *)deletList{
    sqlite3_stmt *statement;
    //组织SQL语句
    static char *sql = "delete from NEWMENUSTORE  where STOREGOODSNUM = ? and STOREGOODSID = ? and STOREGOODSCOLOR = ?";
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:NEWMENUSTORE");
        sqlite3_close(db);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [deletList.number UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [deletList.goodsID UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [deletList.colorType UTF8String], -1, SQLITE_TRANSIENT);
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    //如果执行失败
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to delete the database with message.");
        //关闭数据库
        sqlite3_close(db);
        return NO;
    }
    //执行成功后依然要关闭数据库
    sqlite3_close(db);
    return YES;
}

@end
