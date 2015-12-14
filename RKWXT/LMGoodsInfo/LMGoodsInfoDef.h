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

#define LMGoodsInfoTitleHeaderViewHeight (45)
#define LMGoodsOtherHeaderViewHeight (36)

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

#import "NewImageZoomView.h"

#endif /* LMGoodsInfoDef_h */
