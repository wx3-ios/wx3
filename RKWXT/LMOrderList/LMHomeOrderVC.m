//
//  LMHomeOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMHomeOrderVC.h"
#import "LMOrderCommonDef.h"
#import "DLTabedSlideView.h"

@interface LMHomeOrderVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}
@end

@implementation LMHomeOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我的订单"];
    
    tabedSlideView = [[DLTabedSlideView alloc] init];
    tabedSlideView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [tabedSlideView setDelegate:self];
    
    [tabedSlideView setBaseViewController:self];
    [tabedSlideView setTabItemNormalColor:WXColorWithInteger(0x646464)];
    [tabedSlideView setTabItemSelectedColor:WXColorWithInteger(0xdd2726)];
    [tabedSlideView setTabbarTrackColor:[UIColor redColor]];
    [tabedSlideView setTabbarBottomSpacing:3.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"待付款" image:nil selectedImage:nil];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"待收货" image:nil selectedImage:nil];
    DLTabedbarItem *item4 = [DLTabedbarItem itemWithTitle:@"待评论" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2,item3,item4]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(jumpToLMGoodsInfoVC:) name:K_Notification_Name_JumpToLMGoodsInfo object:nil];
    [notificationCenter addObserver:self selector:@selector(jumpToPayVC:) name:K_Notification_Name_JumpToPay object:nil];
    [notificationCenter addObserver:self selector:@selector(jumpToEvaluate:) name:K_Notification_Name_JumpToEvaluate object:nil];
    [notificationCenter addObserver:self selector:@selector(jumpToShopInfo:) name:K_Notification_Name_JumpToShopInfo object:nil];
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case LMOrderList_All:
        {
            LMAllOrderListVC *listAll = [[LMAllOrderListVC alloc] init];
            return listAll;
        }
            break;
        case LMOrderList_Wait_Pay:
        {
            LMWaitPayOrderVC *payList = [[LMWaitPayOrderVC alloc] init];
            return payList;
        }
            break;
        case LMOrderList_Wait_Receive:
        {
            LMWaitReceiveOrderVC *receiveList = [[LMWaitReceiveOrderVC alloc] init];
            return receiveList;
        }
            break;
        case LMOrderList_Wait_Evaluate:
        {
            LMWaitEvaluteOrderVC *evaluateList = [[LMWaitEvaluteOrderVC alloc] init];
            return evaluateList;
        }
            break;
        default:
            break;
    }
    return nil;
}

//跳转到商家联盟订单详情页面
-(void)jumpToLMGoodsInfoVC:(NSNotification*)notification{
    LMOrderListEntity *entity = notification.object;
    LMOrderInfoVC *orderInfoVC = [[LMOrderInfoVC alloc] init];
    orderInfoVC.orderEntity = entity;
    [self.wxNavigationController pushViewController:orderInfoVC];
}

//跳转到商家联盟订单支付页面
-(void)jumpToPayVC:(NSNotification*)notification{
    LMOrderListEntity *entity = notification.object;
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.orderpay_type = OrderPay_Type_ShopUnion;
    payVC.payMoney = entity.orderMoney+entity.carriageMoney;
    payVC.orderID = [NSString stringWithFormat:@"%ld",(long)entity.orderId];
    [self.wxNavigationController pushViewController:payVC];
}

//跳转到订单评价页面
-(void)jumpToEvaluate:(NSNotification*)notification{
    LMOrderListEntity *entity = notification.object;
    LMOrderEvaluteVC *evaluateVC = [[LMOrderEvaluteVC alloc] init];
    evaluateVC.orderEntity = entity;
    [self.wxNavigationController pushViewController:evaluateVC];
}

//跳转到关于店铺页面
-(void)jumpToShopInfo:(NSNotification*)notification{
    LMOrderListEntity *entity = notification.object;
    [[CoordinateController sharedCoordinateController] toLMShopInfoVC:self shopID:entity.shopID animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
