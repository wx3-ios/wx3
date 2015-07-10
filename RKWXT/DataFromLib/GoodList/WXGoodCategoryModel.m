//
//  WXGoodCategoryModel.m
//  Woxin2.0
//
//  Created by Elty on 10/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXGoodCategoryModel.h"
//#import "GoodMenuEntity.h"
#import "ServiceCommon.h"
//#import "GoodMenuEntity.h"

@interface WXGoodCategoryModel (){
    NSMutableArray *_goodCategoryList;
}

@end

@implementation WXGoodCategoryModel
@synthesize goodCategoryList = _goodCategoryList;

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

- (id)init{
    if (self = [super init]){
        _goodCategoryList = [[NSMutableArray alloc] init];
        [self addOBS];
    }
    return self;
}

+ (WXGoodCategoryModel*)sharedGoodCategoryModel{
    static dispatch_once_t onceToken;
    static WXGoodCategoryModel *sharedModel = nil;
    dispatch_once(&onceToken, ^{
        sharedModel = [[WXGoodCategoryModel alloc] init];
    });
    return sharedModel;
}

- (void)removeALL{
	[self setStatus:E_ModelDataStatus_Init];
    [_goodCategoryList removeAllObjects];
}

- (BOOL)isDataReady{
	return self.status == E_ModelDataStatus_LoadSucceed;
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(categoryListLoadedFailed) name:D_Notification_Name_Lib_AllGoodsLoadedFailed object:nil];
}

//- (void)categoryListLoadedSucceed:(NSNotification*)notification{
//    [_goodCategoryList removeAllObjects];
//	KFLog_Normal(YES, @"获取商品分类列表成功");
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//    [_goodCategoryList removeAllObjects];
//    NSString *string = notification.object;
//    NSDictionary *jsonDic = [string JSONValue];
//    NSArray *categoryDicArray = [jsonDic objectForKey:@"data"];
//    
//    for(NSDictionary *categoryDic in categoryDicArray){
//        GoodMenuEntity *menuEntity = [GoodMenuEntity menuEntityWithDictionary:categoryDic];
//        if(menuEntity){
//			[self addCategaryEntity:menuEntity];
//			
//        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoadGoodCategorySucceed object:nil];
//}

//- (void)addCategaryEntity:(GoodMenuEntity*)menuEntity{
//	NSInteger index =-1;
//	NSUInteger sortIndex = menuEntity.sortIndex;
//	for (GoodMenuEntity *aMenuEntity in _goodCategoryList){
//		if(sortIndex < aMenuEntity.sortIndex){
//			index = [_goodCategoryList indexOfObject:aMenuEntity];
//			break;
//		}
//	}
//	if (index == -1){
//		index = [_goodCategoryList count];
//	}
//	[_goodCategoryList insertObject:menuEntity atIndex:index];
//}

- (void)categoryListLoadedFailed{
    KFLog_Normal(YES, @"获取商品分类列表失败");
	[self setStatus:E_ModelDataStatus_LoadFailed];
	
    [UtilTool showAlertView:@"获取分类列表失败"];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoadGoodCategoryFailed object:nil];
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (E_LoadDataReturnValue)loadGoodCategaryList{
	return 0;
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined) {
		[self loadGoodCategaryList];
	}
}

@end
