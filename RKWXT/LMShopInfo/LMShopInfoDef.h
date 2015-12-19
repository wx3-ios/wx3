//
//  LMShopInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#ifndef LMShopInfoDef_h
#define LMShopInfoDef_h

#import "LMShopInfoTopImgCell.h"
#import "LMShopInfoBaseFunctionCell.h"
#import "LMShopInfoActivityCell.h"
#import "ShopInfoHotGoodsCell.h"
#import "ShopInfAllGoodsCell.h"
#import "ShopInfoEvaluateCell.h"

#import "CDSideBarController.h"
#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import "LMShopInfoModel.h"
#import "LMShopInfoEntity.h"
#import "LMDataCollectionModel.h"

#import "LMShopInfoAllGoodsVC.h"
#import "LMShopInfoNewGoodsVC.h"
#import "LMShopInfoTrendsVC.h"

#define Size self.bounds.size

#define LMShopInfoTopImgHeight          IPHONE_SCREEN_WIDTH/3
#define LMShopInfoBaseFunctionHeight    (48)
#define LMShopInfoActivityHeight        (135)
#define LMShopInfoSectionTitleHeight    (40)
#define LMShopInfoHotGoodsHeight        (220)
#define LMShopInfoEvaluateHeight        (90)

enum{
    LMShopInfo_Section_TopImg = 0,
    LMShopInfo_Section_BaseFunction,
    LMShopInfo_Section_Activity,
    LMShopInfo_Section_HotGoods,
    LMShopInfo_Section_AllGoods,
//    LMShopInfo_Section_Evaluate,
    
    LMShopInfo_Section_Invalid,
};

enum{
    Share_Qq,
    Share_Qzone,
    Share_Friends,
    Share_Clrcle,
    
    Share_Invalid,
};

#endif /* LMShopInfoDef_h */
