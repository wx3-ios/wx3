//
//  UIView+Sizing.m
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-16.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import "UIView+Sizing.h"

@implementation UIView (Sizing)



- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    
    if (self.constraints > 0) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = width;
                return;
            }
        }
    }
   
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
}

- (void)setHieght:(CGFloat)height
{
    if (self.constraints > 0) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = height;
                return;
            }
        }
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}

- (void)setCenterX:(CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}

- (void)setCenterY:(CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}


@end
