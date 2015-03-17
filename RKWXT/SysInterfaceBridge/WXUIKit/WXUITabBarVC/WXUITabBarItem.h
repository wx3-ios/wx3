//
//  WXUITabBarItem.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"
#import "WXButton.h"

typedef enum {
    E_TabBarStatus_Normal = 0,
    E_TabBarStatus_SingleSelected,
    E_TabBarStatus_DoubleSelected,
}E_TabBarStatus;

@interface WXUITabBarItem :WXButton
@property (nonatomic,assign)E_TabBarStatus status;
@property (nonatomic,retain)NSString *repeatSelectedTitle;
@property (nonatomic,retain)UIColor *repeatSelectedTitleColor;
@property (nonatomic,retain)UIImage *repeatSelectedImage;
@property (nonatomic,retain)UIImage *repeatSelectedBgImage;

+ (WXUITabBarItem*)tabBarItem;
- (void)setTabBarItemTitle:(NSString *)title forState:(WXButtonControlState)state;
- (void)setTabBarItemTitleColor:(UIColor *)color forState:(WXButtonControlState)state;
- (void)setTabBarItemImage:(UIImage *)image forState:(WXButtonControlState)state;
- (void)setTabBarItemBackgroundImage:(UIImage *)image forState:(WXButtonControlState)state;

- (void)repeatClick;
@end
