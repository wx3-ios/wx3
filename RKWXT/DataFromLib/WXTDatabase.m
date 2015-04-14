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
@interface WXTDatabase(){
}

@end

@implementation WXTDatabase
@synthesize database = _database;
@synthesize dbPath = _dbPath;

-(id)init{
    @synchronized(self){
        if (self == [super init]) {
        }
    }
    return  self;
}

+(instancetype)shareDatabase{
    static dispatch_once_t onceToken;
    static WXTDatabase *database = nil;
    dispatch_once(&onceToken,^{
        database = [[WXTDatabase alloc] init];
        [[self alloc] createDatabase:database.dbPath];
    });
    return database;
}

-(BOOL)createDatabase:(NSString *)aDBPath{
    if(!aDBPath){
        [self wxtDatabaseOpenFaild:WXTDBPathNotExit];
        return NO;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * rootPath = [aDBPath stringByDeletingLastPathComponent];
    BOOL rootRet = [fileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (rootRet) {
        DDLogDebug(@"%@ create root success",rootPath);
    }else{
        [self wxtDatabaseOpenFaild:WXTDBPathNotExit];
        DDLogDebug(@"%@ create root faild",aDBPath);
        return NO;
    }
//    BOOL fileRet =[fileManager createFileAtPath:aDBPath contents:nil attributes:nil];
//    if (!fileRet) {
//        [self wxtDatabaseOpenFaild:WXTDBFileNotExit];
//        return NO;
//    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _database = [EGODatabase databaseWithPath:aDBPath];
    });
    if ([_database open]) {
        DDLogDebug(@"%@db path open success",aDBPath);
        [self wxtDatabaseOpenSuccess];
        return _isDBOpen;
    }/*else if([_database lastErrorCode] == 14){
        [self wxtDatabaseOpenFaild:WXTDBPathNotExit];
        return NO;
    }*/else{
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
    if (![self createDatabase:_dbPath]) {
        [self wxtDatabaseOpenFaild:WXTDBFileNotExit];
    }
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
//-(void)wxtDatabase:(NSString*)dbPath{
//    if (_delegate && [_delegate respondsToSelector:@selector(wxtDatabase:)]){
//        [_delegate wxtDatabase:dbPath];
//    }
//}

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

@end
