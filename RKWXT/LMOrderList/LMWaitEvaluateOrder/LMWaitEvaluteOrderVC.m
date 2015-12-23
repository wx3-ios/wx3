//
//  LMWaitEvaluteOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMWaitEvaluteOrderVC.h"
#import "LMWaitEvaluteOrderGoodsCell.h"
#import "LMWaitEvaluteOrderShopCell.h"
#import "LMWaitEvaluteUserHandleCell.h"
#import "LMOrderListModel.h"
#import "LMOrderListEntity.h"
#import "MJRefresh.h"
#import "LMOrderCommonDef.h"

#define EveryTimeLoad (20)

enum{
    Order_Show_Shop = 0,
    Order_Show_Goods,
    Order_Shop_UserHandle,
    
    Order_Show_Invalid
};

@interface LMWaitEvaluteOrderVC()<UITableViewDataSource,UITableViewDelegate,LMOrderListModelDelegate,LMWaitEvaluteUserHandleCellDelegate>{
    UITableView *_tableView;
    NSMutableArray *orderListArr;
    BOOL isRefresh;
    LMOrderListModel *_model;
    
    NSInteger orderID;
}
@end

@implementation LMWaitEvaluteOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRefresh];
    [self addOBS];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMOrderListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(userEvaluateOrderSucceed:) name:K_Notification_Name_UserEvaluateOrderSucceed object:nil];
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [orderListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    LMOrderListEntity *entity = [orderListArr objectAtIndex:section];
    return Order_Show_Invalid+[entity.goodsListArr count]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_Shop){
        height = LMWaitEvaluteOrderShopCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = LMWaitEvaluteUserHandleCellHeight;
    }
    if(row > Order_Show_Shop && row < [self numberOfRowInSection:section]-1){
        height = LMWaitEvaluteOrderGoodsCellHeight;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

//店铺名称
-(WXUITableViewCell*)orderShopCell:(NSInteger)section{
    static NSString *identifier = @"shopCell";
    LMWaitEvaluteOrderShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMWaitEvaluteOrderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)orderGoodsListCell:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identfier = @"goodsListCell";
    LMWaitEvaluteOrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMWaitEvaluteOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    if([orderListArr count] > 0){
        LMOrderListEntity *entity = [orderListArr objectAtIndex:section];
        [cell setCellInfo:[entity.goodsListArr objectAtIndex:row-1]];
    }
    [cell load];
    return cell;
}

//用户操作
-(WXUITableViewCell*)userHandleCell:(NSInteger)section{
    static NSString *identifier = @"handleCell";
    LMWaitEvaluteUserHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMWaitEvaluteUserHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_Shop){
        cell = [self orderShopCell:row];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self userHandleCell:section];
    }
    if(row > Order_Show_Shop && row < [self numberOfRowInSection:section]-1){
        cell = [self orderGoodsListCell:section atRow:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_Shop){
        return;
    }
    LMOrderListEntity *entity = [orderListArr objectAtIndex:section];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToLMGoodsInfo object:entity];
}

-(NSInteger)indexPathOfOptCellWithOrder:(LMOrderListEntity*)orderEntity{
    [orderListArr removeAllObjects];
    for(LMOrderListEntity *entity in _model.orderList){
        if(entity.payType == LMorder_PayType_WaitPay && entity.orderState == LMorder_State_Normal){
            [orderListArr addObject:entity];
        }
    }
    NSInteger index = 100000;
    if (orderEntity && [orderListArr count] > 0){
        index = [orderListArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark mjRefresh
-(void)headerRefreshing{
    isRefresh = YES;
    if([orderListArr count] == 0){
        [_model loadLMOrderList:0 andLength:EveryTimeLoad type:LMOrderList_Type_WaitEvaluate];
    }else{
        [_model loadLMOrderList:0 andLength:[orderListArr count] type:LMOrderList_Type_WaitEvaluate];
    }
}

-(void)footerRefreshing{
    isRefresh = NO;
    [_model loadLMOrderList:[orderListArr count] andLength:EveryTimeLoad type:LMOrderList_Type_WaitPay];
}

-(void)loadLMOrderlistSucceed{
    orderListArr = [NSMutableArray arrayWithArray:_model.orderList];
    [_tableView reloadData];
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
}

-(void)loadLMOrderlistFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }
    if(!isRefresh){
        [_tableView footerEndRefreshing];
    }
}

#pragma mark userhandle
-(void)userEvaluateOrder:(id)sender{
    LMOrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToEvaluate object:entity];
}

-(void)userEvaluateOrderSucceed:(NSNotification*)notification{
    LMOrderListEntity *entity = notification.object;
    for(LMOrderListEntity *ent in orderListArr){
        if(entity.orderId == ent.orderId){
            entity.evaluate = LMOrder_Evaluate_Done;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<10000){
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [_tableView reloadData];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
