//
//  GuessYouLikeData.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "GuessYouLikeData.h"
#import "ServiceCommon.h"
//#import "NSObject+SBJson.h"
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
//	[super dealloc];
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
	return 0;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(guessYourLikeGoodsLoadFailed) name:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(guessYouLikeGoodsLoadSucceed:) name:D_Notification_Name_Lib_LoadGuessYouLikeGoodsSucceed object:nil];
	[notificationCenter addObserver:self selector:@selector(allGoodsLoadedSucceed:) name:D_Notification_Name_AllGoodsLoadedFinished object:nil];
}

//- (void)guessYouLikeGoodsLoadSucceed:(NSNotification*)notification{
//	[_guessGoods removeAllObjects];
//	[self setStatus:E_ModelDataStatus_LoadSucceed];
//	
//	NSString *jsonString = notification.object;
//	if(jsonString){
//		NSDictionary *dic = [jsonString JSONValue];
//		if (dic){
//			NSArray *topGoods = [[jsonString JSONValue] objectForKey:@"data"];
//			[self setGuessGoodDics:topGoods];
//			NSInteger numberShow = [[dic objectForKey:@"num"] integerValue];
//			if (numberShow < kGuessLikeNumberOnce){
//				numberShow = kGuessLikeNumberOnce;
//			}
//			[[WXGoodListModel sharedGoodListModel] setGuessYouLikeShow:numberShow];
//			[self pickGuessYouLikeGoods];
//		}
//	}
//}

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
