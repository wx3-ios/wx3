//
//  UIColor+WXT.m
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import "UIColor+WXT.h"

@implementation UIColor (WXT)

+ (UIColor*)colorWithRGB:(NSInteger)rgb{
    return [self colorWithRGB:rgb alpha:1.0];
}

+ (UIColor*)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha{
    NSInteger b = rgb%0x100;
    NSInteger g = (rgb%0x10000)/0x100;
    NSInteger r = rgb/0x10000;
    return [self colrWithR:r g:g b:b alpha:alpha];
}

+ (UIColor*)colrWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b
{
    return [self colorWithRed:r green:g blue:b alpha:1.0];
}

+ (UIColor*)colrWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha{
    CGFloat red = r;
    CGFloat green = g;
    CGFloat blue = b;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end

