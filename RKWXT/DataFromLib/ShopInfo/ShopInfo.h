//
//  ShopInfo.h
//  Woxin2.0
//
//  Created by Elty on 12/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "ShopDesc.h"
#import "SubShopTime.h"

#define D_Notification_Name_LoadShopInfoSucceed @"D_Notification_Name_LoadShopInfoSucceed"
#define D_Notification_Name_LoadShopInfoFailed @"D_Notification_Name_LoadShopInfoFailed"
@interface ShopInfo : BaseModel
@property (nonatomic,readonly)NSArray *shopTimeList;
@property (nonatomic,readonly)NSArray *descArray;
@property (nonatomic,retain)NSString *address;
@property (nonatomic,assign)NSInteger scheduleDay;//可提前多少天预订
@property (nonatomic,retain)NSString *business;//行业
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *phone;
@property (nonatomic,retain)NSString *shopTel;

+ (ShopInfo*)sharedShopInfo;
- (E_LoadDataReturnValue)loadShopInfo;
- (BOOL)isValid;
@end
