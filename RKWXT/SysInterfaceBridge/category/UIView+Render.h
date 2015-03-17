//
//  UIView+Render.h
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Render)
- (void)setBorderRadian:(CGFloat)radian width:(CGFloat)width color:(UIColor*)color;
- (void)toRound;
- (void)toRoundViewBorder:(CGFloat)borderWidth borderColor:(UIColor*)color;
@end
