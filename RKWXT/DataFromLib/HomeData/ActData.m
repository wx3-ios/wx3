//
//  ActData.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ActData.h"
#import "ServiceCommon.h"
//#import "NSObject+SBJson.h"
//#import "HomeNavEntity.h"

@interface ActData()
{
	NSMutableArray *_actDataList;
}
@end

@implementation ActData
@synthesize actDataList = _actDataList;

- (void)dealloc{
	_delegate = nil;
	[self removeOBS];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_actDataList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

- (void)toInit{
	[self setStatus:E_ModelDataStatus_Init];
	[_actDataList removeAllObjects];
}

- (E_LoadDataReturnValue)loadActiveData{
	return 0;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(activityGoodsLoadFailed)
							   name:D_Notification_Name_Lib_LoadActivityGoodsFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(activityGoodsLoadSucceed:)
							   name:D_Notification_Name_Lib_LoadActivityGoodsSucceed object:nil];
}

- (void)activityGoodsLoadFailed{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	KFLog_Normal(YES, @"加载活动商品失败");
	
	if(_delegate && [_delegate respondsToSelector:@selector(loadActiveDataListFailed)]){
		[_delegate loadActiveDataListFailed];
	}
}

//- (void)activityGoodsLoadSucceed:(NSNotification*)notification{
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	KFLog_Normal(YES, @"加载活动商品成功");
//	[_actDataList removeAllObjects];
//	
//	NSString *jsonString = notification.object;
//	if(jsonString){
//		NSArray *activityGoods = [[jsonString JSONValue] objectForKey:@"data"];
//		for(NSDictionary *dic in activityGoods){
//			HomeNavEntity *navEntity = [HomeNavEntity homeNavEntityWith:dic];
//			[_actDataList addObject:navEntity];
//		}
//	}
//	if(_delegate && [_delegate respondsToSelector:@selector(loadActiveDataListSucceed)]){
//		[_delegate loadActiveDataListSucceed];
//	}
//}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadActiveData];
	}
}

@end
