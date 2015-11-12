//
//  WinningBackgroundView.m
//  RKWXT
//
//  Created by SHB on 15/11/12.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WinningBackgroundView.h"

@implementation WinningBackgroundView

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationCount = 2;
    CGFloat locations[2] = {0.0f,1.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.20f,0.0f,0.20f,1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end
