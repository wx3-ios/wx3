//
//  UIView+Render.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Render)
- (void)setBorderRadian:(CGFloat)radian width:(CGFloat)width color:(UIColor*)color;
- (void)toRound;
- (void)toRoundViewBorder:(CGFloat)borderWidth borderColor:(UIColor*)color;

@end
