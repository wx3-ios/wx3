//
//  LuckyGoodsModel.h
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LuckyGoodsModelDelegate;

@interface LuckyGoodsModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckyGoodsModelDelegate>delegate;
@property (nonatomic,strong) NSArray *luckyGoodsArr;

-(void)loadLuckyGoodsList;
@end

@protocol LuckyGoodsModelDelegate <NSObject>
-(void)loadLuckyGoodsSuceeed;
-(void)loadLuckyGoodsFailed:(NSString *)errorMsg;

@end
