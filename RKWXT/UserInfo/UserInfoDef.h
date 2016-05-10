//
//  UserInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_UserInfoDef_h
#define RKWXT_UserInfoDef_h

#import "PersonalInfoOrderListCell.h"
#import "PersonalOrderInfoCell.h"
#import "PersonalMoneyCell.h"
#import "PersonalCallCell.h"
#import "UserInfoCommonCell.h"


#import "RechargeVC.h"
#import "UserBalanceVC.h"
#import "SignViewController.h"
#import "LoginVC.h"
#import "AboutWxtInfoVC.h"
#import "WXTResetPwdVC.h"
#import "NewSystemSettingVC.h"
#import "BaseInfoVC.h"
#import "HomeOrderVC.h"

#import "T_MenuVC.h"
#import "HomeOrderVC.h"
#import "UserBonusVC.h"
#import "UserCutVC.h"
#import "LuckyGoodsOrderList.h"
#import "CollectionListVC.h"

#import "ShareModel.h"

enum{
    PersonalInfo_Order = 0,
//    PersonalInfo_Money,
    PersonalInfo_SharkOrder,
    PersonalInfo_Call,
//    PersonalInfo_Extend,
    PersonalInfo_CutAndShare,
    PersonalInfo_System,
    
    PersonalInfo_Invalid
};

//PersonalInfo_Order
enum{
    Order_listAll = 0,
    Order_Category,
    
    Order_Invalid
};

enum{
    Shark_Order = 0,
    Shark_Store,
    
    Shark_Invalid,
};

enum{
    Money_listAll = 0,
    Money_Category,
    
    Money_Invalid
};

enum{
    Call_Recharge,
    Call_Sign,
    
    Call_Invalid
};

enum{
    Extend_listAll = 0,
    Extend_Share,
    
    Extend_Invalid
};

enum{
    System_Setting = 0,
    System_About,
    
    System_Invalid
};

enum{
    User_Cut = 0,
    User_Share,
    
    User_Invalid
};

#endif
