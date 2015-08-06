//
//  UserCutModel.h
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_Name_UserCut_LoadSucceed @"K_Notification_Name_UserCut_LoadSucceed"
#define K_Notification_Name_UserCut_LoadFailed  @"K_Notification_Name_UserCut_LoadFailed"

@interface UserCutModel : T_HPSubBaseModel
@property (nonatomic,assign) CGFloat cutMoney;
@property (nonatomic,readonly) NSArray *userCutBalance;

+(UserCutModel*)shareUserCutBalanceModel;
-(void)loadUserCutBalance;

@end
