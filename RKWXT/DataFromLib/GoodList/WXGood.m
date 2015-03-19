//
//  WXGood.m
//  Woxin2.0
//
//  Created by Elty on 11/27/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXGood.h"
#import "it_lib.h"
#import "ServiceCommon.h"
//#import "NSObject+SBJson.h"
#import "WXGoodEntity.h"

@interface WXGood()
{
	NSMutableArray *_goodList;
}
@end

@implementation WXGood
@synthesize goodList = _goodList;

- (void)dealloc{
	_delegate = nil;
	[self removeOBS];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_goodList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

- (void)toInit{
	[self setStatus:E_ModelDataStatus_Init];
	[_goodList removeAllObjects];
}

- (E_LoadDataReturnValue)loadGoodList{
	E_LoadDataReturnValue ret = [self checkReturnValueInAdvance];
	if (E_LoadDataReturnValue_UnDetermined == ret){
		WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
		NSInteger areaID = (SS_UINT32)userOBJ.areaID;
		NSInteger subShopID = (SS_UINT32)userOBJ.subShopID;
		if (areaID <= 0 || subShopID <= 0){
			KFLog_Normal(YES, @"无效的分店ID或者商店ID");
			[self setStatus:E_ModelDataStatus_LoadFailed];
			ret = E_LoadDataReturnValue_Failed;
		}else{
			NSInteger aRet = IT_MallGetGoodsAllIND((SS_UINT32)userOBJ.areaID, (SS_UINT32)userOBJ.subShopID);
			if(aRet != 0){
				KFLog_Normal(YES, @"调用获取所有商品的借口失败 = %d",(int)aRet);
				[self setStatus:E_ModelDataStatus_LoadFailed];
				ret = E_LoadDataReturnValue_Failed;
			}else{
				KFLog_Normal(YES, @"调用获取所有商品的借口成功");
				KFLog_Normal(YES, @"区域ID=%d,分店ID=%d",(int)areaID,(int)subShopID);
				[self setStatus:E_ModelDataStatus_Loading];
				ret = E_LoadDataReturnValue_ISLoading;
			}
		}
	}
	return ret;
}

- (void)addOBS{
	NSNotificationCenter *defaultNotificationCenter = [NSNotificationCenter defaultCenter];
	[defaultNotificationCenter addObserver:self selector:@selector(allGoodsLoadedSucceed:) name:D_Notification_Name_Lib_AllGoodsHaveLoaded object:nil];
	[defaultNotificationCenter addObserver:self selector:@selector(allGoodsLoadedFailed) name:D_Notification_Name_Lib_AllGoodsLoadedFailed object:nil];
}

//- (void)allGoodsLoadedSucceed:(NSNotification*)notification{
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	KFLog_Normal(YES, @"获取所有商品列表成功");
//	[_goodList removeAllObjects];
//	NSDictionary *dic = notification.object;
//	NSString *jsonString = [dic objectForKey:@"jsonString"];
//	NSString *domain = [dic  objectForKey:@"domain"];
//	NSDictionary *goodsDic = [jsonString JSONValue];
//	NSArray *goodArray = [goodsDic objectForKey:@"data"];
//	for(NSDictionary *goodDic in goodArray){
//		WXGoodEntity *goodEntity = [WXGoodEntity goodWithDictionary:goodDic domain:domain];
//		if(goodEntity){
//			[_goodList addObject:goodEntity];
//		}
//	}
//	
//	if (_delegate && [_delegate respondsToSelector:@selector(allGoodsLoadedSucceed)]){
//		[_delegate allGoodsLoadedSucceed];
//	}
//}

- (void)allGoodsLoadedFailed{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	if (_delegate && [_delegate respondsToSelector:@selector(allGoodsLoadedFailed)]){
		[_delegate allGoodsLoadedFailed];
	}
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadGoodList];
	}
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
