//
//  HomeNavModel.h
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomeNavModelDelegate;
@interface HomeNavModel : T_HPSubBaseModel
@property (nonatomic,assign) id<HomeNavModelDelegate>delegate;
@end

@protocol HomeNavModelDelegate <NSObject>
-(void)homeNavigationLoadSucceed;
-(void)homeNavigationLoadFailed:(NSString*)errorMsg;

@end
