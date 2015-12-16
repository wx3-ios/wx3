//
//  LMGoodsCollectionCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

#define LMGoodsCollectionCellheight (222)

@protocol LMGoodsCollectionCellDelegate;
@interface LMGoodsCollectionCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMGoodsCollectionCellDelegate>delegate;
@end

@protocol LMGoodsCollectionCellDelegate <NSObject>
-(void)lmGoodsCollectionCellBtnClicked:(id)sender;

@end
