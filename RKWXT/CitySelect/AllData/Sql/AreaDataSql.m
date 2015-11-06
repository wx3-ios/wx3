//
//  AreaDataSql.m
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AreaDataSql.h"
#import "AreaEntity.h"

@implementation AreaDataSql
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
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS AREA (ID INTEGER PRIMARY KEY AUTOINCREMENT, AREAID TEXT , AREANAME TEXT , AREAPRESENT TEXT , Other1 TEXT , Other2 TEXT)";
    [self execSql:sqlCreateTable];
}

-(NSMutableArray *)selectAll{
    NSString *sqlQuery = @"SELECT * FROM AREA";
    sqlite3_stmt *statement;
    
    NSInteger count = 0;
    if(sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *areaID = (char *)sqlite3_column_text(statement, 1);
            NSString *_areaID = [[NSString alloc] initWithUTF8String:areaID];
            
            char *areaName = (char *)sqlite3_column_text(statement, 2);
            NSString *_areaName = [[NSString alloc] initWithUTF8String:areaName];
            
            char *areaPresent = (char *)sqlite3_column_text(statement, 3);
            NSString *_areaPresent = [[NSString alloc] initWithUTF8String:areaPresent];
            
            char *other1 = (char *)sqlite3_column_text(statement, 4);   //预留字段1
            NSString *_other1 = [[NSString alloc] initWithUTF8String:other1];
            
            char *other2 = (char *)sqlite3_column_text(statement, 5);   //预留字段2
            NSString *_other2 = [[NSString alloc] initWithUTF8String:other2];
            
            AreaEntity *entity = [[AreaEntity alloc] init];
            entity.areaID = [_areaID integerValue];
            entity.areaName = _areaName;
            entity.areaPresentID = [_areaPresent integerValue];
            [all addObject:entity];
            
            NSLog(@"===%ld",(long)count++);
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
    //    char *err = NULL;
    int success2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL);
    if(success2 != SQLITE_OK){
        KFLog_Normal(YES,@"Error:failed to insert:testTable %s",err);
        sqlite3_close(db);
        return;
    }
    sqlite3_bind_text(statement, 1, [AREAID UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [AREANAME UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [AREAPRESENT UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [Other1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [Other2 UTF8String], -1, SQLITE_TRANSIENT);
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

-(BOOL)deleteClassifyHistoryList:(NSString *)recordName{
    sqlite3_stmt *statement;
    //组织SQL语句
    static char *sql = "delete from AREA  where AREAID = ?";
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:AREA");
        sqlite3_close(db);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [recordName UTF8String], -1, SQLITE_TRANSIENT);
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

//有问题
-(BOOL)deleteAll{
    sqlite3_stmt *statement;
    //组织SQL语句
    static char *sql = "DROP TABLE AREA";
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:AREA");
        sqlite3_close(db);
        return NO;
    }
    
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
