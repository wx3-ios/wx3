//
//  HomePageRecModel.h
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomePageRecDelegate;
@interface HomePageRecModel : T_HPSubBaseModel
@property (nonatomic,assign) id<HomePageRecDelegate>delegate;
@end

@protocol HomePageRecDelegate <NSObject>
-(void)homePageRecLoadedSucceed;
-(void)homePageRecLoadedFailed:(NSString*)errorMsg;

@end
