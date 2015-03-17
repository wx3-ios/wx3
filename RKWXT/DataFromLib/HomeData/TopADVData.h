//
//  TopADVData.h
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
// 首页顶部广告~ 

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@protocol TopADVDataDelegate;
@interface TopADVData : BaseModel
@property (nonatomic,assign)id<TopADVDataDelegate>delegate;
@property (nonatomic,readonly)NSArray *topADVList;

- (E_LoadDataReturnValue)loadTopADVData;//加载顶部广告~
@end

@protocol TopADVDataDelegate <NSObject>
- (void)topADVDataLoadSucceed;
- (void)topADVDataLoadFailed;
@end
