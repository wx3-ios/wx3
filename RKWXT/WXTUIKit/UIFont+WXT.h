//
//  UIFont+WXT.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WXT_FontSize_Small = 0,
    WXT_FontSize_Normal,
    WXT_FontSize_Big_0, //14.0
    WXT_FontSize_Big_1, //16.0
    WXT_FontSize_Larg,
    WXT_FontSize_Hug,
    
    WXT_FontSize_Invalid,
}WXT_FontSize;

#define WXTFont(f) [UIFont systemFontOfSize:f]
#define WXTFontE(e) [UIFont fontWithE:e]

@interface UIFont (WXT)
+ (UIFont*)fontWithE:(WXT_FontSize)eFont;

@end
