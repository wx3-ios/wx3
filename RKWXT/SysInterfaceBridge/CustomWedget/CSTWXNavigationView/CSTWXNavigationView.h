
//
//  CSTWXNavigationView.h
//  CallTesting
//
//  Created by le ting on 4/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//
#define kDefaultNavigationBarButtonSize CGSizeMake(NAVIGATION_BAR_HEGITH,NAVIGATION_BAR_HEGITH)

#import "WXUIView.h"

@interface CSTWXNavigationView : WXUIView
@property (nonatomic,assign,readonly)WXUILabel *titleLable;
+ (id)cstWXNavigationView;

- (void)setLeftNavigationItem:(UIView*)btn;
- (void)setRightNavigationItem:(UIView*)btn;

- (void)setTitle:(NSString*)title;
- (void)setTitleFont:(UIFont*)font;
- (void)setTitleColor:(UIColor*)color;
@end
