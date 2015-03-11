//
//  NSString+Size.m
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGFloat)stringHeight:(UIFont*)font width:(CGFloat)width{
    if(self.length==0){
        return 0.0;
    }
    CGSize size = CGSizeMake(width, 20000);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [self boundingRectWithSize:size
                                  options:NSStringDrawingTruncatesLastVisibleLine
                | NSStringDrawingUsesLineFragmentOrigin
                | NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName: font}
                                  context:nil].size.height;
#endif
}

- (CGSize)stringSize:(UIFont*)font{
    if(self.length==0){
        return CGSizeZero;
    }
    return [self sizeWithAttributes:@{NSFontAttributeName: font}];
}

+ (CGFloat)stringHeightOfFont:(UIFont*)font{
    return [@"wxt" stringSize:font].height;
}

@end
