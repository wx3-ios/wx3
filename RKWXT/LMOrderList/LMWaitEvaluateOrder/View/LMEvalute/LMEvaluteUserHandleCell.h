//
//  LMEvaluteUserHandleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMEvaluteUserHandleCellHeight (40)

@protocol LMEvaluteUserHandleCellDelegate;

@interface LMEvaluteUserHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMEvaluteUserHandleCellDelegate>delegate;
@end

@protocol LMEvaluteUserHandleCellDelegate <NSObject>
-(void)userEvaluateGoods:(NSInteger)score goodsID:(NSInteger)goodsID;

@end
