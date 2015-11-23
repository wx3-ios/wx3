//
//  ToSnapUp.h
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_ToSnapUp_h
#define RKWXT_ToSnapUp_h

#import "UtilTool.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "NSObject+SBJson.h"



#import "TimeShopModer.h"

#import "HeardView.h"
#import "HeardTopView.h"
#import "HeardGoodsView.h"

#import "UIViewAdditions.h"
#import "NSString+XBCategory.h"
#import "UIColor+XBCategory.h"

#import "WXUIViewController.h"
#import "WXRemotionImgBtn.h"

/** 区头部两边间距 */
#define TopMargin (10)
/** 区商品间距 */
#define T_GoodsMaegin (7.5)
/** 区头部高度 */
#define T_Height (42.5)

/** cell内部控件间距 */
#define C_Margin (7.5)
#define C_Spcing (15)
#define C_N_Spcing (10.5)
#define C_N_P_Spcing (15)
#define C_ImageW (98)

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

#endif
