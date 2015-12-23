//
//  LMOrderEvaluteVC.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

#define K_Notification_Name_UserEvaluateOrderSucceed @"K_Notification_Name_UserEvaluateOrderSucceed"

@class LMOrderListEntity;

@interface LMOrderEvaluteVC : WXUIViewController
@property (nonatomic,strong) LMOrderListEntity *orderEntity;

@end
