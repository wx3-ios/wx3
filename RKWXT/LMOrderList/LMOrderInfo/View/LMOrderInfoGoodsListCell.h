//
//  LMOrderInfoGoodsListCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMOrderInfoGoodsListCellHeight (110)

@protocol LMOrderInfoGoodsListCellDelegate;
@interface LMOrderInfoGoodsListCell : WXUITableViewCell
@property (nonatomic,assign) id<LMOrderInfoGoodsListCellDelegate>delgate;
@end

@protocol LMOrderInfoGoodsListCellDelegate <NSObject>
-(void)refundBtnClicked:(id)sender;

@end
