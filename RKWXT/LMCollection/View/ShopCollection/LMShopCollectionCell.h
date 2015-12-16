//
//  LMShopCollectionCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

#define LMGoodsCollectionCellheight (109)

@protocol LMShopCollectionCellDelegate;
@interface LMShopCollectionCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMShopCollectionCellDelegate>delegate;
@end

@protocol LMShopCollectionCellDelegate <NSObject>
-(void)lmShopCollectionCellBtnClicked:(id)sender;

@end
