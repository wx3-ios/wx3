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
    if ([_database open]) {
        if ([_database executeUpdate:kWXTCallTable]) {
            NSLog(@"%s用户通话数据表创建成功",__FUNCTION__);
            return YES;
        }else{
            NSLog(@"%s数据库表创建失败",__FUNCTION__);
            return NO;
        }
    }else{
        NSLog(@"%s数据库打开失败",__FUNCTION__);
        return NO;
    }
}

-(void)insertCallHistory:(NSString *)telephone date:(NSString*)date type:(int)type{
    if ([_database open]) {
        EGODatabaseResult * request = [_database executeQuery:[NSString stringWithFormat:@"INSERT INTO Call(telephone,date,type) values('%@','%@','%i')",telephone,date,type]];
        if ([request count] > 0) {
            NSLog(@"%s用户通话记录插入成功",__FUNCTION__);
        }
        NSLog(@"%s用户通话记录插入失败",__FUNCTION__);
    }else{
        NSLog(@"%s数据库创建失败",__FUNCTION__);
    }
}

-(void)queryCallHistory{
    
}

@end
