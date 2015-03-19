//
//  ShopInfo.m
//  Woxin2.0
//
//  Created by Elty on 12/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ShopInfo.h"
#import "it_lib.h"
#import "ServiceCommon.h"
//#import "NSObject+SBJson.h"
#import "TxtparseOBJ.h"

enum{
	E_ShopTime_Begin = 0,
	E_ShopTime_End,
	
	E_ShopTime_Invalid,
};

@interface ShopInfo()
{
	NSMutableArray *_shopTimeList;
	NSMutableArray *_descArray;
}
@end

@implementation ShopInfo
@synthesize shopTimeList = _shopTimeList;
@synthesize descArray = _descArray;

- (void)dealloc{
	[self removeOBS];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_shopTimeList = [[NSMutableArray alloc] init];
		_descArray = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

- (void)toInit{
	[super toInit];
	[_shopTimeList removeAllObjects];
	[_descArray removeAllObjects];
}

+ (ShopInfo*)sharedShopInfo{
	static dispatch_once_t onceToken;
	static ShopInfo *shopInfo = nil;
	dispatch_once(&onceToken, ^{
		shopInfo = [[ShopInfo alloc] init];
	});
	return shopInfo;
}

- (E_LoadDataReturnValue)loadShopInfo{
	E_LoadDataReturnValue ret = [self checkReturnValueInAdvance];
	if (E_LoadDataReturnValue_UnDetermined == ret){
		WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
		NSInteger aRet = IT_MallGetShopAboutInfoIND((SS_UINT32)userOBJ.subShopID);
		if(aRet != 0){
			KFLog_Normal(YES, @"调用获取店铺信息接口失败 = %d",(int)aRet);
			[self setStatus:E_ModelDataStatus_LoadFailed];
			ret = E_LoadDataReturnValue_Failed;
		}else{
			KFLog_Normal(YES, @"调用获取店铺信息接口成功");
			[self setStatus:E_ModelDataStatus_Loading];
			ret = E_LoadDataReturnValue_ISLoading;
		}
	}
	return ret;
}

- (BOOL)isValid{
	return YES;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(loadShopInfoSucceed:) name:D_Notification_Name_Lib_LoadOfficeInfoSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(loadShopInfoFailed:) name:D_Notification_Name_Lib_LoadOfficeInfoFailed object:nil];
}

//- (void)loadShopInfoSucceed:(NSNotification*)notification{
//	NSString *json = notification.object;
//	NSDictionary *jsonDic = [json JSONValue];
//	[_shopTimeList removeAllObjects];
//	[_descArray removeAllObjects];
//	NSArray *dicArray = [jsonDic objectForKey:@"data"];
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	for (NSDictionary *dic in dicArray){
//		ShopDesc *desc = [ShopDesc shopDescribtionWithDictionary:dic];
//		if (desc){
//			[_descArray addObject:desc];
//		}
//		[self setAddress:[jsonDic objectForKey:@"address"]];
//		[self setScheduleDay:[[jsonDic objectForKey:@"destine_day"] integerValue]];
//		[self setShopTel:[jsonDic objectForKey:@"shop_tel"]];
//		[self setPhone:[jsonDic objectForKey:@"tel"]];
//		[self setName:[jsonDic objectForKey:@"name"]];
//		[self setBusiness:[jsonDic objectForKey:@"industry"]];
//		NSString *shopTimeString = [jsonDic objectForKey:@"open_time"];
//		NSArray *openTimeArray = [self openTimeArrayFrom:shopTimeString];
//		[_shopTimeList addObjectsFromArray:openTimeArray];
//	}
//	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoadShopInfoSucceed object:nil];
//}

- (NSArray*)openTimeArrayFrom:(NSString*)timeString{
	if (!timeString){
		return nil;
	}
	
	NSArray *timeArray = [TxtparseOBJ parseDataFrom:timeString itemSeparator:@"#" elementSeparator:@","];
	NSMutableArray *subTimeArray = [NSMutableArray array];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	for (NSArray *comps in timeArray) {
		if([comps count] != E_ShopTime_Invalid){
			NSLog(@"解析错误 = %@",comps);
			continue;
		}
		SubShopTime *time = [[SubShopTime alloc] init] ;
		[time setShopTimeBegin:[comps[E_ShopTime_Begin] integerValue]*60];
		[time setShopTimeEnd:[comps[E_ShopTime_End] integerValue]*60];
		[subTimeArray addObject:time];
	}
//	[pool drain];
	return subTimeArray;
}

- (void)loadShopInfoFailed:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoadShopInfoFailed object:nil];
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadShopInfo];
	}
}

@end
