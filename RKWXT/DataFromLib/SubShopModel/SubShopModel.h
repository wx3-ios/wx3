//
//  SubShopModel.h
//  Woxin2.0
//
//  Created by Elty on 10/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubShopArea.h"

#define D_Notification_Name_Model_LoadSubShopListSucceed @"D_Notification_Name_Model_LoadSubShopListSucceed"
#define D_Notification_Name_Model_LoadSubShopListFailed @"D_Notification_Name_Model_LoadSubShopListFailed"

@interface SubShopModel : NSObject
@property (nonatomic,readonly)NSArray *subShopAreaList;

+ (SubShopModel*)sharedSubShopModel;

- (NSInteger)areaIDOfSubShopID:(NSInteger)subShopID;//通过分店ID 获取区域ID
- (BOOL)isSubShopListReady;//数据是否已经加载成功
- (BOOL)loadSubShopList;//加载分店列表

- (SubShopArea*)subShopAreaChose;
- (void)chooseSubShopArea:(SubShopArea*)area;
@end
