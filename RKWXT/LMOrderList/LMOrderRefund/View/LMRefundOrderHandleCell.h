//
//  LMRefundOrderHandleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMRefundOrderHandleCellHeight (47)

@protocol LMRefundAllBtnDelegate;

@interface LMRefundOrderHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMRefundAllBtnDelegate>delegate;
@end

@protocol LMRefundAllBtnDelegate <NSObject>
-(void)selectAllGoods;
-(void)lmRefundGoodsBtnClicked:(id)sender;

@end
