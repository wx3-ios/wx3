//
//  NSString+XBCategory.h
//  xianshiqianggou
//
//  Created by 龙少 on 15/11/14.
//  Copyright (c) 2015年 龙少. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@interface NSString (XBCategory)
+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font maxW:(CGFloat)maxW;
+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font;
+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font maxH:(CGFloat)maxH;
//一个字符串指定其中字符颜色和大小  返回带有属性的字体
+ (NSMutableAttributedString*)changeFontAddColor:(NSString*)rootStr  sonStr:(NSString*)sonStr fontColor:(UIColor*)fontColor ;
+ (NSMutableAttributedString*)changeFontAddColor:(NSString*)rootStr  sonStr:(NSString*)sonStr fontColor:(UIColor*)fontColor font:(UIFont*)font;
@end
