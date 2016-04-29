//
//  NSString+Size.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGFloat)stringHeight:(UIFont*)font width:(CGFloat)width{
    if(self.length==0){
        return 0.0;
    }
    CGSize size = CGSizeMake(width, 20000);
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [self boundingRectWithSize:size
                                    options:NSStringDrawingTruncatesLastVisibleLine
                | NSStringDrawingUsesLineFragmentOrigin
                | NSStringDrawingUsesFontLeading
                                 attributes:@{NSFontAttributeName: font}
                                    context:nil].size.height;
#endif
    }
    else{
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, 20000)
                      lineBreakMode:NSLineBreakByWordWrapping].height;
    }
}

- (CGSize)stringSize:(UIFont*)font{
    if(self.length==0){
        return CGSizeZero;
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [self sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [self sizeWithFont:font];
    }
    
}
+ (CGFloat)stringHeightOfFont:(UIFont*)font{
    return [@"Elty" stringSize:font].height;
}

+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font{
    return [self sizeWithString:string font:font maxW:MAXFLOAT];
}

+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font maxW:(CGFloat)maxW{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxW, MAXFLOAT);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size ;
    
}
@end
