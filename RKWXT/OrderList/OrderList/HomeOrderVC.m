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
    
    [tabedSlideView setTabbarItems:@[item1,item2,item3,item4]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
}

-(void)addOBS{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(toPay:) name:K_Notification_HomeOrder_ToPay object:nil];
    [notification addObserver:self selector:@selector(toRefund:) name:K_Notification_HomeOrder_ToRefund object:nil];
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
        default:
            break;
    }
    return nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
