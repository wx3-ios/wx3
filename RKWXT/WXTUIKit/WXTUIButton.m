//
//  WXTUIButton.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUIButton.h"
#import "UIImage+Render.h"

@implementation WXTUIButton

- (void)setBackgroundImageOfColor:(UIColor*)color controlState:(UIControlState)state{
    UIImage *img = [UIImage imageFromColor:color];
    [self setBackgroundImage:img forState:state];
}

@end
