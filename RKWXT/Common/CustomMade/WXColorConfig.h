//
//  LogRegColorOBJ.h
//  Woxin2.0
//
//  Created by Elty on 12/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 注册和登录~
typedef	enum{
	E_LogReg_Color_BG = 0,
	//文本~
	E_LogReg_Color_TextFieldBorder,
	E_LogReg_Color_TextFieldPlaceHoder,
	E_LogReg_Color_TextFieldContent,
	//登录和注册的提交按钮
	E_SubmitBtn_Color_NormalBg,//normal的背景色~
	E_SubmitBtn_Color_HighLightBg,//高亮背景色~
	E_SubmitBtn_Color_DisableBg,//disable的背景色~
	E_SubmitBtn_Color_TxtNormal,
	E_SubmitBtn_Color_TxtHighLight,
	E_SubmitBtn_Color_TxtDisable,
	//连接注册页面的按钮
	E_ToRegBtn_Color_Border,//
	E_ToRegBtn_Color_NormalBg,
	E_ToRegBtn_Color_HighLightBg,
	E_ToRegBtn_Color_DisableBg,
	E_ToRegBtn_Color_TxtNormal,
	E_ToRegBtn_Color_TxtHighLight,
	E_ToRegBtn_Color_TxtDisable,
	
	E_TxtBtn_Color_Normal,
	E_TxtBtn_Color_Hilight,
	E_TxtBtn_Color_Disable,
	
	E_LogReg_Color_Invalid,
}E_LogRegColorType;

static int logRegColorList[][E_LogReg_Color_Invalid] ={
	{-1,0xAEAEAC,0xcab6b9,0xffffff,0xffffff,0xf74b35,0xd2d2d2,0xf74b35,0xffffff,0xffffff,0xd2d2d2,-1,-1,0xd2d2d2,0xffffff,0xf74b35,0xffffff,0xD5D5D5,0xffffff,0x9a9a9a}, //餐饮版
	{0x0c8bdf,0x9dd0f2,0xe6e6e6,0xffffff,0xffffff,0x76c8fe,0xd2d2d2,0x0c8bdf,0xffffff,0xffffff,0xffffff,-1,0xffffff,0xd2d2d2,0xffffff,0x0c8bdf,0xffffff,0xD5D5D5,0xffffff,0x9a9a9a},//我信科技版
	{-1,0xffffff,0xe6e6e6,0xffffff,0xffffff,0xf74b35,0xd2d2d2,0xf74b35,0xffffff,0xffffff,0xffffff,-1,0xffffff,0xd2d2d2,0xffffff,0xff5566,0xffffff,0xD5D5D5,0xffffff,0x9a9a9a},//瑞姬娜版
};

#pragma mark 其他颜色~
typedef enum{
	E_App_Other_Color_NavBar = 0,//导航栏~
	E_App_Other_Color_TabBar,
	E_App_Other_Color_TabBarTitleNormal,
	E_App_Other_Color_TabBarTitleHighlight,
	E_App_Other_Color_Btn_BorderColor,
	E_App_Other_Color_Btn_BgNormal,
	E_App_Other_Color_Btn_BgHilight,
	E_App_Other_Color_Btn_BgDisable,
	E_App_Other_Color_Btn_Title,
	
	E_App_Other_Color_Invalid,
}E_App_Other_Color;

static int otherColor[][E_App_Other_Color_Invalid] = {
	{0x00c496,0xebebeb,0xa0a0a0,0x00C296,-1,0xfe9900,0xec8f02,0xc8c8c8,0xFFFFFF},
//	{0x0C8BDF,0xebebeb,0xa0a0a0,0x0c8bdf,0x00ff00,0xfe9900,0xfe9900,0xfe9900,0xFFFFFF},
    {0xf7f7f7,0xf7f7f7,0xa0a0a0,0x0c8bdf,0x00ff00,0xfe9900,0xfe9900,0xfe9900,0xFFFFFF},
};

typedef enum{
	E_OtherColorType_Nav = 0,//导航的颜色~
	
}E_OtherColorType;

#define kLogRegColor(i) [WXColorConfig logAndRegColorWithType:i]
#define kOtherColor(i) [WXColorConfig otherColorWithType:i]

@interface WXColorConfig : NSObject

+ (UIColor*)logAndRegColorWithType:(E_LogRegColorType)type;
+ (UIColor*)otherColorWithType:(E_App_Other_Color)type;
@end
