//
//  BaseViewController.h
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController<WXUITabBarDelegate>
@property (nonatomic,readonly)NSArray *controllers;
@property (nonatomic,readonly)WXUITabBar *tabBar;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign,readonly)UIView *baseView;
- (id)initWithControllers:(NSArray*)controllers tabBar:(WXUITabBar*)tabBar;
- (void)setTabBarHidden:(BOOL)hidden aniamted:(BOOL)animated completion:(void (^)(void))completion;

- (void)selectedAtIndex:(NSInteger)index;

@end
