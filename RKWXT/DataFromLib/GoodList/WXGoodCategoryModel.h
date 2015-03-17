//
//  WXGoodCategoryModel.h
//  Woxin2.0
//
//  Created by Elty on 10/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define D_Notification_Name_LoadGoodCategorySucceed @"D_Notification_Name_LoadGoodCategorySucceed"
#define D_Notification_Name_LoadGoodCategoryFailed @"D_Notification_Name_LoadGoodCategoryFailed"
@interface WXGoodCategoryModel :BaseModel
@property (nonatomic,readonly)NSArray *goodCategoryList;

+ (WXGoodCategoryModel*)sharedGoodCategoryModel;
- (BOOL)isDataReady;
- (void)removeALL;
- (E_LoadDataReturnValue)loadGoodCategaryList;
@end
