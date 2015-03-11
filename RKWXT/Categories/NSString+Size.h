//
//  NSString+Size.h
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
- (CGFloat)stringHeight:(UIFont*)font width:(CGFloat)width;
- (CGSize)stringSize:(UIFont*)font;
+ (CGFloat)stringHeightOfFont:(UIFont*)font;

@end
