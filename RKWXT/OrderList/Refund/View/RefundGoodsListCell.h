//
//  RefundGoodsListCell.h
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define RefundGoodsListCellHeight (92)

@protocol SelectGoodsDelegate;

@interface RefundGoodsListCell : WXUITableViewCell
@property (nonatomic,assign) id<SelectGoodsDelegate>delegate;
@end

@protocol SelectGoodsDelegate <NSObject>
-(void)selectGoods;
-(void)searchRefundStatus:(id)sender;

@end
