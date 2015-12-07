//
//  LMShopInfoSalesCell.h
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol LMShopInfoSalesCellDelegate;
@interface LMShopInfoSalesCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMShopInfoSalesCellDelegate>delegate;
@end

@protocol LMShopInfoSalesCellDelegate <NSObject>
-(void)lmShopInfoSaleGoodsBtnClicked:(id)sender;

@end
