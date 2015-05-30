//
//  HomePageThemeModel.h
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomePageThemeDelegate;
@interface HomePageThemeModel : T_HPSubBaseModel
@property (nonatomic,assign) id<HomePageThemeDelegate>delegate;
@end

@protocol HomePageThemeDelegate <NSObject>
-(void)homePageThemeLoadedSucceed;
-(void)homePageThemeLoadedFailed:(NSString*)errorMsg;

@end
