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

typedef enum{
    Confirm_Type_Normal = 0,
    Confirm_Type_Submit,
    Confirm_Type_Change,
}Confirm_Type;

@interface ConfirmUserAliPayVC : WXUIViewController
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *aliAcount;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,assign) Confirm_Type confirmType;

@end
