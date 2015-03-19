//
//  WXGoodListModel.m
//  Woxin2.0
//
//  Created by le ting on 8/6/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXGoodListModel.h"
#import "ServiceCommon.h"
#import "WXGood.h"
#import "WXSetMeal.h"

#define kGuessLikeNumberOnce (4)
@interface WXGoodListModel()<WXGoodDelegate,WXSetMealDelegate>{
	WXGood *_goodModel;
	WXSetMeal *_setMealModel;
	
	//猜你喜欢~
	NSInteger _guesssTime;//猜的次数
}
@end

@implementation WXGoodListModel

- (void)dealloc{
//    [super dealloc];
}

- (id)init{
    if(self = [super init]){
		_guessYouLikeShow = kGuessLikeNumberOnce;
		_goodModel = [[WXGood alloc] init];
		[_goodModel setDelegate:self];
		_setMealModel = [[WXSetMeal alloc] init];
		[_setMealModel setDelegate:self];
    }
    return self;
}

+ (WXGoodListModel*)sharedGoodListModel{
    static dispatch_once_t onceToken;
    static WXGoodListModel *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXGoodListModel alloc] init];
    });
    return sharedInstance;
}

- (BOOL)loadedSucceed{
	return _goodModel.status == E_ModelDataStatus_LoadSucceed &&  _setMealModel.status == E_ModelDataStatus_LoadSucceed;
}

- (NSArray*)goodList{
	return _goodModel.goodList;
}

- (NSArray*)setMealList{
	return _setMealModel.setMealList;
}

- (void)clearGoodList{
	[_goodModel toInit];
	[_setMealModel toInit];
	_guesssTime = 0;
	_guessYouLikeShow = kGuessLikeNumberOnce;
}

- (void)loadALL{
	[_goodModel loadGoodList];
	[_setMealModel loadAllSetMeals];
}

- (void)removeALL{
    [self clearGoodList];
}

- (NSArray*)guessYourLikeArray{
    NSMutableArray *guessYouLikeArray = [NSMutableArray array];
    for(WXGoodEntity *entity in self.goodList){
        if(entity.isInGuess){
            [guessYouLikeArray addObject:entity];
        }
    }
    return guessYouLikeArray;
}

- (NSInteger)nextNumber{
    return _guessYouLikeShow;
}

- (NSArray*)guessYouLikeAtTime:(NSInteger)time{
	NSInteger nextNumber = [self nextNumber];
	NSArray *guessYouLikeArray = [self guessYourLikeArray];
	NSInteger count = [guessYouLikeArray count];
	if(count <= nextNumber){
		return guessYouLikeArray;
	}
	NSMutableArray *guessArray = [NSMutableArray array];
	NSInteger maxIndex = nextNumber *(time + 1);
	for(NSInteger index = nextNumber*time; index < maxIndex; index++){
		NSInteger aIndex = index%count;
		[guessArray addObject:[guessYouLikeArray objectAtIndex:aIndex]];
	}
	return guessArray;
}

- (NSArray*)currentGuessYouLike{
	return [self guessYouLikeAtTime:_guesssTime];
}

- (NSArray*)nextGuessYouLike{
	_guesssTime++;
	return [self guessYouLikeAtTime:_guesssTime];
}

- (NSArray*)goodsOfCategory:(NSInteger)category{
    NSMutableArray *goodArray = [NSMutableArray array];
    for(WXGoodEntity *goodEntity in self.goodList){
        if(goodEntity.category == category){
            [goodArray addObject:goodEntity];
        }
    }
    return goodArray;
}

- (WXGoodEntity*)goodsOfID:(NSInteger)goodID{
    if(goodID <= 0){
        return nil;
    }
    for(WXGoodEntity *good in self.goodList){
        if(good.goodID == goodID){
            return good;
        }
    }
    return nil;
}

- (SetMealEntity*)packetGoodOfID:(NSInteger)goodID{
    if(goodID <= 0){
        return nil;
    }
    for(SetMealEntity *packetGood in self.setMealList){
        if(packetGood.UID == goodID){
            return packetGood;
        }
    }
    return nil;
}

- (NSArray*)goodsFromArray:(NSInteger[])goodIDArray length:(NSInteger)length{
    NSMutableArray *goods = [[NSMutableArray alloc] init] ;
    for (NSInteger index = 0; index < length; index++){
        WXGoodEntity *good = [self goodsOfID:goodIDArray[index]];
        if(good){
           [goods addObject:good];
        }
    }
    return goods;
}


#pragma mark  delegate
- (void)allGoodsLoadedSucceed{
	KFLog_Normal(YES, @"所有单品加载成功");
	if (_setMealModel.status == E_ModelDataStatus_LoadSucceed){
		KFLog_Normal(YES, @"所有单品和套餐均已加载成功");
		[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_AllGoodsLoadedFinished object:nil];
	}else{
		KFLog_Normal(YES, @"套餐没有加载成功")
	}
}

- (void)allGoodsLoadedFailed{
	KFLog_Normal(YES, @"所有单品加载失败");
}

- (void)allSetMealLoadedSucceed{
	KFLog_Normal(YES, @"所有套餐加载成功");
	if (_goodModel.status == E_ModelDataStatus_LoadSucceed){
		KFLog_Normal(YES, @"所有单品和套餐均已加载成功");
		[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_AllGoodsLoadedFinished object:nil];
	}else{
		KFLog_Normal(YES, @"所有单品没有加载成功");
	}
}

- (void)allSetMealLoadedFailed{
	KFLog_Normal(YES, @"所有套餐加载失败");
}

@end
