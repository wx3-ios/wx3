//
//  WaitPayOrderListDef.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_WaitPayOrderListDef_h
#define RKWXT_WaitPayOrderListDef_h

enum{
    OrderList_WaitPay_Title = 0,
    OrderList_WaitPay_GoodsInfo,
    OrderList_WaitPay_Consult,
    
    OrderList_WaitPay_Invalid
};

#define OrderListWaitPayTitleCellHeight (42)

#import "OrderWaitPayGoodsInfoCell.h"
#import "OrderWaitPayConsultCell.h"

#endif
