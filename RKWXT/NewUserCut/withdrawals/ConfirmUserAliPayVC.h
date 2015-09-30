//
//  ConfirmUserAliPayVC.h
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#define D_Notification_Name_ChangeUserWithdrawalsSucceed @"D_Notification_Name_ChangeUserWithdrawalsSucceed"
#define ConfirmSign @"ConfirmSign"

#import "WXUIViewController.h"

@interface ConfirmUserAliPayVC : WXUIViewController
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *aliAcount;
@property (nonatomic,strong) NSString *userName;

@end
