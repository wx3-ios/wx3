//
//  LMGoodsInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#ifndef LMGoodsInfoDef_h
#define LMGoodsInfoDef_h

#define Size self.bounds.size
#define DownViewHeight (44)
#define TopNavigationViewHeight (64)

#define LMGoodsInfoTitleHeaderViewHeight (45)
#define LMGoodsOtherHeaderViewHeight (36)
#define LMGoodsBaseInfoCellHeight (33)
#define LMGoodsSellerInfoCellHeight (53)

enum{
    LMGoodsInfo_Section_TopImg = 0,
    LMGoodsInfo_Section_GoodsDesc,
    LMGoodsInfo_Section_GoodsInfo,
    LMGoodsInfo_Section_SellerInfo,
    LMGoodsInfo_Section_OtherShop,
    LMGoodsInfo_Section_Evaluate,
    
    LMGoodsInfo_Section_Invalid,
};

#import "MerchantImageCell.h"
#import "LMGoodsDesCell.h"
#import "LMGoodsInfoCell.h"
#import "LMGoodsSellerCell.h"
#import "LMGoodsOtherSellerCell.h"
#import "LMGoodsEvaluteCell.h"

#import "LMGoodsView.h"
#import "NewImageZoomView.h"
#import "WXRemotionImgBtn.h"
#import "NewGoodsInfoWebViewViewController.h"
//分享
#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "CDSideBarController.h"

#import "LMGoodsInfoModel.h"
#import "LMGoodsInfoEntity.h"
#import "LMDataCollectionModel.h"
#import "LMShoppingCartModel.h"

#import "LMMakeOrderVC.h"
#import "LMShoppingCartVC.h"
#import "LMGoodsMoreEvaluateVC.h"

enum{
    Share_Qq,
    Share_Qzone,
    Share_Friends,
    Share_Clrcle,
    
    Share_Invalid,
};

#endif /* LMGoodsInfoDef_h */
