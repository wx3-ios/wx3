//
//  MakeOrderDef.h
//  RKWXT
//
//  Created by SHB on 15/6/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_MakeOrderDef_h
#define RKWXT_MakeOrderDef_h

#define Order_Section_Height_UserInfo  (100)
#define Order_Section_Height_ShopName  (45)
#define Order_Section_Height_GoodsList (95)
#define Order_Section_Height_PayStatus (44)
#define Order_Section_Height_UserMesg  (50)
#define Order_Section_Height_UseBonus  (44)
#define Order_Section_Height_BonusInfo (54)
#define Order_Section_Height_MoneyInfo (100)  //余额支付
#define Order_Section_Height_GoodsMoney (60)

enum{
    Order_Section_UserInfo = 0,
    Order_Section_ShopName,
    Order_Section_GoodsList,
    Order_Section_PayStatus,
    Order_Section_UserMessage,
    Order_Section_UseBonus,
//    Order_Section_UserBalance,//余额支付
    Order_Section_GoodsMoney,
    
    Order_Section_Invalid
};

#import "MakeOrderUserInfoCell.h"
#import "MakeOrderShopCell.h"
#import "MakeOrderGoodsListCell.h"
#import "MakeOrderPayStatusCell.h"
#import "MakeOrderUserMsgTextFieldCell.h"
#import "MakeOrderUseBonusCell.h"
#import "MakeOrderSwitchCell.h"
#import "MakeOrderGoodsMoneyCell.h"
#import "MakeOrderAllGoodsMoneyCell.h"
#import "MakeOrderUserBalanceCell.h"
#import "MakeOrderBananceSwitchCell.h"

#import "ShopActivityEntity.h"

#import "ManagerAddressVC.h"

#endif
