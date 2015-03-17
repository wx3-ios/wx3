//
//  WXUITabBar.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"
#import "WXUITabBarItem.h"

@protocol WXUITabBarDelegate;
@interface WXUITabBar : WXUIView
@property (nonatomic,readonly)NSArray *tabBarItemArray;
@property (nonatomic,assign)id<WXUITabBarDelegate>delegate;
@property (nonatomic,assign)NSInteger selectedIndex;

- (id)initWithTabBarHeight:(CGFloat)height;
- (id)init;
- (void)setTabBarItems:(NSArray*)tabBarItems;
@end

@protocol WXUITabBarDelegate <NSObject>
- (void)selectedAtIndex:(NSInteger)index;
@optional
- (void)repeatSelectedAtIndex:(NSInteger)index;
@end
