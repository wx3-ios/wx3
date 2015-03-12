//
//  UIFont+WXT.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UIFont+WXT.h"

static float s_fontSize[WXT_FontSize_Invalid]=
            {10.0,12.0,14.0,16.0,18.0,20.0};
@implementation UIFont (WX)

+ (UIFont*)fontWithE:(WXT_FontSize)eFont{
    NSAssert(eFont<WXT_FontSize_Invalid && eFont>=0, @"无效的字体");
    return [UIFont systemFontOfSize:s_fontSize[eFont]];
}

@end
