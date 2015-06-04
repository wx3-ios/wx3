//
//  HomePageTop.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"
#import "HomePageTopEntity.h"

@protocol HomePageTopDelegate;

@interface HomePageTop : T_HPSubBaseModel
@property (nonatomic,assign) id<HomePageTopDelegate>delegate;
@end

@protocol HomePageTopDelegate <NSObject>
-(void)homePageTopLoadedSucceed;
-(void)homePageTopLoadedFailed:(NSArray*)error;

@end
