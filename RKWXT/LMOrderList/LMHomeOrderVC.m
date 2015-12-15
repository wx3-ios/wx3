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
//            WaitSendGoodsListVC *sendList = [[WaitSendGoodsListVC alloc] init];
//            return sendList;
        }
            break;
        case LMOrderList_Wait_Evaluate:
        {
//            WaitReceiveOrderListVC *receiveList = [[WaitReceiveOrderListVC alloc] init];
//            return receiveList;
        }
            break;
        default:
            break;
    }
    return nil;
}

@end
