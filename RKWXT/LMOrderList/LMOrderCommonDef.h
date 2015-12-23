//
//  LMOrderCommonDef.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#ifndef LMOrderCommonDef_h
#define LMOrderCommonDef_h

#define K_Notification_Name_JumpToLMGoodsInfo  @"K_Notification_Name_JumpToLMGoodsInfo"
#define K_Notification_Name_JumpToPay          @"K_Notification_Name_JumpToPay"
#define K_Notification_Name_JumpToEvaluate     @"K_Notification_Name_JumpToEvaluate"
#define K_Notification_Name_RefundSucceed  @"K_Notification_Name_RefundSucceed"
#define K_Notification_Name_JumpToShopInfo @"K_Notification_Name_JumpToShopInfo"

enum{
    LMOrderList_All = 0,
    LMOrderList_Wait_Pay,
    LMOrderList_Wait_Receive,
    LMOrderList_Wait_Evaluate,
    
    LMOrderList_Invalid
};

#import "LMAllOrderListVC.h"
#import "LMWaitPayOrderVC.h"
#import "LMWaitReceiveOrderVC.h"
#import "LMWaitEvaluteOrderVC.h"

#import "LMOrderListEntity.h"

#import "LMOrderInfoVC.h"
#import "OrderPayVC.h"
#import "LMOrderEvaluteVC.h"
#import "LMShopInfoVC.h"

#endif /* LMOrderCommonDef_h */
