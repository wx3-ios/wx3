//
//  HomeOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomeOrderVC.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"
#import "OrderListEntity.h"

#import "OrderListDef.h"
#import "CallBackVC.h"

@interface HomeOrderVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}
@end

@implementation HomeOrderVC

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
//    [tabedSlideView setTabbarBackgroundImage:[UIImage imageNamed:@""]];
    [tabedSlideView setTabbarBottomSpacing:3.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"待付款" image:nil selectedImage:nil];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"待发货" image:nil selectedImage:nil];
    DLTabedbarItem *item4 = [DLTabedbarItem itemWithTitle:@"待收货" image:nil selectedImage:nil];
    DLTabedbarItem *item5 = [DLTabedbarItem itemWithTitle:@"待评价" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2,item3,item4,item5]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
}

-(void)addOBS{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(toPay:) name:K_Notification_HomeOrder_ToPay object:nil];
    [notification addObserver:self selector:@selector(toRefund:) name:K_Notification_HomeOrder_ToRefund object:nil];
    [notification addObserver:self selector:@selector(callShopPhoneWithTelePhoneNumber:) name:K_Notification_HomeOrder_CallShopPhone object:nil];
    [notification addObserver:self selector:@selector(toOrderInfoVC:) name:K_Notification_HomeOrder_OrderInfo object:nil];
    [notification addObserver:self selector:@selector(toRefundSucceedVC:) name:K_Notification_HomeOrder_ToRefundSucceed object:nil];
    [notification addObserver:self selector:@selector(toGoodsInfoVC:) name:K_Notification_HomeOrder_ToGoodsInfo object:nil];
    [notification addObserver:self selector:@selector(toEvaluateVC:) name:K_Notification_Name_JumpToEvaluate object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)toPay:(NSNotification*)notification{
    OrderListEntity *entity = notification.object;
    [[CoordinateController sharedCoordinateController] toOrderPayVC:self orderInfo:entity animated:YES];
}

-(void)toRefund:(NSNotification*)notification{
    OrderListEntity *entity = notification.object;
    [[CoordinateController sharedCoordinateController] toRefundVC:self goodsInfo:entity animated:YES];
}

-(void)toOrderInfoVC:(NSNotification*)notification{
    OrderListEntity *entity = notification.object;
    [[CoordinateController sharedCoordinateController] toOrderInfoVC:self orderEntity:entity animated:YES];
}

-(void)toRefundSucceedVC:(NSNotification*)notification{
    OrderListEntity *entity = notification.object;
    [[CoordinateController sharedCoordinateController] toRefundInfoVC:self orderEntity:entity animated:YES];
}

-(void)toGoodsInfoVC:(NSNotification*)notification{
    NSInteger goodsID = [notification.object integerValue];
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:goodsID animated:YES];
}

-(void)toEvaluateVC:(NSNotification*)notification{
    OrderListEntity *entity = notification.object;
    OrderEvaluateVC *evaluateVC = [[OrderEvaluateVC alloc] init];
    evaluateVC.orderEntity = entity;
    [self.wxNavigationController pushViewController:evaluateVC completion:^{
    }];
}

-(void)callShopPhoneWithTelePhoneNumber:(NSNotification*)notification{
    NSString *phone = notification.object;
    if(phone.length == 0){
        [UtilTool showAlertView:@"号码不正确"];
        return;
    }
    NSString *phoneStr = [self phoneWithoutNumber:phone];
    if(phoneStr.length == 0){
        [UtilTool showAlertView:@"号码不正确"];
        return;
    }
    CallBackVC *backVC = [[CallBackVC alloc] init];
    backVC.phoneName = phoneStr;
    if([backVC callPhone:phoneStr]){
        [self presentViewController:backVC animated:YES completion:^{
        }];
    }
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case OrderList_All:
        {
            OrderAllListVC *listAll = [[OrderAllListVC alloc] init];
            return listAll;
        }
            break;
        case OrderList_Wait_Pay:
        {
            WaitPayOrderListVC *payList = [[WaitPayOrderListVC alloc] init];
            return payList;
        }
            break;
        case OrderList_Wait_Send:
        {
            WaitSendGoodsListVC *sendList = [[WaitSendGoodsListVC alloc] init];
            return sendList;
        }
            break;
        case OrderList_Wait_Receive:
        {
            WaitReceiveOrderListVC *receiveList = [[WaitReceiveOrderListVC alloc] init];
            return receiveList;
        }
            break;
        case OrderList_Wait_Evaluate:
        {
            WaitEvaluateOrderListVC *evaluateVC = [[WaitEvaluateOrderListVC alloc] init];
            return evaluateVC;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
