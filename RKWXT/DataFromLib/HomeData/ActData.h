//
//  ActData.h
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
// 首页活动数据~

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@protocol ActDataDelegate;
@interface ActData : BaseModel
@property (nonatomic,readonly)NSArray *actDataList;
@property (nonatomic,assign)id<ActDataDelegate>delegate;
- (E_LoadDataReturnValue)loadActiveData;
@end


@protocol ActDataDelegate <NSObject>
- (void)loadActiveDataListSucceed;
- (void)loadActiveDataListFailed;
@end
