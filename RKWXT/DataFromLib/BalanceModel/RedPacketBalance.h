//
//  RedPacketBalance.h
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#define D_Notification_RedPacketBalanceLoadedSucceed	@"D_Notification_RedPacketBalanceLoadedSucceed" //红包余额加载成功
#define D_Notification_RedPacketBalanceLoadedFailed		@"D_Notification_RedPacketBalanceLoadedFailed"	//红包余额加载失败
#define D_Notification_RedPacketBalanceUsedSucceed @"D_Notification_RedPacketBalanceUsedSucceed" //红包使用成功
#define D_Notification_RedPacketBalanceUsedFailed @"D_Notification_RedPacketBalanceUsedFailed" //红包使用失败

#define D_Notification_RedPacketBalanceChanged @"D_Notification_RedPacketBalanceChanged" //红包金额改变了~ 

#import "BaseModel.h"

@interface RedPacketBalance : BaseModel
@property (nonatomic,assign)CGFloat balance;

+ (RedPacketBalance*)sharedRedPacketBalance;
- (E_LoadDataReturnValue)loadRedPacketBalance; //加载红包
- (E_LoadDataReturnValue)reloadRedPacketBalance;//重新加载红包
- (NSInteger)useRedPacket:(CGFloat)money  orderID:(NSString*)orderID; //使用红包
@end
