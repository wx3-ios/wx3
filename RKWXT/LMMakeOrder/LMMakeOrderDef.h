//
//  LMMakeOrderDef.h
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#ifndef LMMakeOrderDef_h
#define LMMakeOrderDef_h

#define Size self.bounds.size
#define DownviewHeight (44)

#define LMMakeOrderUserInfoCellHeight   (100)
#define LMMakeOrderShopNameCellHeight   (45)
#define LMMakeOrderGoodsListCellHeight  (95)
#define LMMakeOrderPayTypeCellHeight    (44)
#define LMMakeOrderUserMsgCellHeight    (44)
#define LMMakeOrderGoodsMoneyCellHeight (54)

enum{
    LMMakeOrder_Section_UserAddress = 0,
    LMMakeOrder_Section_ShopName,
    LMMakeOrder_Section_GoodsList,
    LMMakeOrder_Section_PayType,
    LMMakeOrder_Section_UserMessage,
    LMMakeOrder_Section_GoodsMoney,
    
    LMMakeOrder_Section_Invalid,
};

#import "LMMakeOrderGoodsCell.h"
#import "LMMakeOrderGoodsMoneyCell.h"
#import "LMMakeOrderPayTypeCell.h"
#import "LMMakeOrderShopCell.h"
#import "LMMakeOrderUserInfoCell.h"
#import "LMMakeOrderUserMsgCell.h"

#import "LMGoodsInfoEntity.h"

#import "OrderPayVC.h"
#import "ManagerAddressVC.h"
//邮费
#import "SearchCarriageMoney.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"


#endif /* LMMakeOrderDef_h */
