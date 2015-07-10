//
//  WXGood.m
//  Woxin2.0
//
//  Created by Elty on 11/27/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXGood.h"
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
	return 0;
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
