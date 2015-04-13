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
}

@end

@implementation WXTDatabase
@synthesize database = _database;
-(id)init{
    @synchronized(self){
        if (self == [super init]) {
            _dbName = [WXUserOBJ sharedUserOBJ].woxinID;
            if (_dbName != NULL) {
                [self createDatabase:_dbName];
            }
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
        [self wxtDatabaseOpenFaild:WXTDatabaseFaild];
        return NO;
    }
    NSString * rootPath = [DOC_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/db",[WXTUserOBJ sharedUserOBJ].wxtID]];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (ret) {
        DDLogDebug(@"%@ create root success",rootPath);
    }else{
        DDLogDebug(@"%@ create root faild",rootPath);
        return NO;
    }
    NSString * dbPath = [NSString stringWithFormat:@"%@/%@.sqlite",rootPath,dbName];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _database = [EGODatabase databaseWithPath:dbPath];
    });
    if ([_database open]) {
        [self wxtDatabaseOpenSuccess];
        return _isDBOpen;
    }else{
        [self wxtDatabaseOpenFaild:WXTDatabaseFaild];
        return NO;
    }
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
        DDLogError(@"%sdatabase open error:%@",__FUNCTION__,[_database lastErrorMessage]);
        return NO;
    }
}

-(BOOL)validateWXTTable:(NSString*)tableName{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if ([_database executeUpdate:[NSString stringWithFormat:kWXTSelectTable,tableName]]) {
            NSLog(@"%@ validate success",tableName);
            return YES;
        }else{
            NSLog(@"%@ validate error:%@",tableName,[_database lastErrorMessage]);
            return NO;
        }
    }else{
        DDLogError(@"%sdatabase open error:%@",__FUNCTION__,[_database lastErrorMessage]);
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
        DDLogError(@"%sdatabase open error:%@",__FUNCTION__,[_database lastErrorMessage]);
        return NO;
    }
}

-(NSInteger)getDBVersion{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        if (![self validateWXTTable:kWXTDBVersion_Table]) {
            NSLog(@"DBVersion table is not exit!!!");
            return 0;
        }
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
        DDLogError(@"%sdatabase open error:%@",__FUNCTION__,[_database lastErrorMessage]);
        return 0;
    }
}

-(BOOL)createWXTTable:(NSString*)tableSql{
    if ([_database executeUpdate:tableSql]) {
        [self wxtCreateTableSuccess];
        return YES;
    }else{
        [self wxtCreateTableFaild:WXTTableFaild];
        return NO;
    }
}

-(BOOL)createWXTTable:(NSString*)tableSql finishedBlock:(Callback)callBack{
    if ([self createWXTTable:tableSql]) {
        callBack();
        return YES;
    }
    return NO;
}

#pragma mark database callback
-(void)wxtDatabaseOpenSuccess{
    if (_delegate && [_delegate respondsToSelector:@selector(wxtDatabaseOpenSuccess)]){
        [_delegate wxtDatabaseOpenSuccess];
        _isDBOpen = YES;
        return;
    }
    _isDBOpen = NO;
}

-(void)wxtDatabaseOpenFaild:(WXTDBMessage)faildMsg{
    if (_delegate && [_delegate respondsToSelector:@selector(wxtDatabaseOpenFaild:)]){
        [_delegate wxtDatabaseOpenFaild:faildMsg];
    }
}

-(void)wxtCreateTableSuccess{
    if (_delegate && [_delegate respondsToSelector:@selector(wxtCreateTableSuccess)]){
        [_delegate wxtCreateTableSuccess];
        _isTableOpen = YES;
        return;
    }
    _isTableOpen = NO;
}

-(void)wxtCreateTableFaild:(WXTDBMessage)faildMsg{
    if (_delegate && [_delegate respondsToSelector:@selector(wxtCreateTableFaild:)]){
        [_delegate wxtCreateTableFaild:faildMsg];
    }
}

#pragma mark - 通话历史记录
-(NSMutableArray *)queryCallHistory{
    if ([self createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID]) {
        EGODatabaseResult * result = [_database executeQuery:kWXTQueryCallHistory];
        if ([result errorCode] == 0) {
            NSMutableArray *mutableArr = [NSMutableArray array];
            for (int i= 0 ; i < [result count]; i++) {
                EGODatabaseRow * databaseRow = [result rowAtIndex:i];
                NSInteger cid = [databaseRow intForColumn:kWXTCall_Column_CID];
                //                NSString * name = [databaseRow stringForColumn:kWXTCall_Column_Name];
                NSString * telephone = [databaseRow stringForColumn:kWXTCall_Column_Telephone];
                NSString * startTime = [databaseRow stringForColumn:kWXTCall_Column_Date];
                NSInteger  duration = [databaseRow intForColumn:kWXTCall_Column_Duration];
                int type = [databaseRow intForColumn:kWXTCall_Column_Date];
                NSArray * array = [NSArray arrayWithObjects:[NSNumber numberWithInteger:cid],telephone,startTime,[NSNumber numberWithInteger:duration],[NSNumber numberWithInt:type], nil];
                CallHistoryEntity * entity = [CallHistoryEntity recordWithParamArray:array];
                [mutableArr addObject:entity];
            }
            NSLog(@"%s用户通话记录查询success:%lu",__FUNCTION__,[result count]);
            return mutableArr;
        }else{
            NSLog(@"%s用户通话记录查询error:%i",__FUNCTION__,[result errorCode]);
        }
    }else{
        DDLogError(@"%sdatabase open error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
    return nil;
}



@end
