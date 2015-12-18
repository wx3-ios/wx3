//
//  LMGoodsStockNameCell.h
//  RKWXT
//
//  Created by SHB on 15/12/18.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMGoodsStockNameCellHeight (40)

@protocol LMGoodsStockNameCellDelegate;

@interface LMGoodsStockNameCell : WXUITableViewCell
@property (nonatomic,assign) id<LMGoodsStockNameCellDelegate>delegate;
@end

@protocol LMGoodsStockNameCellDelegate <NSObject>
-(void)lmGoodsStockNameBtnClicked:(id)sender;

@end
