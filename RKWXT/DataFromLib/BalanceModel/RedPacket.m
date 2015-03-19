//
//  RedPacket.m
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "RedPacket.h"
#import "RedPacketBalance.h"
#import "ServiceCommon.h"
#import "it_lib.h"
//#import "NSObject+SBJson.h"
//#import "SysMsgDef.h"

@interface RedPacket()
{
	NSMutableArray *_redPacketList;
}
@end

@implementation RedPacket

- (void)dealloc{
	[self removeOBS];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_redPacketList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

+ (RedPacket*)sharedRedPacket{
	static dispatch_once_t onceToken;
	static RedPacket *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[RedPacket alloc] init];
	});
	return sharedInstance;
}

- (void)toInit{
	[super toInit];
	[_redPacketList removeAllObjects];
}

- (RedPacketEntity*)redPacketEntityWithRPID:(NSInteger)rpID{
	for (RedPacketEntity*entity in _redPacketList){
		if (entity.rpID == rpID){
			return entity;
		}
	}
	return nil;
}

- (E_LoadDataReturnValue)loadRedPacket{
	E_LoadDataReturnValue ret = [self checkReturnValueInAdvance];
	if (ret == E_LoadDataReturnValue_UnDetermined){
		WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
		NSInteger subShopID = (SS_UINT32)userOBJ.subShopID;
		if (subShopID <= 0){
			KFLog_Normal(YES, @"无效的分店ID");
			[self setStatus:E_ModelDataStatus_LoadFailed];
			ret = E_LoadDataReturnValue_Failed;
		}else{
			SS_UINT32 aRet = IT_MallLoadRedPackageIND((SS_UINT32)userOBJ.subShopID);
			if(aRet != 0){
				KFLog_Normal(YES, @"获取红包列表接口调用失败 ret = %d",aRet);
				[self setStatus:E_ModelDataStatus_LoadFailed];
				ret =  E_LoadDataReturnValue_Failed;
			}else{
				KFLog_Normal(YES, @"获取红包列表接口调用成功");
				KFLog_Normal(YES, @"分店ID=%d",(int)subShopID);
				[self setStatus:E_ModelDataStatus_Loading];
				ret =  E_LoadDataReturnValue_Succeed;;
			}
		}
	}
	return ret;
}

- (E_LoadDataReturnValue)openRedPacket:(RedPacketEntity*)rpEntity{
	E_LoadDataReturnValue ret = E_LoadDataReturnValue_Succeed;
	SS_UINT32 aRet = IT_MallReceiveRedPackageIND(rpEntity.shopID, rpEntity.rpID);
	if(aRet != 0){
		KFLog_Normal(YES, @"调用领取红包接口失败 ret = %d",aRet);
		ret = E_LoadDataReturnValue_Failed;
	}else{
		KFLog_Normal(YES, @"调用领取红包接口成功");
		ret = E_LoadDataReturnValue_Succeed;
	}
	return ret;
}

- (void)incommingRedPacket:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_Init];
	[self loadRedPacket];
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(loadedSucceed:) name:D_Notification_Name_Lib_LoadRedPagerSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(loadFailed:) name:D_Notification_Name_Lib_LoadRedPagerFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(openRedPacketSucceed:) name:D_Notification_Name_Lib_GainRedPagerSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(openRedPacketFailed:) name:D_Notification_Name_Lib_GainRedPagerFailed object:nil];
//	[notificationCenter addObserver:self selector:@selector(incommingRedPacket:) name:D_Notification_Name_RewardPacketDetected object:nil];
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray*)redPacketListWithDictionary:(NSDictionary*)dic{
	NSMutableArray *list = [NSMutableArray array];
	NSArray *packetList = [dic objectForKey:@"pack"];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	for (NSDictionary *aPacket in packetList){
		NSInteger type = [[aPacket objectForKey:@"type"] integerValue];
		NSInteger shopID = [[aPacket objectForKey:@"shop_id"] integerValue];
		NSString *name = [aPacket objectForKey:@"name"];
		NSArray *dataList = [aPacket objectForKey:@"data"];
		for (NSDictionary *aDic in dataList){
			NSInteger rpID = [[aDic objectForKey:@"id"] integerValue];
			CGFloat price = [[aDic objectForKey:@"price"] floatValue];
			NSString *title = [aDic objectForKey:@"title"];
			NSString *remark = [aDic objectForKey:@"remark"];
			NSInteger endDate = [[aDic objectForKey:@"end_date"] integerValue];
			RedPacketEntity *entity = [[RedPacketEntity alloc] init] ;
			[entity setMoney:price];
			[entity setTitle:title];
			[entity setRemark:remark];
			[entity setEndDate:endDate];
			[entity setType:type];
			[entity setShopID:shopID];
			[entity setShopName:name];
			[entity setRpID:rpID];
			[list addObject:entity];
		}
	}
//	[pool drain];
	return list;
}

//- (void)loadedSucceed:(NSNotification*)notification{
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	
//	[_redPacketList removeAllObjects];
//	NSString *jsonString = notification.object;
//	NSDictionary *dic = [jsonString JSONValue];
//	NSArray *list = [self redPacketListWithDictionary:dic];
//	if (list){
//		[_redPacketList addObjectsFromArray:list];
//	}
//	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketLoadedSucceed object:nil];
//	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketNumberChanged object:nil];
//}

- (void)loadFailed:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketLoadedFailed object:nil];
}

- (void)openRedPacketSucceed:(NSNotification*)notification{
	NSDictionary *dictionary = notification.object;
	if(dictionary){
		//改变红包余额
		CGFloat newBalance = [[dictionary objectForKey:@"balance"] floatValue];
		RedPacketBalance *rpBalance = [RedPacketBalance sharedRedPacketBalance];
		CGFloat grainPrice = newBalance - rpBalance.balance;
		KFLog_Normal(YES, @"获取红包：%.0f",grainPrice);
		[rpBalance setBalance:newBalance];
		NSInteger rpID = [[dictionary objectForKey:@"rpID"] integerValue];
		RedPacketEntity *aPacket = [self redPacketEntityWithRPID:rpID];
		if (aPacket){
			[_redPacketList removeObject:aPacket];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketOpenSucceed object:[NSNumber numberWithFloat:grainPrice]];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketNumberChanged object:nil];
}

- (void)openRedPacketFailed:(NSNotification*)notification{
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_RedPacketOpenFailed object:nil];
}

@end
