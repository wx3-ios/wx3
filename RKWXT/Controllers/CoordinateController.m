//
//  CoordinateController.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CoordinateController.h"
#import "SignViewController.h"
#import "NewGoodsInfoVC.h"
#import "UserBonusVC.h"
#import "MakeOrderVC.h"
#import "OrderPayVC.h"
//#import "RechargeVC.h"
#import "RechargeTypeVC.h"
#import "HomeOrderVC.h"
#import "OrderListEntity.h"
#import "OrderDealRefundVC.h"
#import "RefundSucceedVC.h"
#import "GoodsInfoVC.h"
#import "AboutShopVC.h"
#import "JPushMessageCenterVC.h"
#import "JPushMessageInfoVC.h"
#import "FindCommonVC.h"
#import "LuckyGoodsOrderList.h"
@implementation CoordinateController

+ (CoordinateController*)sharedCoordinateController{
    static dispatch_once_t onceToken;
    static CoordinateController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoordinateController alloc] init];
    });
    return sharedInstance;
}

+ (WXUINavigationController*)sharedNavigationController{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    WXUINavigationController *navigationController = appDelegate.navigationController;
    return navigationController;
}

-(void)toGuideView:(id)sender animated:(BOOL)animated{
    
}

-(void)toSignVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    SignViewController *signVC = [[SignViewController alloc] init];
    [vc.wxNavigationController pushViewController:signVC];
}

-(void)toRechargeVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    RechargeTypeVC *rechargeVC = [[RechargeTypeVC alloc] init];
    [vc.wxNavigationController pushViewController:rechargeVC];
}

-(void)toOrderList:(id)sender selectedShow:(NSInteger)number animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    HomeOrderVC *orderListVC = [[HomeOrderVC alloc] init];
    orderListVC.selectedNum = number;
    [vc.wxNavigationController pushViewController:orderListVC];
}

-(void)toLuckyOrderList:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    LuckyGoodsOrderList *orderListVC = [[LuckyGoodsOrderList alloc] init];
    [vc.wxNavigationController pushViewController:orderListVC];
}

-(void)toGoodsInfoVC:(id)sender goodsID:(NSInteger)goodsID animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    NewGoodsInfoVC *orderListVC = [[NewGoodsInfoVC alloc] init];
    orderListVC.goodsId = goodsID;
    [vc.wxNavigationController pushViewController:orderListVC];
}

-(void)toUserBonusVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    UserBonusVC *bonusVC = [[UserBonusVC alloc] init];
    [vc.wxNavigationController pushViewController:bonusVC];
}

-(void)toMakeOrderVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    MakeOrderVC *orderVC = [[MakeOrderVC alloc] init];
    orderVC.goodsList = orderInfo;
    [vc.wxNavigationController pushViewController:orderVC];
}

-(void)toOrderPayVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
    OrderListEntity *entity = orderInfo;
    WXUIViewController *vc = sender;
    NSInteger number = 0;
    CGFloat price = 0;
    for(OrderListEntity *ent in entity.goodsArr){
        number += ent.sales_num;
        price += ent.factPayMoney;
    }
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.orderID = [NSString stringWithFormat:@"%ld",(long)entity.order_id];
    payVC.payMoney = price;
    payVC.orderpay_type = OrderPay_Type_Order;
    [vc.wxNavigationController pushViewController:payVC];
}

-(void)toRefundVC:(id)sender goodsInfo:(id)goodsInfo animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    OrderDealRefundVC *refundVC = [[OrderDealRefundVC alloc] init];
    refundVC.entity = goodsInfo;
    [vc.wxNavigationController pushViewController:refundVC];
}

-(void)toRefundInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    RefundSucceedVC *refundInfoVC = [[RefundSucceedVC alloc] init];
    refundInfoVC.entity = orderEntity;
    [vc.wxNavigationController pushViewController:refundInfoVC];
}

-(void)toOrderInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    GoodsInfoVC *goodsInfoVC = [[GoodsInfoVC alloc] init];
    goodsInfoVC.goodsEntity = orderEntity;
    [vc.wxNavigationController pushViewController:goodsInfoVC];
}

-(void)toAboutShopVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    AboutShopVC *shopVC = [[AboutShopVC alloc] init];
    [vc.wxNavigationController pushViewController:shopVC];
}

-(void)toJPushCenterVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    JPushMessageCenterVC *centerVC = [[JPushMessageCenterVC alloc] init];
    [vc.wxNavigationController pushViewController:centerVC];
}

-(void)toJPushMessageInfoVC:(id)sender messageID:(NSInteger)messageID animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    JPushMessageInfoVC *infoVC = [[JPushMessageInfoVC alloc] init];
    infoVC.messageID = messageID;
    [vc.wxNavigationController pushViewController:infoVC];
}

-(void)toWebVC:(id)sender url:(NSString *)webUrl title:(NSString *)title animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    FindCommonVC *webVC = [[FindCommonVC alloc] init];
    webVC.webURl = webUrl;
    webVC.titleName = title;
    [vc.wxNavigationController pushViewController:webVC];
}

@end
