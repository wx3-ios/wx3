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
    BOOL _isAddCallHistory;
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
        [self loadCallRecord];
    }
    return self;
}

- (void)loadCallRecord{
    _callHistoryList = [[WXTDatabase shareDatabase] queryCallHistory];
}

- (void)removeCallRecorder{
    [_callHistoryList removeAllObjects];
}

- (void)addNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(callRecordBegin) name:D_Notification_Name_CallRecord_LoadBegin object:nil];
    [notificationCenter addObserver:self selector:@selector(loadSimpleCallRecord:) name:D_Notification_Name_CallRecord_SingleLoad object:nil];
    [notificationCenter addObserver:self selector:@selector(loadCallRecord) name:D_Notification_Name_CallRecordLoadFinished object:nil];
    [notificationCenter addObserver:self selector:@selector(addCallRecord:) name:D_Notification_Name_CallRecordAdded object:nil];
}

- (void)addSingleCallRecord:(CallHistoryEntity*)record{
    if (!record){NSAssert(record == nil, @"通话记录为空，不能添加到数据库中"); return;};
    [_callHistoryList insertObject:record atIndex:0];
    BOOL result = [self addRecord:record.phoneNumber recordType:record.callType startTime:record.callStartTime duration:record.duration];
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordAdded object:record];
    }
}

- (void)callRecordBegin{
    [_callHistoryList removeAllObjects];
}

- (void)loadSimpleCallRecord:(NSNotification*)notification{
    //    NSArray * paramArray = notification.object;
    //    CallHistoryEntity * record = [CallHistoryEntity recordWithParamArray:paramArray];
    //    if(record){
    //        [self addCallRecord:record];
    //    }
}

- (void)callRecordComplete{
}

- (void)addCallRecord:(NSNotification*)notification{
    NSArray * pramArray = notification.object;
    CallHistoryEntity * record = [CallHistoryEntity recordWithParamArray:pramArray];
    if(record){
        NSLog(@"record uid%li",record.UID);
    }
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)addRecord:(NSString*)phoneNumber recordType:(E_CallHistoryType)recordType
        startTime:(NSString*)startTime duration:(NSInteger)duration{
    __block NSInteger result;
    [_database createWXTTable:kWXTCallTable finishedBlock:^(void){
        result = [_database insertCallHistory:@"我信" telephone:phoneNumber startTime:startTime duration:duration type:E_CallHistoryType_MakingReaded];
    }];
    if (result != 0) {
        NSLog(@"通话记录添加失败");
        return NO;
    }
    NSLog(@"%@通话记录添加成功",phoneNumber);
    return YES;
}

- (BOOL)deleteCallRecord:(NSInteger)recordUID{
    NSInteger result = [[WXTDatabase shareDatabase] delCallHistory:recordUID];
    if(result != 0){
        KFLog_Normal(YES, @"删除通话记录失败~ ret=%d",(int)ret);
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

#pragma mark 通话记录查询~
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

-(void)wxtDatabaseOpenSuccess{
    DDLogError(@"%sdabase open success!",__FUNCTION__);
}

-(void)wxtDatabaseOpenFaild:(WXTDBMessage)faildMsg{
    [_database createDatabase:[WXTUserOBJ sharedUserOBJ].wxtID];
    DDLogError(@"%sdatabase faild error:%i",__FUNCTION__,faildMsg);
}

-(void)wxtCreateTableFaild:(WXTDBMessage)faildMsg{
    [_database createWXTTable:kWXTCallTable];
    DDLogError(@"%stable faild error:%i",__FUNCTION__,faildMsg);
}

-(void)wxtCreateTableSuccess{
    switch (_callHandle) {
        case AddCallRecord:
//            EGODatabaseResult * result = [_database.database executeQuery:[NSString stringWithFormat:kWXTInsertCallHistory,aName,aTelephone,aStartTime,aDuration,aType]];
//            _isAddCallHistory = [result errorCode];
            break;
        case DelSimpleCallRecord:
            break;
        default:
            break;
    }
    DDLogError(@"%stable create success!!!",__FUNCTION__);
}

@end
