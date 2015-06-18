//
//  NewHomePageCommonDef.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_NewHomePageCommonDef_h
#define RKWXT_NewHomePageCommonDef_h

#define yGap                            (0.5)    //以下所有高度均是加了yGap后的高度
#define xGap                            (0.5)
#define T_HomePageTopImgHeight          (115)
#define T_HomePageBaseFunctionHeight    (40)
#define T_HomePageWXIntructionHeight    (92)
#define T_HomePageLimitBuyHeight        (110)
#define T_HomePageTextSectionHeight     (27)
#define T_HomePageForMeHeight           (145)
#define T_HomePageTopicalHeight         (70)
#define T_HomePageChangeInfoHeight      (195)

#define BigTextFont   (15.0)
#define SmallTextFont (12.0)

#define BigTextColor   (0x282828)
#define SmallTextColor (0xa5a3a3)
#define HomePageBGColor (0xefeff4)

#define WxIntructionShow (2)
#define ForMeShow        (3)
#define TopicalShow      (2)
#define ChangeInfoShow   (2)

//section
enum{
    T_HomePage_TopImg = 0,     //顶部图片
    T_HomePage_BaseFunction,   //4个基础功能模块
    T_HomePage_WXIntroduce,    //我信介绍
//    T_HomePage_LimitBuy,       //限时购
    T_HomePage_ForMe,          //为我推荐
    T_HomePage_ForMeInfo,      //
    T_HomePage_Topical,        //主题馆
    T_HomePage_TopicalInfo,    //
    T_HomePage_Change,         //换一批
    T_HomePage_ChangeInfo,     //
    
    T_HomePage_Invalid,
};

#import "PullingRefreshTableView.h"
#import "WXHomeTopGoodCell.h"
#import "BaseFunctionCell.h"
#import "WxIntructionCell.h"
#import "T_ForMeCell.h"
#import "T_TopicalCell.h"
#import "T_ChangeTitleCell.h"
#import "T_ChangeCell.h"
#import "NewHomePageModel.h"
#import "SignViewController.h"
#import "WXTMallListWebVC.h"
#import "WXSysMsgUnreadV.h"
#define Size self.bounds.size

typedef enum{
    E_CellRefreshing_Nothing = 0,
    E_CellRefreshing_UnderWay,
    E_CellRefreshing_Finish,
    
    E_CellRefreshing_Invalid,
}E_CellRefreshing;

#pragma mark 导航跳转
enum{
    HomePageJump_Type_GoodsInfo = 0,
    HomePageJump_Type_Catagary,
    HomePageJump_Type_MessageCenter,
    HomePageJump_Type_MessageInfo,
    HomePageJump_Type_UserBonus,
    HomePageJump_Type_BusinessAlliance,
    
    HomePageJump_Type_Invalid
};

#endif
