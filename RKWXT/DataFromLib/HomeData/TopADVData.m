//
//  TopADVData.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "TopADVData.h"
#import "ServiceCommon.h"
//#import "NSObject+SBJson.h"
#import "TopADVEntity.h"

@interface TopADVData()
{
	NSMutableArray *_topADVList;
}
@end

@implementation TopADVData

- (void)dealloc{
	[self removeOBS];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_topADVList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

- (void)toInit{
	[self setStatus:E_ModelDataStatus_Init];
	[_topADVList removeAllObjects];
}

- (E_LoadDataReturnValue)loadTopADVData{
	return 0;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(topADVDataLoadFailed)
							   name:D_Notification_Name_Lib_LoadHomeTopGoodsFailed object:nil];
}

//- (void)topADVDataLoadSucceed:(NSNotification*)notification{
//	KFLog_Normal(YES, @"顶部广告列表加载成功");
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	[_topADVList removeAllObjects];
//	
//	NSString *jsonString = notification.object;
//	NSDictionary *jsonDic = [jsonString JSONValue];
//	NSArray *dicArray = [jsonDic objectForKey:@"data"];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	for (NSDictionary *dic in dicArray){
//		TopADVEntity *entity = [TopADVEntity topADVEntityWithDictionary:dic];
//		if (entity){
//			[_topADVList addObject:entity];
//		}
//	}
//	[pool drain];
//	[_topADVList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//		TopADVEntity *item1 = obj1;
//		TopADVEntity *item2 = obj2;
//		if (item1.sortID < item2.sortID){
//			return NSOrderedAscending;
//		}else if (item1.sortID == item2.sortID){
//			return NSOrderedSame;
//		}else{
//			return NSOrderedDescending;
//		}
//	}];
//	
//	if (_delegate && [_delegate respondsToSelector:@selector(topADVDataLoadSucceed)]){
//		[_delegate topADVDataLoadSucceed];
//	}
//}

- (void)topADVDataLoadFailed{
	KFLog_Normal(YES, @"顶部广告列表加载失败");
	[self setStatus:E_ModelDataStatus_LoadFailed];
	if (_delegate && [_delegate respondsToSelector:@selector(topADVDataLoadFailed)]){
		[_delegate topADVDataLoadFailed];
	}
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadTopADVData];
	}
}

@end
