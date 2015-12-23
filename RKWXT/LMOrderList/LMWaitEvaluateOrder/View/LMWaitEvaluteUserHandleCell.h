//
//  LMWaitEvaluteUserHandleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMWaitEvaluteUserHandleCellHeight (40)

@protocol LMWaitEvaluteUserHandleCellDelegate;
@interface LMWaitEvaluteUserHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMWaitEvaluteUserHandleCellDelegate>delegate;
@end

@protocol LMWaitEvaluteUserHandleCellDelegate <NSObject>
-(void)userEvaluateOrder:(id)sender;

@end
