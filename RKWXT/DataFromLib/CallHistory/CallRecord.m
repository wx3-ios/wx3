//
//  CallHistoryModel.m
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CallRecord.h"
#import "EGODatabase.h"
#import "WXTDatabase.h"
#import "EGODatabaseResult.h"
#import "ServiceCommon.h"
#import "DBCommon.h"
@interface CallRecord(){
    NSMutableArray *_callHistoryList;
    BOOL _isAddCallHistory;// 标记添加成功、失败
}
@end

@implementation CallRecord
@synthesize callHistoryList = _callHistoryList;
@synthesize wxtPath = _wxtPath;

- (void)dealloc{
    [self removeNotification];
}

+ (CallRecord*)sharedCallRecord{
    static dispatch_once_t onceToken;
    static CallRecord *sharedInstace = nil;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[CallRecord alloc] init];
    });
    return sharedInstace;
}

- (id)init{
    if(self = [super init]){
        _callHistoryList = [NSMutableArray array];
        _database = [WXTDatabase shareDatabase];
        _database.delegate = self;
        NSString * wxtId = [WXTUserOBJ sharedUserOBJ].wxtID;
        _wxtPath = [NSString stringWithFormat:@"%@/%@/db/%@.sqlite",DOC_PATH,wxtId,wxtId];
        _database.dbPath = _wxtPath;
        [self loadAllCallRecord];
        [self addNotification];
    }
    return self;
}

#pragma mark - 通话记录【通知事件处理】
- (void)addNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadAllCallRecord) name:D_Notification_Name_CallRecordLoadFinished object:nil];
    [notificationCenter addObserver:self selector:@selector(loadSimpleCallRecord:) name:D_Notification_Name_CallRecordAdded object:nil];
}

-(void)loadSimpleCallRecord:(NSNotification*)notification{
    CallHistoryEntity * record = notification.object;
    if(record != NULL){
//        [_callHistoryList insertObject:record atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordLoadFinished object:record];
        DDLogDebug(@"%@号码查询成功",record.phoneNumber);
    }
    
}
- (void)loadAllCallRecord{
    [_callHistoryList removeAllObjects];
    [_database createWXTTable:kWXTCallTable finishedBlock:^(void){
        EGODatabaseResult * result = [_database.database executeQuery:kWXTQueryCallHistory];
        if ([result errorCode] == 0) {
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
                [_callHistoryList addObject:entity];
            }
        }
    }];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通话记录【增删改查】
- (void)addSingleCallRecord:(CallHistoryEntity*)record{
    if (!record){NSAssert(record == nil, @"通话记录为空，不能添加到数据库中"); return;};
//    NSArray * callArray = [self recordForPhoneNumber:record.phoneNumber];
//    if (callArray.count != 0){return;}
    BOOL result = [self addRecord:record.phoneNumber recordType:record.callType startTime:record.callStartTime duration:record.duration];
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordAdded object:record];
    }
}

- (BOOL)addRecord:(NSString*)phoneNumber recordType:(E_CallHistoryType)recordType
        startTime:(NSString*)startTime duration:(NSInteger)duration{
    __block NSInteger result;
    [_database createWXTTable:kWXTCallTable finishedBlock:^(void){
        EGODatabaseResult * dbResult = [_database.database executeQuery:[NSString stringWithFormat:kWXTInsertCallHistory,@"我信",phoneNumber,startTime,(long)duration,recordType]];
        result = [dbResult errorCode];
    }];
    if (result != 0) {
        DDLogError(@"通话记录添加失败");
        return NO;
    }
    DDLogError(@"%@通话记录添加成功",phoneNumber);
    return YES;
}

-(void)addCallRecordCount:(CallHistoryEntity*)callHistory{
    
}

- (BOOL)deleteCallRecord:(NSInteger)recordUID{
    __block NSInteger result;
    [_database createWXTTable:kWXTCallTable finishedBlock:^(void){
        EGODatabaseResult * dbResult = [_database.database executeQuery:[NSString stringWithFormat:kWXTDelCallHistory,(long)recordUID]];
        result = [dbResult errorCode];
    }];
    if(result != 0){
        DDLogError(@"删除通话记录失败~ ret=%d",(int)result);
        return NO;
    }
    for (CallHistoryEntity *entity in _callHistoryList) {
        if (entity.UID == recordUID){
            [_callHistoryList removeObject:entity];
            break;
        }
    }
    return YES;
}

#pragma mark 通话记录条件查询
- (NSArray*)recordForPhoneNumber:(NSString*)phoneNumber{
    if(phoneNumber){
        return [self recordForPhoneNumbers:[NSArray arrayWithObject:phoneNumber]];
    }
    return nil;
}

- (NSArray*)recordForPhoneNumbers:(NSArray*)phoneNumbers{
    NSMutableArray *history = [NSMutableArray array];
    for(CallHistoryEntity *entity in _callHistoryList){
        if([phoneNumbers indexOfObject:entity.phoneNumber]!= NSNotFound){
            [history addObject:entity];
        }
    }
    if([history count] > 0){
        return history;
    }
    return nil;
}

#pragma mark - WXTDatabaseDelegate
-(void)wxtDatabaseOpenSuccess{
    DDLogError(@"%@ db path open success!",_wxtPath);
}

-(void)wxtDatabaseOpenFaild:(WXTDBMessage)faildMsg{
    [_database createDatabase:_wxtPath];
    DDLogError(@"%@database faild error:%i",_wxtPath,faildMsg);
}

-(void)wxtCreateTableFaild:(WXTDBMessage)faildMsg{
    [_database createWXTTable:kWXTCallTable];
    DDLogError(@"%stable faild error:%i",__FUNCTION__,faildMsg);
}

-(void)wxtCreateTableSuccess{
    DDLogError(@"%stable create success!!!",__FUNCTION__);
}

@end
