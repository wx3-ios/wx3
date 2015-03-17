//
//  WXGoodListModel.h
//  Woxin2.0
//
//  Created by le ting on 8/6/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXGoodEntity.h"
#import "SetMealEntity.h"

@interface WXGoodListModel : NSObject
@property (nonatomic,readonly)NSArray *goodList; //商品列表
@property (nonatomic,readonly)NSArray *setMealList;//套餐列表
@property (nonatomic,assign)NSInteger guessYouLikeShow;

+ (WXGoodListModel*)sharedGoodListModel;
- (void)loadALL;//加载所有商品和套餐
- (void)removeALL;//清楚所有商品和套餐
- (NSArray*)currentGuessYouLike;//本次猜你喜欢~
- (NSArray*)nextGuessYouLike;//下一个猜你喜欢
- (BOOL)loadedSucceed;

- (NSArray*)goodsOfCategory:(NSInteger)category;//分类商品
- (WXGoodEntity*)goodsOfID:(NSInteger)goodID;//通过goodID查找商品
- (SetMealEntity*)packetGoodOfID:(NSInteger)goodID;//通过packetID找套餐
- (NSArray*)goodsFromArray:(NSInteger[])goodIDArray length:(NSInteger)length;//通过goodID获取商品~
@end