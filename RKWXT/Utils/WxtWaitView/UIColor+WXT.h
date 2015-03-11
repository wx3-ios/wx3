//
//  UIColor+WXT.h
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WXColorWithInteger(i)	[UIColor colorWithRGB:i]
@interface UIColor (WXT)

+ (UIColor*)colorWithRGB:(NSInteger)rgb;
+ (UIColor*)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;
+ (UIColor*)colrWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;
+ (UIColor*)colrWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha;

@end
