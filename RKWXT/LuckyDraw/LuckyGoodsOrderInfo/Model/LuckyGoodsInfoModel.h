//
//  LuckyGoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/8/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LuckyGoodsInfoModelDelegate;

@interface LuckyGoodsInfoModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckyGoodsInfoModelDelegate>delegate;

-(void)completeLuckyOrderWith:(NSInteger)orderID;
@end

@protocol LuckyGoodsInfoModelDelegate <NSObject>
-(void)completeLuckyOrderSucceed;
-(void)completeLuckyOrderFailed:(NSString*)errorMsg;

@end
