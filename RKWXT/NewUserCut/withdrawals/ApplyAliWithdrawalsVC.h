//
//  ApplyAliWithdrawalsVC.h
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#define D_Notification_Name_ApplyAliMoneySucceed @"D_Notification_Name_ApplyAliMoneySucceed"
#define ApplySucceed @"ApplySucceed"

#import "WXUIViewController.h"

@class UserAliEntity;

@interface ApplyAliWithdrawalsVC : WXUIViewController
@property (nonatomic,assign) CGFloat money;
@property (nonatomic,strong) UserAliEntity *entity;

@end
