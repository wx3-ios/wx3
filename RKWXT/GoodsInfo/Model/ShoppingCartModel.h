//
//  ShoppingCartModel.h
//  RKWXT
//
//  Created by SHB on 15/6/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol AddGoodsToShoppingCartDelegate;
@interface ShoppingCartModel : T_HPSubBaseModel
@property (nonatomic,assign) id<AddGoodsToShoppingCartDelegate>delegate;
-(void)loadGoodsInfoWithGoodsID:(NSInteger)goodsID withGoodsImg:(NSString*)goodsImg withGoodsNum:(NSInteger)number withGoodsName:(NSString*)name withGoodsPrice:(CGFloat)price;
@end

@protocol AddGoodsToShoppingCartDelegate <NSObject>
-(void)addGoodsToShoppingCartSucceed:(NSInteger)cartID;
-(void)addGoodsToShoppingCartFailed:(NSString*)errorMsg;

@end
