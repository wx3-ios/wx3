//
//  RefundConsultCell.h
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define RefundConsultCellHeight (47)

@protocol SelectAllGoodsDelegate;
@interface RefundConsultCell : WXUITableViewCell
@property (nonatomic,assign) id<SelectAllGoodsDelegate>delegate;
@end

@protocol SelectAllGoodsDelegate <NSObject>
-(void)selectAllGoods;
-(void)refundGoodsBtnClicked:(id)sender;

@end
