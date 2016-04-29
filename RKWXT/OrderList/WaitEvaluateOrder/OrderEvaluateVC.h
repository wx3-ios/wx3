//
//  OrderEvaluateVC.h
//  RKWXT
//
//  Created by SHB on 16/4/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

#define K_Notification_Name_EvaluateOrderSucceed @"K_Notification_Name_EvaluateOrderSucceed"

@class OrderListEntity;

@interface OrderEvaluateVC : WXUIViewController
@property (nonatomic,strong) OrderListEntity *orderEntity;

@end
