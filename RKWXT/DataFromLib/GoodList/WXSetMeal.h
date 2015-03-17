//
//  WXSetMeal.h
//  Woxin2.0
//
//  Created by Elty on 11/27/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "BaseModel.h"

@protocol  WXSetMealDelegate;
@interface WXSetMeal : BaseModel
@property (nonatomic,assign)id<WXSetMealDelegate>delegate;
@property (nonatomic,readonly)NSArray *setMealList;

- (E_LoadDataReturnValue)loadAllSetMeals;
@end

@protocol  WXSetMealDelegate <NSObject>
- (void)allSetMealLoadedSucceed;
- (void)allSetMealLoadedFailed;
@end