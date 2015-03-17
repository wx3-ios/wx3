//
//  RedPacket.h
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#define D_Notification_RedPacketLoadedSucceed @"D_Notification_RedPacketLoadedSucceed" //加载红包成功
#define D_Notification_RedPacketLoadedFailed @"D_Notification_RedPacketLoadedFailed"//加载红包失败
#define D_Notification_RedPacketOpenSucceed @"D_Notification_RedPacketReceivedSucceed"//打开红包成功
#define D_Notification_RedPacketOpenFailed @"D_Notification_RedPacketReceivedFailed"//打开红包失败

#define D_Notification_RedPacketNumberChanged @"D_Notification_RedPacketNumberChanged"//红包数目发生了改变~ 

#import "BaseModel.h"
#import "RedPacketEntity.h"

@interface RedPacket : BaseModel
@property (nonatomic,readonly)NSArray *redPacketList;

+ (RedPacket*)sharedRedPacket;
- (E_LoadDataReturnValue)loadRedPacket; //加载红包
- (E_LoadDataReturnValue)openRedPacket:(RedPacketEntity*)rpEntity; //打开红包
- (void)incommingRedPacket:(NSDictionary*)packetDic; //推送过来了红包
@end