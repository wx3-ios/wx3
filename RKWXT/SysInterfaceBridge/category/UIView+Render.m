//
//  UIView+Render.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "UIView+Render.h"

@implementation UIView (Render)

- (void)setBorderRadian:(CGFloat)radian width:(CGFloat)width color:(UIColor*)color{
    CALayer *layer = [self layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radian];
    [layer setBorderWidth:width];
    [layer setBorderColor:[color CGColor]];
}

- (void)toRound{
    CGSize size = self.bounds.size;
    [self setBorderRadian:size.width*0.5 width:0 color:[UIColor clearColor]];
}

- (void)toRoundViewBorder:(CGFloat)borderWidth borderColor:(UIColor*)color{
    CGSize size = self.bounds.size;
    [self setBorderRadian:size.width*0.5 width:borderWidth color:color];
}

@end
