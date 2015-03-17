//
//  UIFont+WX.h
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    E_FontSize_Small = 0,
    E_FontSize_Normal,
    E_FontSize_Big_0, //14.0
    E_FontSize_Big_1, //16.0
    E_FontSize_Larg,
    E_FontSize_Hug,
    
    E_FontSize_Invalid,
}E_FontSize;

#define WXFont(f) [UIFont systemFontOfSize:f]
#define WXFontE(e) [UIFont fontWithE:e]
@interface UIFont (WX)

+ (UIFont*)fontWithE:(E_FontSize)eFont;

@end
