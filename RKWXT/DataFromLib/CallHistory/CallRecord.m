//
//  CallHistoryModel.m
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CallRecord.h"
#import "it_lib.h"
#import "ServiceCommon.h"

@interface CallRecord(){
    NSMutableArray *_callHistoryList;
}
@end

@implementation CallRecord
@synthesize callHistoryList = _callHistoryList;

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
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
        _callHistoryList = [[NSMutableArray alloc] init];
        [self addOBS];
    }
    return self;
}

- (BOOL)loadRecord{
    SS_UINT32 ret = IT_LoadCallRecord();
    if(0 != ret){
        KFLog_Normal(YES, @"load call record failed = %d",ret);
        return NO;
    }
    return YES;
}

- (void)removeCallRecorder{
    [_callHistoryList removeAllObjects];
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(callRecordBegin) name:D_Notification_Name_CallRecord_LoadBegin object:nil];
    [notificationCenter addObserver:self selector:@selector(callRecordLoadSingle:) name:D_Notification_Name_CallRecord_SingleLoad object:nil];
    [notificationCenter addObserver:self selector:@selector(callRecordComplete) name:D_Notification_Name_CallRecord_LoadFinish object:nil];
    [notificationCenter addObserver:self selector:@selector(addACallRecord:) name:D_Notification_Name_CallRecord_F_Added object:nil];
}

- (void)addRecord:(CallHistoryEntity*)record{
    [_callHistoryList insertObject:record atIndex:0];
}

- (void)callRecordBegin{
    [_callHistoryList removeAllObjects];
}

- (void)callRecordLoadSingle:(NSNotification*)notification{
    NSArray *pramArray = notification.object;
    CallHistoryEntity *record = [CallHistoryEntity recordWithPramArray:pramArray];
    if(record){
        [self addRecord:record];
    }
}

- (void)callRecordComplete{
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordLoadFinished object:nil];
}

- (void)addACallRecord:(NSNotification*)notification{
    NSArray *pramArray = notification.object;
    CallHistoryEntity *record = [CallHistoryEntity recordWithPramArray:pramArray];
    if(record){
        [self addRecord:record];
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordAdded object:record];
    }
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 通话记录操作~
- (BOOL)loadCallRecord{
    NSInteger ret = IT_LoadCallRecord();
    if(ret != 0){
        KFLog_Normal(YES, @"加载通话记录失败~ ret=%d",(int)ret);
        return NO;
    }
    return YES;
}

- (BOOL)addRecord:(NSString*)phoneNumber recordType:(E_CallHistoryType)recordType
                startTime:(NSInteger)startTime duration:(NSInteger)duration{
    if(duration == 0){
        duration = 1;
    }
    NSInteger UID = IT_AddCallRecord([phoneNumber cStringUsingEncoding:NSUTF8StringEncoding], recordType, (SS_INT32)startTime, (SS_UINT32)duration);
    if(UID >= 0){
        CallHistoryEntity *entity = [[CallHistoryEntity alloc] init] ;
        [entity setUID:UID];
        [entity setPhoneNumber:phoneNumber];
        [entity setHistoryType:recordType];
        [entity setStartTime:[NSDate dateWithTimeIntervalSince1970:startTime]];
        [entity setDuration:duration];
        [_callHistoryList insertObject:entity atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_CallRecordAdded object:nil userInfo:nil];
        KFLog_Normal(YES, @"增加通话记录成功 uid = %d",(int)UID);
        return YES;
    }else{
        KFLog_Normal(YES, @"增加通话记录失败~ ret = %d",(int)UID);
    }
    return NO;
}

- (BOOL)deleteCallRecord:(NSInteger)recordUID{
    NSInteger ret = IT_DelCallRecord((SS_UINT32)recordUID);
    if(ret != 0){
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
@end
