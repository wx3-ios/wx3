//
//  WXUITabBarVC.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIViewController.h"
#import "WXUITabBar.h"

#define kWXUITabBarAnimatedDuration (0.3)
@interface WXUITabBarVC : WXUIViewController<WXUITabBarDelegate>
@property (nonatomic,readonly)NSArray *controllers;
@property (nonatomic,readonly)WXUITabBar *tabBar;
@property (nonatomic,assign)NSInteger selectedIndex;

- (id)initWithControllers:(NSArray*)controllers tabBar:(WXUITabBar*)tabBar;
- (void)setTabBarHidden:(BOOL)hidden aniamted:(BOOL)animated completion:(void (^)(void))completion;

- (void)selectedAtIndex:(NSInteger)index;
@end