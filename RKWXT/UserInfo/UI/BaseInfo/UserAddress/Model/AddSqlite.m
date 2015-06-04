//
//  AddSqlite.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AddSqlite.h"
#import "AddressEntity.h"

@implementation AddSqlite
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
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS NEWADDRESSLIST (ID INTEGER PRIMARY KEY AUTOINCREMENT, AddressUserName TEXT, AddressUserPhone TEXT ,AddressAdd TEXT ,AddressBSel TEXT)";
    [self execSql:sqlCreateTable];
}

-(NSMutableArray *)selectAll{
    NSString *sqlQuery = @"SELECT * FROM NEWADDRESSLIST";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *_userName = [[NSString alloc] initWithUTF8String:name];
            
            char *phone = (char *)sqlite3_column_text(statement, 2);
            NSString *_userPhone = [[NSString alloc] initWithUTF8String:phone];
            
            char *address = (char *)sqlite3_column_text(statement, 3);
            NSString *_address = [[NSString alloc] initWithUTF8String:address];
            
//            char *bsel = (char *)sqlite3_column_text(statement, 4);
//            NSString *_bsel = [[NSString alloc] initWithUTF8String:bsel];
            
            AddressEntity *entity = [[AddressEntity alloc] init];
            entity.userName = _userName;
            entity.userPhone = _userPhone;
            entity.address = _address;
            entity.bSel = @"1";
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
    int success2 = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL);
    if(success2 != SQLITE_OK){
        KFLog_Normal(YES,@"Error:failed to insert:testTable %s",err);
        sqlite3_close(db);
        return;
    }
    sqlite3_bind_text(statement, 1, [Address_UserName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [Address_UserPhone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [Address_Add UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [Address_BSel UTF8String], -1, SQLITE_TRANSIENT);
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

- (BOOL)changeTestListWith:(NSString*)userName phone:(NSString*)userPhone address:(NSString*)addStr sel:(NSString*)bsel{
    sqlite3_stmt *stmt = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"update NEWADDRESSLIST set AddressUserName = '%@' where AddressUserPhone = %@ where AddressAdd = '%@' where AddressBSel = '%@", userName, userPhone, addStr, bsel];
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                sqlite3_close(db);
                return YES;
            }
        }
    }else{
        NSAssert1(0,@"Error:%s",sqlite3_errmsg(db));
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return NO;
}

- (BOOL)deleteTestList:(AddressEntity *)deletList{
    sqlite3_stmt *statement;
    //组织SQL语句
    static char *sql = "delete from NEWADDRESSLIST  where AddressUserName = ? and AddressUserPhone = ? and AddressAdd = ? and AddressBSel = ?";
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:NEWADDRESSLIST");
        sqlite3_close(db);
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [deletList.userName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [deletList.userPhone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [deletList.address UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [deletList.bSel UTF8String], -1, SQLITE_TRANSIENT);
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
