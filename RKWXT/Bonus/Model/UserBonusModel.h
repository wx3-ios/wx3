//
//  UserBonusModel.h
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_UserBonus_LoadDateSucceed   @"K_Notification_UserBonus_LoadDateSucceed"
#define K_Notification_UserBonus_LoadDateFailed    @"K_Notification_UserBonus_LoadDateFailed"
#define K_Notification_UserBonus_GainBonusSucceed  @"K_Notification_UserBonus_GainBonusSucceed"
#define K_Notification_UserBonus_GainBonusFailed   @"K_Notification_UserBonus_GainBonusFailed"

#define K_Notification_UserBonus_UserBonusSucceed  @"K_Notification_UserBonus_UserBonusSucceed"
#define K_Notification_UserBonus_UserBonusFailed   @"K_Notification_UserBonus_UserBonusFailed"

@interface UserBonusModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *userBonusArr;
@property (nonatomic,strong) NSArray *denyBonusArr;
@property (nonatomic,assign) NSInteger bonusMoney;

+(UserBonusModel*)shareUserBonusModel;
-(BOOL)shouldDataReload;
-(void)loadUserBonusMoney; //红包余额
-(void)loadUserBonus;  //领取所有红包
-(void)gainUserBonus:(NSInteger)bonusID;  //获取红包

@end
