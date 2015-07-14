//
//  AboutShopModel.h
//  RKWXT
//
//  Created by SHB on 15/7/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_Name_LoadShopInfoSucceed @"K_Notification_Name_LoadShopInfoSucceed"
#define K_Notification_Name_LoadShopInfoFailed  @"K_Notification_Name_LoadShopInfoFailed"

@interface AboutShopModel : T_HPSubBaseModel
@property (nonatomic,readonly) NSArray *shopInfoArr;
+(AboutShopModel*)shareShopModel;
-(void)loadShopInfo;

@end
