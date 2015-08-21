//
//  LuckyGoodsMakeOrderModel.h
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LuckyGoodsMakeOrderModelDelegate;

@interface LuckyGoodsMakeOrderModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckyGoodsMakeOrderModelDelegate>delegate;
@property (nonatomic,strong) NSString *orderID;

-(void)luckyGoodsMakeOrderWith:(NSInteger)lottery_id withGoodsID:(NSInteger)goods_id withName:(NSString*)goods_name withImgUrl:(NSString*)imgUrl withGoodsStockID:(NSInteger)stockID withStockName:(NSString*)stockName WithMoney:(CGFloat)money withMarket:(CGFloat)marketPrice;
@end

@protocol LuckyGoodsMakeOrderModelDelegate <NSObject>
-(void)luckyGoodsMakeOrderSucceed;
-(void)luckyGoodsMakeOrderFailed:(NSString*)errorMsg;

@end
