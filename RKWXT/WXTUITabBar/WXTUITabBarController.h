//
//  WXTUITabBarController.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTUITabBarController : UITabBarController<WXUITabBarDelegate>

//@property (nonatomic,readonly)WXUITabBar *tabBar;
-(void)createViewController;

//- (void)setTabBarHidden:(BOOL)hidden aniamted:(BOOL)animated completion:(void (^)(void))completion;
@end
