//
//  OrderWaitPayConsultCell.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define OrderWaitPayConsultCellHeight (50)

@protocol WaitPayOrderListDelegate;

@interface OrderWaitPayConsultCell : WXTUITableViewCell
@property (nonatomic,assign) id<WaitPayOrderListDelegate>delegate;
@end

@protocol WaitPayOrderListDelegate <NSObject>
-(void)userPayBtnClicked:(id)sender;  //支付
-(void)userCancelBtnClicked:(id)sender;  //取消

@end
