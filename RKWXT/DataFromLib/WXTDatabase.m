//
//  WXTDatabase.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTDatabase.h"
#import "DBCommon.h"
#import "EGODatabase.h"
#import "CallHistoryEntity.h"
#import "WXTUserOBJ.h"
@interface WXTDatabase(){
    EGODatabase * _database;
}

@end

@implementation WXTDatabase

-(id)init{
    @synchronized(self){
        if (self == nil) {
            self = [super init];
        }
    }
    return  self;
}

+(instancetype)shareDatabase{
    static dispatch_once_t onceToken;
    static WXTDatabase *database = nil;
    dispatch_once(&onceToken,^{
        database = [[WXTDatabase alloc] init];
    });
    return database;
}

-(BOOL)createDatabase:(NSString *)dbName{
    if(!dbName){
        return NO;
    }
    NSString * dbPath = [NSString stringWithFormat:@"%@/%@.sqlite",DOC_PATH,dbName];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _database = [EGODatabase databaseWithPath:dbPath];
    });
    if ([_database open]) {
        return YES;
    }
    return NO;
}

-(BOOL)checkWXTDBVersion{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if ([_database executeUpdate:kWXTDBVersionTable]) {
            if ([self insertDBVersion]) {
                NSLog(@"db version init success");
                return YES;
            }else{
                NSLog(@"db version init success");
                return NO;
            }
        }
        NSLog(@"db version table create success^^");
        return NO;
    }else{
        NSLog(@"database open error!!!%@",[_database lastErrorMessage]);
        return NO;
    }
}

-(BOOL)validateWXTTable:(NSString*)tableName{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if ([_database executeUpdate:[NSString stringWithFormat:kWXTSelectTable,tableName]]) {
            NSLog(@"%@ create success",tableName);
            return YES;
        }else{
            NSLog(@"%@ create error:%@",tableName,[_database lastErrorMessage]);
            return NO;
        }
    }else{
        NSLog(@"database open error!!!%@",[_database lastErrorMessage]);
        return NO;
    }
}

-(BOOL)insertDBVersion{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if ([self validateWXTTable:kDBVersion]) {
            if ([_database executeUpdate:[NSString stringWithFormat:kWXTInsertDBVersion,kDBVersion,kDBDateTime]]) {
                NSLog(@"data version insert success");
                return YES;
            }else{
                NSLog(@"data version insert error:%@",[_database lastErrorMessage]);
                return NO;
            }
        }else{
            NSLog(@"data version insert error:%@",[_database lastErrorMessage]);
            return NO;
        }
    }else{
        NSLog(@"database open error!!!%@",[_database lastErrorMessage]);
        return NO;
    }
}

-(NSInteger)getDBVersion{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        EGODatabaseResult * result = [_database executeQuery:kWXTSelectDBVersion];
        if ([result errorCode] == 0){
            EGODatabaseRow *row = [result firstRow];
            NSInteger version = [row intForColumn:@"version"];
            return version;
        }else{
            NSLog(@"db version select error!!!%i no such table or version",[_database lastErrorCode]);
            return YES;
        }
    }else{
        NSLog(@"db version open error!!!");
        return 0;
    }
}

-(BOOL)createWXTTable{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        [self checkWXTDBVersion];
        if ([_database executeUpdate:kWXTCallTable] && [_database executeUpdate:kWXTBookTable] && [_database executeUpdate:kWXTUserSettingTable]&& [_database executeUpdate:kWXTBookGroupTable]) {
            NSLog(@"%s用户数据库表创建成功",__FUNCTION__);
            return YES;
        }else{
            NSLog(@"%s数据库表创建失败",__FUNCTION__);
            return NO;
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
        return NO;
    }
}

-(void)insertCallHistory:(NSString*)aName telephone:(NSString *)aTelephone date:(NSString*)aDate type:(int)aType{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if ([self validateWXTTable:kWXTCall_Table]) {
            EGODatabaseResult * result = [_database executeQuery:[NSString stringWithFormat:kWXTInsertCallHistory,aName,aTelephone,aDate,aType]];
            if ([result errorCode] == 0) {
                [NOTIFY_CENTER postNotificationName:D_Notification_Name_CallRecordAdded object:nil];
                NSLog(@"%s用户通话记录插入success:%lu",__FUNCTION__,[result count]);
            }else{
                NSLog(@"%s用户通话记录插入error:%i",__FUNCTION__,[result errorCode]);
            }
        }else{
            [self createWXTTable];
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
}

-(NSMutableArray *)queryCallHistory{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        EGODatabaseResult * result = [_database executeQuery:kWXTQueryCallHistory];
        if ([result errorCode] == 0) {
            NSMutableArray *mutableArr = [NSMutableArray array];
            for (int i= 0 ; i < [result count]; i++) {
                EGODatabaseRow * databaseRow = [result rowAtIndex:i];
                NSString * name = [databaseRow stringForColumn:kWXTCall_Column_Name];
                NSString * telephone = [databaseRow stringForColumn:kWXTCall_Column_Telephone];
                NSString * date = [databaseRow stringForColumn:kWXTCall_Column_Date];
                int type = [databaseRow intForColumn:kWXTCall_Column_Date];
                CallHistoryEntity * entity = [[CallHistoryEntity alloc]initWithName:name telephone:telephone date:date type:type];
                [mutableArr addObject:entity];
            }
//            [NOTIFY_CENTER postNotificationName:D_Notification_Name_CallRecordLoadFinished object:nil];
            NSLog(@"%s用户通话记录查询success:%lu",__FUNCTION__,[result count]);
            return mutableArr;
        }else{
            NSLog(@"%s用户通话记录查询error:%i",__FUNCTION__,[result errorCode]);
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
    return nil;
}

-(void)delCallHistory:(NSString*)telephone{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        EGODatabaseResult * result = [_database executeQuery:[NSString stringWithFormat:kWXTDelCallHistory,telephone]];
        if ([result errorCode] == 0) {
            NSLog(@"%s用户通话记录删除success:%lu",__FUNCTION__,[result count]);
        }else{
            NSLog(@"%s用户通话记录删除error:%i",__FUNCTION__,[result errorCode]);
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
}

#pragma mark database callback
-(void)wxtCreateTableSuccess{
    if (_delegate && [_delegate respondsToSelector:@selector(wxtCreateTableSuccess)]){
        [_delegate wxtCreateTableSuccess];
    }
}

-(void)wxtCreateTableFaild{
    if (_delegate && [_delegate respondsToSelector:@selector(wxtCreateTableFaild)]){
        [_delegate wxtCreateTableFaild];
    }
}

@end
