//
//  LMShoppingCartGoodsListCell.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMShoppingCartGoodsListCellHeight (100)

@protocol LMShoppingCartGoodsListCellDelegate;
@interface LMShoppingCartGoodsListCell : WXUITableViewCell
@property (nonatomic,assign) id<LMShoppingCartGoodsListCellDelegate>delegate;
@end

@protocol LMShoppingCartGoodsListCellDelegate <NSObject>
-(void)goodsCircleSellect:(id)sender;
-(void)goodsPlusBtnClicked:(id)sender;
-(void)goodsMinusBtnClicked:(id)sender;
-(void)goodsDelBtnClicked:(id)sender;

@end
