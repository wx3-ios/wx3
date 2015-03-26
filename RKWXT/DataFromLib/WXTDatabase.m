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

-(BOOL)createWXTTable{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if ([_database executeUpdate:kWXTCallTable]) {
            NSLog(@"%s用户通话数据表创建成功",__FUNCTION__);
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
        EGODatabaseResult * result = [_database executeQuery:[NSString stringWithFormat:kWXTInsertCallHistory,aName,aTelephone,aDate,aType]];
        if ([result errorCode] == 0) {
            NSLog(@"%s用户通话记录插入success:%lu",__FUNCTION__,[result count]);
        }else{
            NSLog(@"%s用户通话记录插入error:%i",__FUNCTION__,[result errorCode]);
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
@end
