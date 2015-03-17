//
//  GuessYouLikeData.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "GuessYouLikeData.h"
#import "it_lib.h"
#import "ServiceCommon.h"
#import "NSObject+SBJson.h"
#import "WXGoodListModel.h"

#define kGuessLikeNumberOnce (4)

@interface GuessYouLikeData()
{
	NSMutableArray *_guessGoods;
}
@property (nonatomic,retain)NSArray *guessGoodDics;
@end

@implementation GuessYouLikeData
@synthesize guessGoods = _guessGoods;

- (void)dealloc{
	[self removeOBS];
	RELEASE_SAFELY(_guessGoods);
	RELEASE_SAFELY(_guessGoodDics);
	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_guessGoods = [[NSMutableArray alloc] init];
		[self addOBS];
	}
	return self;
}

- (void)toInit{
	[self setStatus:E_ModelDataStatus_Init];
	[_guessGoods removeAllObjects];
	[[WXGoodListModel sharedGoodListModel] setGuessYouLikeShow:kGuessLikeNumberOnce];
}

- (E_LoadDataReturnValue)loadGuessYouLikeData{
	E_LoadDataReturnValue ret = [self checkReturnValueInAdvance];
	if (ret == E_LoadDataReturnValue_UnDetermined){
		WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
        NSInteger areaID = (SS_UINT32)userOBJ.areaID;
        NSInteger subShopID = (SS_UINT32)userOBJ.subShopID;
        if (areaID <= 0 || subShopID <= 0){
            KFLog_Normal(YES, @"无效的店铺ID或者无效的分店ID");
            [self setStatus:E_ModelDataStatus_LoadFailed];
            ret = E_LoadDataReturnValue_Failed;
        }else{
            SS_UINT32 aRet = IT_MallGetGuessYouLikeRandomGoodsIND((SS_UINT32)userOBJ.areaID, (SS_UINT32)userOBJ.subShopID);
            if(ret != 0){
                KFLog_Normal(YES, @"猜你喜欢商品失败 ret = %d",aRet);
                [self setStatus:E_ModelDataStatus_LoadFailed];
                ret = E_LoadDataReturnValue_Failed;
            }else{
                KFLog_Normal(YES, @"猜你喜欢商品成功");
				KFLog_Normal(YES, @"区域ID=%d,分店ID=%d",(int)areaID,(int)subShopID);
                [self setStatus:E_ModelDataStatus_Loading];
                ret = E_LoadDataReturnValue_Succeed;
            }
        }
		
	}
	return ret;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(guessYourLikeGoodsLoadFailed) name:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(guessYouLikeGoodsLoadSucceed:) name:D_Notification_Name_Lib_LoadGuessYouLikeGoodsSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(allGoodsLoadedSucceed:) name:D_Notification_Name_AllGoodsLoadedFinished object:nil];
}

- (void)guessYouLikeGoodsLoadSucceed:(NSNotification*)notification{
	[_guessGoods removeAllObjects];
	[self setStatus:E_ModelDataStatus_LoadSucceed];
	
	NSString *jsonString = notification.object;
	if(jsonString){
		NSDictionary *dic = [jsonString JSONValue];
		if (dic){
			NSArray *topGoods = [[jsonString JSONValue] objectForKey:@"data"];
			[self setGuessGoodDics:topGoods];
			NSInteger numberShow = [[dic objectForKey:@"num"] integerValue];
			if (numberShow < kGuessLikeNumberOnce){
				numberShow = kGuessLikeNumberOnce;
			}
			[[WXGoodListModel sharedGoodListModel] setGuessYouLikeShow:numberShow];
			[self pickGuessYouLikeGoods];
		}
	}
}

- (void)pickGuessYouLikeGoods{
	if ([WXGoodListModel sharedGoodListModel].loadedSucceed && self.status == E_ModelDataStatus_LoadSucceed){
		NSInteger count = [self.guessGoodDics count];
		if(count > 0){
			NSInteger goodIDs[count];
			for(int index = 0; index < count; index++){
				NSDictionary *dic = [self.guessGoodDics objectAtIndex:index];
				NSInteger goodID = [[dic objectForKey:@"goods_id"] integerValue];
				goodIDs[index] = goodID;
			}
			NSArray *goods = [[WXGoodListModel sharedGoodListModel] goodsFromArray:goodIDs length:count];
			[_guessGoods addObjectsFromArray:goods];
		}
		
		if(_delegate && [_delegate respondsToSelector:@selector(guessYouLikeDataedSucceed)]){
			[_delegate guessYouLikeDataedSucceed];
		}
	}
}

- (void)allGoodsLoadedSucceed:(NSNotification*)notification{
	[self pickGuessYouLikeGoods];
}

- (void)guessYourLikeGoodsLoadFailed{
	[self setStatus:E_ModelDataStatus_LoadFailed];
	
	if(_delegate && [_delegate respondsToSelector:@selector(guessYouLikeDataLoadedFailed)]){
		[_delegate guessYouLikeDataLoadedFailed];
	}
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)serviceConnectedOK{
	if ([self checkReturnValueInAdvance] == E_LoadDataReturnValue_UnDetermined){
		[self loadGuessYouLikeData];
	}
}

@end
