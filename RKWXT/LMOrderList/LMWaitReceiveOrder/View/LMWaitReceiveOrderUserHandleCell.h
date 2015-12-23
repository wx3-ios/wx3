//
//  LMWaitReceiveOrderUserHandleCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define LMWaitReceiveOrderUserHandleCellHeight (40)

@protocol LMWaitReceiveOrderUserHandleCellDelegate;
@interface LMWaitReceiveOrderUserHandleCell : WXUITableViewCell
@property (nonatomic,assign) id<LMWaitReceiveOrderUserHandleCellDelegate>delegate;
@end

@protocol LMWaitReceiveOrderUserHandleCellDelegate <NSObject>
-(void)userCompleteOrder:(id)sender;

@end
