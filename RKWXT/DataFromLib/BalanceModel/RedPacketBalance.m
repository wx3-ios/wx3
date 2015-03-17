//
//  RedPacketBalance.m
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "RedPacketBalance.h"
#import "ServiceCommon.h"
#import "it_lib.h"

@implementation RedPacketBalance

- (void)dealloc{
	[self removeOBS];
	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		[self addOBS];
	}
	return self;
}

+ (RedPacketBalance*)sharedRedPacketBalance{
	static dispatch_once_t onceToken;
	static RedPacketBalance *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[RedPacketBalance alloc] init];
	});
	return sharedInstance;
}

- (void)toInit{
	[super toInit];
	_balance = 0.0;
}

- (E_LoadDataReturnValue)reloadRedPacketBalance{
	[self toInit];
	return [self loadRedPacketBalance];
}

- (E_LoadDataReturnValue)loadRedPacketBalance{
	E_LoadDataReturnValue ret = [self checkReturnValueInAdvance];
	if (ret == E_LoadDataReturnValue_UnDetermined){
		SS_UINT32 aRet = IT_MallGetRedPackageBalanceIND();
		if(aRet == 0){
			[self setStatus:E_ModelDataStatus_Loading];
			KFLog_Normal(YES, @"获取红包余额接口调用成功");
			ret = E_LoadDataReturnValue_Succeed;
		}else{
			[self setStatus:E_ModelDataStatus_LoadFailed];
			KFLog_Normal(YES, @"获取红包余额接口调用失败 ret = %d",aRet);
			ret = E_LoadDataReturnValue_Failed;
		}
	}
	return ret;
}

- (NSInteger)useRedPacket:(CGFloat)money  orderID:(NSString*)orderID{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    NSInteger intMoney = money;
    SS_UINT32 aRet = IT_MallUseRedPackageIND((SS_UINT32)userObj.subShopID, [[NSString stringWithFormat:@"%d",(int)intMoney] UTF8String], [orderID UTF8String]);
    if(aRet != 0){
        KFLog_Normal(YES, @"使用红包接口调用失败 ret = %d",aRet);
    }else{
        KFLog_Normal(YES, @"使用红包接口调用成功")
    }
    return aRet;
}

- (void)setBalance:(CGFloat)balance{
	_balance = balance;
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketBalanceChanged object:nil];
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(loadedSucceed:) name:D_Notification_Name_Lib_LoadRpBalanceSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(loadFailed:) name:D_Notification_Name_Lib_LoadRpBalanceFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(useRedPacketSucceed:) name:D_Notification_Name_Lib_UseRedPagerSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(useRedPacketFailed:) name:D_Notification_Name_Lib_UseRedPagerFailed object:nil];
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadRedPacketBalance];
	}
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadedSucceed:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_LoadSucceed];
	NSString *moneyStr = notification.object;
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketBalanceLoadedSucceed object:nil];
	[self setBalance:[moneyStr floatValue]];
}

- (void)loadFailed:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketBalanceLoadedFailed object:nil];
}


- (void)useRedPacketSucceed:(NSNotification*)notification{
	NSDictionary *dic = notification.object;
	CGFloat curBalance = [[dic objectForKey:@"balance"] floatValue];
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketBalanceUsedSucceed object:nil];
	[self setBalance:curBalance];
}

- (void)useRedPacketFailed:(NSNotification*)notification{
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketBalanceUsedFailed object:nil];
}

@end
