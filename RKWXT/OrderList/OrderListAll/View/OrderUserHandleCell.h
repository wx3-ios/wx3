//
//  OrderUserHandleCell.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define OrderHandleCellHeight   (57)

@protocol OrderUserHandleDelegate;

@interface OrderUserHandleCell : WXTUITableViewCell
@property (nonatomic,assign) id<OrderUserHandleDelegate>delegate;
@end

@protocol OrderUserHandleDelegate <NSObject>
-(void)userPayBtnClicked:(id)sender;  //支付
-(void)userRefundBtnClicked:(id)sender; //退款
-(void)userHurryBtnClicked:(id)sender;  //催单
-(void)userCancelBtnClicked:(id)sender;  //取消
-(void)userCompleteBtnClicked:(id)sender; //完成
-(void)userEvaluateBtnClicked:(id)sender; //评价

@end
