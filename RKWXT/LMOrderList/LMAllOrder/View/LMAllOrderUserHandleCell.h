//
//  LMAllOrderUserHandleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMAllOrderUserHandleCellHeight (40)

@protocol LMAllOrderUserHandleCellDelegate;
@interface LMAllOrderUserHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMAllOrderUserHandleCellDelegate>delegate;
@end

@protocol LMAllOrderUserHandleCellDelegate <NSObject>
-(void)userCancelOrder:(id)sender;
-(void)userPayOrder:(id)sender;
-(void)userCompleteOrder:(id)sender;
-(void)userEvaluateOrder:(id)sender;

@end
