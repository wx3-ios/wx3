//
//  OrderPayVC.h
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

#pragma mark 不同的支付来源需要订单加入不同的前缀
typedef enum{
    OrderPay_Type_Order = 0,  //商城订单S
    OrderPay_Type_Recharge,   //话费充值R
    OrderPay_Type_Money,      //抽奖订单P
}OrderPay_Type;

@interface OrderPayVC : WXUIViewController
@property (nonatomic,assign) OrderPay_Type orderpay_type;
@property (nonatomic,assign) CGFloat payMoney;
@property (nonatomic,strong) NSString *orderID;

@end
