//
//  WXSetMeal.m
//  Woxin2.0
//
//  Created by Elty on 11/27/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXSetMeal.h"
#import "it_lib.h"
#import "ServiceCommon.h"
#import "NSObject+SBJson.h"
#import "SetMealEntity.h"

@interface WXSetMeal()
{
	NSMutableArray *_setMealList;
}
@end

@implementation WXSetMeal
@synthesize setMealList = _setMealList;

- (void)dealloc{
	_delegate = nil;
	RELEASE_SAFELY(_setMealList);
	[self removeOBS];
	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_setMealList = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

- (void)toInit{
	[self setStatus:E_ModelDataStatus_Init];
	[_setMealList removeAllObjects];
}


- (E_LoadDataReturnValue)loadAllSetMeals{
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
			NSInteger aRet = IT_MallGetPackageIND((SS_UINT32)userOBJ.areaID, (SS_UINT32)userOBJ.subShopID);
			if(aRet != 0){
				KFLog_Normal(YES, @"获取套餐失败 ret = %d",(int)ret);
				[self setStatus:E_ModelDataStatus_LoadFailed];
				ret = E_LoadDataReturnValue_Failed;
			}else{
				KFLog_Normal(YES, @"获取套餐成功");
				KFLog_Normal(YES, @"区域ID=%d,分店ID=%d",(int)areaID,(int)subShopID);
				[self setStatus:E_ModelDataStatus_Loading];
				ret = E_LoadDataReturnValue_ISLoading;
			}
		}
	}
	return ret;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(allSetMealLoadedSucceed:) name:D_Notification_Name_Lib_LoadSetMealsSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(allSetMealLoadedFailed:) name:D_Notification_Name_Lib_LoadSetMealsFailed object:nil];
}

- (void)allSetMealLoadedSucceed:(NSNotification*)notification{
	[_setMealList removeAllObjects];
	NSString *jsonString = notification.object;
	NSDictionary *setMealsDic = [jsonString JSONValue];
	NSArray *setMealArray = [setMealsDic objectForKey:@"package"];
	for(NSDictionary *dic in setMealArray){
		SetMealEntity *setMealEntity = [SetMealEntity entityWithDictionary:dic];
		if(setMealEntity){
			[_setMealList addObject:setMealEntity];
		}
	}
	[self setStatus:E_ModelDataStatus_LoadSucceed];
	if (_delegate && [_delegate respondsToSelector:@selector(allSetMealLoadedSucceed)]){
		[_delegate allSetMealLoadedSucceed];
	}
}

- (void)allSetMealLoadedFailed:(NSNotification*)notification{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	
	if (_delegate && [_delegate respondsToSelector:@selector(allSetMealLoadedFailed)]){
		[_delegate allSetMealLoadedFailed];
	}
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadAllSetMeals];
	}
}

@end