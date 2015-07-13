//
//  OrderGoodsCell.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define OrderGoodsCellHeight    (95)

@protocol OrderGoodsDelegate;

@interface OrderGoodsCell : WXTUITableViewCell
@property (nonatomic,assign) id<OrderGoodsDelegate>delegate;
@end

@protocol OrderGoodsDelegate <NSObject>
-(void)toGoodsInfoWithGoodsID:(NSInteger)goodsID;
-(void)toOrderRefundSucceed:(id)sender;

@end
