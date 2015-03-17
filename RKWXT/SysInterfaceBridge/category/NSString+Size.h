//
//  NSString+Size.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGFloat)stringHeight:(UIFont*)font width:(CGFloat)width;
- (CGSize)stringSize:(UIFont*)font;
+ (CGFloat)stringHeightOfFont:(UIFont*)font;
@end
