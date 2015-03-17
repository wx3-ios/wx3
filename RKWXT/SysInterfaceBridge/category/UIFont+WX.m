//
//  UIFont+WX.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "UIFont+WX.h"

static float s_fontSize[E_FontSize_Invalid]={10.0,12.0,14.0,16.0,18.0,20.0};
@implementation UIFont (WX)

+ (UIFont*)fontWithE:(E_FontSize)eFont{
    NSAssert(eFont<E_FontSize_Invalid && eFont>=0, @"无效的字体");
    return [UIFont systemFontOfSize:s_fontSize[eFont]];
}
@end
