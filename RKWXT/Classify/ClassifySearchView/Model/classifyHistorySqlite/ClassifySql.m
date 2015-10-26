//
//  ClassifySql.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifySql.h"
#import "ClassifySqlEntity.h"

@implementation ClassifySql
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
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS CLASSIFY (ID INTEGER PRIMARY KEY AUTOINCREMENT, RecordName TEXT , RecordTime TEXT , RecordID TEXT , Other TEXT)";
    [self execSql:sqlCreateTable];
}

-(NSMutableArray *)selectAll{
    NSString *sqlQuery = @"SELECT * FROM CLASSIFY";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 1);   //记录的名字
            NSString *_name = [[NSString alloc] initWithUTF8String:name];
            
            char *time = (char *)sqlite3_column_text(statement, 2);   //记录的时间
            NSString *_rtime = [[NSString alloc] initWithUTF8String:time];
            
            char *recordID = (char *)sqlite3_column_text(statement, 3); //记录的ID
            NSString *_recordID = [[NSString alloc] initWithUTF8String:recordID];
            
            char *other = (char *)sqlite3_column_text(statement, 3);   //预留字段
            NSString *_other = [[NSString alloc] initWithUTF8String:other];
        
            ClassifySqlEntity *entity = [[ClassifySqlEntity alloc] init];
            entity.recordName = _name;
            entity.recordTime = [_rtime integerValue];
            entity.recordID = _recordID;
            entity.other = _other;
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
    //    char *err = NULL;
    int success2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL);
    if(success2 != SQLITE_OK){
        KFLog_Normal(YES,@"Error:failed to insert:testTable %s",err);
        sqlite3_close(db);
        return;
    }
    sqlite3_bind_text(statement, 1, [RecordName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [RecordTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [Other UTF8String], -1, SQLITE_TRANSIENT);
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
    static char *sql = "delete from CLASSIFY  where RecordName = ?";
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:CLASSIFY");
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
    static char *sql = "DROP TABLE CLASSIFY";
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:CLASSIFY");
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
