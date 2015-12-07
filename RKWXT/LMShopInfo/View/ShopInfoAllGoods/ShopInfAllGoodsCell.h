//
//  ShopInfAllGoodsCell.h
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol ShopInfAllGoodsCellDelegate;
@interface ShopInfAllGoodsCell : WXMiltiViewCell
@property (nonatomic,assign) id<ShopInfAllGoodsCellDelegate>delegate;
@end

@protocol ShopInfAllGoodsCellDelegate <NSObject>
-(void)shopInfoAllGoodsCellBtnClicked:(id)sender;

@end
