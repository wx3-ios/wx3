//
//  TopADVData.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "TopADVData.h"
#import "it_lib.h"
#import "ServiceCommon.h"
#import "NSObject+SBJson.h"
#import "TopADVEntity.h"

@interface TopADVData()
{
	NSMutableArray *_topADVList;
}
@end

@implementation TopADVData

- (void)dealloc{
	RELEASE_SAFELY(_topADVList);
	[self removeOBS];
	[super dealloc];
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
	E_LoadDataReturnValue ret = [self checkReturnValueInAdvance];
	if (ret == E_LoadDataReturnValue_UnDetermined){
		WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
        NSInteger areaID = (SS_UINT32)userOBJ.areaID;
        NSInteger subShopID = (SS_UINT32)userOBJ.subShopID;
        if (areaID <= 0 || subShopID <= 0){
            KFLog_Normal(YES, @"无效的分店ID或无效的店铺ID");
            [self setStatus:E_ModelDataStatus_LoadFailed];
            ret = E_LoadDataReturnValue_Failed;
        }else{
            SS_UINT32 aRet = IT_MallGetHomeTopBigPictureExIND(areaID, subShopID);
            if(aRet != 0){
                KFLog_Normal(YES, @"加载顶部商品接口调用失败 ret = %d",aRet);
                [self setStatus:E_ModelDataStatus_LoadFailed];
                ret = E_LoadDataReturnValue_Failed;
            }else{
                KFLog_Normal(YES, @"加载顶部商品接口调用成功");
                [self setStatus:E_ModelDataStatus_Loading];
                ret = E_LoadDataReturnValue_Succeed;
            }
        }
		
	}
	return ret;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(topADVDataLoadFailed)
							   name:D_Notification_Name_Lib_LoadHomeTopGoodsFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(topADVDataLoadSucceed:)
							   name:D_Notification_Name_Lib_LoadHomeTopGoodsSucceed object:nil];
}

- (void)topADVDataLoadSucceed:(NSNotification*)notification{
	KFLog_Normal(YES, @"顶部广告列表加载成功");
	[self setStatus:E_ModelDataStatus_LoadSucceed];
	[_topADVList removeAllObjects];
	
	NSString *jsonString = notification.object;
	NSDictionary *jsonDic = [jsonString JSONValue];
	NSArray *dicArray = [jsonDic objectForKey:@"data"];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	for (NSDictionary *dic in dicArray){
		TopADVEntity *entity = [TopADVEntity topADVEntityWithDictionary:dic];
		if (entity){
			[_topADVList addObject:entity];
		}
	}
	[pool drain];
	[_topADVList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		TopADVEntity *item1 = obj1;
		TopADVEntity *item2 = obj2;
		if (item1.sortID < item2.sortID){
			return NSOrderedAscending;
		}else if (item1.sortID == item2.sortID){
			return NSOrderedSame;
		}else{
			return NSOrderedDescending;
		}
	}];
	
	if (_delegate && [_delegate respondsToSelector:@selector(topADVDataLoadSucceed)]){
		[_delegate topADVDataLoadSucceed];
	}
}

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
