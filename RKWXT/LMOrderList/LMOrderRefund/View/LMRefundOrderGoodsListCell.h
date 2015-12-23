//
//  LMRefundOrderGoodsListCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
#import "LMOrderListEntity.h"

#define RefundGoodsListCellHeight (92)

@protocol LMRefundSelectGoodsDelegate;

@interface LMRefundOrderGoodsListCell : WXUITableViewCell
@property (nonatomic,assign) id<LMRefundSelectGoodsDelegate>delegate;
@property (nonatomic,strong) LMOrderListEntity *allEntity;
@end

@protocol LMRefundSelectGoodsDelegate <NSObject>
-(void)selectGoods;
-(void)searchRefundStatus:(id)sender;

@end
