//
//  ShopInfoHotGoodsCell.h
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol ShopInfoHotGoodsCellDelegate;
@interface ShopInfoHotGoodsCell : WXMiltiViewCell
@property (nonatomic,assign) id<ShopInfoHotGoodsCellDelegate>delegate;
@end

@protocol ShopInfoHotGoodsCellDelegate <NSObject>
-(void)shopInfoHotGoodsCellBtnClicked:(id)sender;

@end