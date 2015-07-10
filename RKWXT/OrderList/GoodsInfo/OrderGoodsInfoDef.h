//
//  OrderGoodsInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/7/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_OrderGoodsInfoDef_h
#define RKWXT_OrderGoodsInfoDef_h

enum{
    OrderGoodsInfo_Section_OrderState = 0,
    OrderGoodsInfo_Section_UserInfo,
    OrderGoodsInfo_Section_Company,
    OrderGoodsInfo_Section_GoodsList,
    OrderGoodsInfo_Section_Consult,
    
    OrderGoodsInfo_Section_Invalid,
};

enum{
    GoodsInfo_Row_MoneyInfo = 0,
    GoodsInfo_Row_FactMoney,
    
    GoodsInfo_Row_Invalid,
};

#import "OrderInfoCompanyCell.h"
#import "OrderInfoStateCell.h"
#import "OrderInfoUserInfoCell.h"
#import "OrderGoodsCell.h"
#import "OrderInfoConsultCell.h"
#import "OrderInfoFactMOneyCell.h"

#endif
