//
//  GoodsInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_GoodsInfoDef_h
#define RKWXT_GoodsInfoDef_h

#define T_GoodsInfoTopImgHeight    (320)
#define T_GoodsInfoDescHeight      (80)
#define T_GoodsInfoWebCellHeight   (44)
#define T_GoodsInfoOldBDCellHeight (44)
//#define T_GoodsInfoNewBDCellHeight     //无法写死
#define bigTextColor    (0x000000)
#define midTextColor    (0xdd2726)
#define smallTextColor  (0x9b9b9b)

#define bigTextFont     (12.0)
#define midTextFont     (14.0)
#define smallTextFont   (14.0)

#define UpViewShowStyleNumber  (3)

enum{
    T_GoodsInfo_TopImg = 0,
    T_GoodsInfo_Description,
    T_GoodsInfo_DownView,
    T_GoodsInfo_WebShow,
    T_GoodsInfo_BaseData,
    T_GoodsInfo_Evaluation,
    
    T_GoodsInfo_Invalid,
};

enum{
    Share_Friends,
    Share_Qq,
    Share_Clrcle,
    Share_Qzone,
    
    Share_Invalid,
};

#import "WXRemotionImgBtn.h"
#import "MerchantImageCell.h"
#import "NewGoodsInfoDesCell.h"
#import "NewGoodsInfoDownCell.h"
#import "NewGoodsInfoBDCell.h"
#import "NewGoodsEvalTitleCell.h"
#import "NewGEvalutionInfoCell.h"
#import "MakeOrderVC.h"
#import "GoodsInfoActiviCell.h"

#import "GoodsEvaluationVC.h"
#import "ShopActivityEntity.h"
#import "NewGoodsNoDataTtitle.h"

#endif
