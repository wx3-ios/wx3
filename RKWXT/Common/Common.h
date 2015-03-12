//
//  Common.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_Common_h
#define RKWXT_Common_h

#pragma mark 系统的一些尺寸以及版本定义~
//上层ui统一使用该宏作为screen的宽度和高度
#define IS_IPHONE_5 (UIDeviceScreenType_iPhoneRetina4Inch == [UIDevice currentScreenType])
#define iosVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define isIOS6     (iosVersion >= 6.0 && iosVersion < 7.0)
#define isIOS7     (iosVersion >= 7.0)
#define isIOS8     (iosVersion >= 8.0)
#define IPHONE_SCREEN_WIDTH 320
#define IPHONE_SCREEN_HEIGHT (IS_IPHONE_5 ? 568 : 480)
#define IPHONE_STATUS_BAR_HEIGHT 20                     //状态栏高度
#define NAVIGATION_BAR_HEGITH      (44)
#define TAB_NAVIGATION_BAR_HEGITH  (49)
#define kIOS7OffX                  (-15)

#endif
