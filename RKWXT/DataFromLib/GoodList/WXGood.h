//
//  WXGood.h
//  Woxin2.0
//
//  Created by Elty on 11/27/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "BaseModel.h"

@protocol WXGoodDelegate;
@interface WXGood : BaseModel
@property (nonatomic,assign)id<WXGoodDelegate>delegate;
@property (nonatomic,readonly)NSArray *goodList;

- (E_LoadDataReturnValue)loadGoodList;
@end

@protocol WXGoodDelegate <NSObject>
- (void)allGoodsLoadedSucceed;
- (void)allGoodsLoadedFailed;
@end
