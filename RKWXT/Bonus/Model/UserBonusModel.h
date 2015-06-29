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

@interface UserBonusModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *userBonusArr;
@property (nonatomic,strong) NSArray *denyBonusArr;

+(UserBonusModel*)shareUserBonusModel;
-(BOOL)shouldDataReload;
-(void)loadUserBonus;  //领取所有红包
-(void)gainUserBonus:(NSInteger)bonusID;  //获取红包

@end
