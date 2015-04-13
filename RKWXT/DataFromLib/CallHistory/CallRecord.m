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
        _database = [WXTDatabase shareDatabase];
        _database.delegate = self;
        _database.dbName = [WXUserOBJ sharedUserOBJ].woxinID;
        _callHistoryList = [_database queryCallHistory];
//        [self loadCallRecord];
    }
    return self;
}

- (void)addNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(callRecordBegin) name:D_Notification_Name_CallRecord_LoadBegin object:nil];
    [notificationCenter addObserver:self selector:@selector(loadSimpleCallRecord:) name:D_Notification_Name_CallRecord_SingleLoad object:nil];
    [notificationCenter addObserver:self selector:@selector(loadCallRecord) name:D_Notification_Name_CallRecordLoadFinished object:nil];
    [notificationCenter addObserver:self selector:@selector(addCallRecord:) name:D_Notification_Name_CallRecordAdded object:nil];
}

-(void)addCallRecordCount:(CallHistoryEntity*)callHistory{
    
}

- (void)removeCallRecorder{
    [_callHistoryList removeAllObjects];
}

- (void)callRecordBegin{
    [_callHistoryList removeAllObjects];
}

- (void)callRecordComplete{
}

- (void)loadSimpleCallRecord:(NSNotification*)notification{
    //    NSArray * paramArray = notification.object;
    //    CallHistoryEntity * record = [CallHistoryEntity recordWithParamArray:paramArray];
    //    if(record){
    //        [self addCallRecord:record];
    //    }
}

- (void)addCallRecord:(NSNotification*)notification{
    NSArray * pramArray = notification.object;
    CallHistoryEntity * record = [CallHistoryEntity recordWithParamArray:pramArray];
    if(record){
        DDLogDebug(@"record uid%li",record.UID);
    }
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通话记录【增删改查】
- (void)addSingleCallRecord:(CallHistoryEntity*)record{
    if (!record){NSAssert(record == nil, @"通话记录为空，不能添加到数据库中"); return;};
//    NSArray * callArray = [self recordForPhoneNumber:record.phoneNumber];
//    if (callArray.count != 0){return;}
    [_callHistoryList insertObject:record atIndex:0];
    BOOL result = [self addRecord:record.phoneNumber recordType:record.callType startTime:record.callStartTime duration:record.duration];
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordAdded object:record];
    }
}

- (BOOL)addRecord:(NSString*)phoneNumber recordType:(E_CallHistoryType)recordType
        startTime:(NSString*)startTime duration:(NSInteger)duration{
    __block NSInteger result;
    [_database createWXTTable:kWXTCallTable finishedBlock:^(void){
        EGODatabaseResult * dbResult = [_database.database executeQuery:[NSString stringWithFormat:kWXTInsertCallHistory,@"我信",phoneNumber,startTime,duration,recordType]];
        result = [dbResult errorCode];
    }];
    if (result != 0) {
        DDLogError(@"通话记录添加失败");
        return NO;
    }
    DDLogError(@"%@通话记录添加成功",phoneNumber);
    return YES;
}

- (BOOL)deleteCallRecord:(NSInteger)recordUID{
    __block NSInteger result;
    [_database createWXTTable:kWXTCallTable finishedBlock:^(void){
        EGODatabaseResult * dbResult = [_database.database executeQuery:[NSString stringWithFormat:kWXTDelCallHistory,recordUID]];
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

- (void)loadCallRecord{
//    if (_database.isDBOpen) {
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
//    }
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
    DDLogError(@"%sdabase open success!",__FUNCTION__);
}

-(void)wxtDatabaseOpenFaild:(WXTDBMessage)faildMsg{
    [_database createDatabase:_database.dbName];
    DDLogError(@"%sdatabase faild error:%i",__FUNCTION__,faildMsg);
}

-(void)wxtCreateTableFaild:(WXTDBMessage)faildMsg{
    [_database createWXTTable:kWXTCallTable];
    DDLogError(@"%stable faild error:%i",__FUNCTION__,faildMsg);
}

-(void)wxtCreateTableSuccess{
    DDLogError(@"%stable create success!!!",__FUNCTION__);
}

@end
