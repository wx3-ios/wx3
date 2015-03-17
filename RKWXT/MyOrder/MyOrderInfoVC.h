//
//  MyOrderInfoVC.h
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "WXUIViewController.h"
#import "OrderListEntity.h"

#define OrderInfoUseRPSucceed @"OrderInfoUseRPSucceed"
#define OrderUseRpMoney @"OrderUseRpMoney"

@interface MyOrderInfoVC : WXUIViewController
@property (nonatomic,retain) OrderListEntity *orderEntity;

@end
