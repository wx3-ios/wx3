//
//  RootViewController.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//
#define kTabBarHeight (IS_IPHONE_5?60.0:40.0)
#define kTabBarItemNumber (4)

#import "BaseViewController.h"
#import "WXUITabBarVC.h"
@class WXUITabBar;
@interface RootViewController : BaseViewController<WXUITabBarDelegate>{
    WXUITabBar * wxTabBar;
}


@end
