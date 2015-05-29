//
//  SysMsgOBS.m
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgOBS.h"
#import "ServiceCommon.h"
#import "SysMsgItem.h"
#import "SysMsgSqlite.h"

enum{
    E_PushType_RewardPacket = 1,//红包
    E_PushType_NormalMessage,
}E_PushType;

@implementation SysMsgOBS

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

+ (SysMsgOBS*)sharedSysMsgOBS{
    static dispatch_once_t onceToken;
    static SysMsgOBS *sharedSysMsgOBS = nil;
    dispatch_once(&onceToken, ^{
        sharedSysMsgOBS = [[SysMsgOBS alloc] init];
    });
    return sharedSysMsgOBS;
}

- (id)init{
    if(self = [super init]){
        [self addOBS];
    }
    return self;
}

- (void)showMsgPush:(NSArray*)pushArray{
    
}

- (void)showRewardPush:(NSArray*)rewardArray{
    
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(incommingPush:) name:D_Notification_Name_Lib_IncomePushInfo object:nil];
}

- (void)parseIncomePush:(NSArray*)pushOBJArray{
    NSMutableArray *rewardPacketList = [NSMutableArray array];
    NSMutableArray *messageList = [NSMutableArray array];
    for(NSDictionary *jsonDic in pushOBJArray){
        NSInteger msgType = [[jsonDic objectForKey:@"msg_type"] integerValue];
        switch (msgType) {
            case E_PushType_RewardPacket:
                [rewardPacketList addObject:jsonDic];
                break;
            case E_PushType_NormalMessage:
            {
                SysMsgItem *sysMsgItem = [SysMsgItem sysMsgItemWithPushDic:jsonDic];
                NSInteger index = [[SysMsgSqlite sharedSystemMessageSqlite] insertSysMsgItem:sysMsgItem];
                if(index < 0){
                    KFLog_Normal(YES, @"插入失败");
                }
                [sysMsgItem setPrimaryID:index];
                if(sysMsgItem){
                    [messageList addObject:sysMsgItem];
                }
            }
                break;
            default:
                break;
        }
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if([messageList count] > 0){
        [self showMsgPush:messageList];
        [notificationCenter postNotificationName:D_Notification_Name_SystemMessageDetected object:messageList];
    }
    
    if([rewardPacketList count] > 0){
        [self showRewardPush:rewardPacketList];
        [notificationCenter postNotificationName:D_Notification_Name_RewardPacketDetected object:rewardPacketList];
    }
}

- (void)incommingPush:(NSNotification*)notification{
    NSString *json = notification.object;
//    NSArray *dicArray = [json JSONValue];
//    if(dicArray){
//        [self parseIncomePush:dicArray];
//    }else{
//        KFLog_Normal(YES, @"recieve a empty push");
//    }
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
