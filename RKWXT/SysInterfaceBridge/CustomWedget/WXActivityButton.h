//
//  WXActivityButton.h
//  CallTesting
//
//  Created by le ting on 5/12/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIButton.h"

@interface WXActivityButton : WXUIView
@property (nonatomic,assign)NSInteger state;

- (id)initWithFrame:(CGRect)frame buttonType:(UIButtonType)buttonType;
#pragma mark attr
- (void)setTitle:(NSString*)title forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state;
- (void)setTitleFont:(UIFont*)font;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setEnable:(BOOL)enable;
- (void)startGetBtnStatus;
- (void)stopGetBtnStatus;
@end
