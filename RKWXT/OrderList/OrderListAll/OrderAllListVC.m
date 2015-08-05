//
//  OrderAllListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderAllListVC.h"
#import "OrderAllListDef.h"
#import "OrderListModel.h"
#import "OrderListEntity.h"
#import "OrderListTableView.h"
#import "OrderPayVC.h"
#import "AliPayControl.h"
#import "OrderCommonDef.h"

#define GetOrderArrayEveryTime (5)

typedef enum{
    E_CellRefreshing_Nothing = 0,
    E_CellRefreshing_UnderWay,
    E_CellRefreshing_Finish,
    
    E_CellRefreshing_Invalid,
}E_CellRefreshing;

@interface OrderAllListVC()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,OrderUserHandleDelegate,OrderGoodsDelegate>{
    OrderListTableView *_tableView;
    NSArray *orderListArr;  // 商品
    
    NSInteger orderlistCount;
    
    UIView *_shell;
}
@property (nonatomic,assign) E_CellRefreshing e_cellRefreshing;
@end

@implementation OrderAllListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    if(_tableView && [orderListArr count] > 0){
        [[OrderListModel shareOrderListModel] setOrderlist_type:OrderList_Type_Refresh];
        [[OrderListModel shareOrderListModel] loadUserOrderList:0 to:[orderListArr count]];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    CGSize size = self.bounds.size;
    _tableView = [[OrderListTableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setPullingDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if (isIOS7 || isIOS8) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//        [_tableView setSeparatorColor:WXColorWithInteger(0xEBEBEB)];
    }
    
    [[OrderListModel shareOrderListModel] setOrderlist_type:OrderList_Type_Normal];
    [[OrderListModel shareOrderListModel] loadUserOrderList:0 to:GetOrderArrayEveryTime];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(payOrderListSucceed) name:D_Notification_Name_AliPaySucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadOrderListSucceed) name:K_Notification_UserOderList_LoadSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadOrderListFailed:) name:K_Notification_UserOderList_LoadFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(cancelOrderListSucceed:) name:K_Notification_UserOderList_CancelSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(cancelOrderListFailed:) name:K_Notification_UserOderList_CancelFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(completeOrderListSucceed:) name:K_Notification_UserOderList_CompleteSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(completeOrderListFailed:) name:K_Notification_UserOderList_CompleteFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(applyRefundSucceed:) name:K_Notification_HomeOrder_RefundSucceed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadEmptyOrderListView{
    _shell = [[UIView alloc] init];
    [_shell setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yOffset = 10;
    UIImage *img = [UIImage imageNamed:@"NoOrderImg.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((self.bounds.size.width-img.size.width)/2, yOffset, img.size.width, img.size.height);
    [imgView setImage:img];
    [_shell addSubview:imgView];
    
    yOffset += img.size.height+18;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, yOffset, self.bounds.size.width, 20);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"您还没有相关订单"];
    [label setTextColor:WXColorWithInteger(0x000000)];
    [label setFont:WXFont(15.0)];
    [_shell addSubview:label];
    
    yOffset += 30;
    [_shell setHidden:YES];
    [_shell setFrame:CGRectMake(0, 110, IPHONE_SCREEN_WIDTH, 100)];
    [self addSubview:_shell];
    
    if([orderListArr count] == 0){
        [_tableView setHidden:YES];
        [_shell setHidden:NO];
    }else{
        [_tableView setHidden:NO];
        [_shell setHidden:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [orderListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    OrderListEntity *entity = [orderListArr objectAtIndex:section];
    return Order_Show_Invalid+[entity.goodsArr count]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section > 0){
        height = 15;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(row == Order_Show_Shop){
        height = OrderShopCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = OrderHandleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-2){
        height = OrderConsultCellHeight;
    }
    if(row > Order_Show_Shop && row < [self numberOfRowInSection:section]-2){
        height = OrderGoodsCellHeight;
    }
    
    return height;
}

//商品所在的店铺
-(WXTUITableViewCell*)tableViewForShopCell:(NSInteger)section{
    static NSString *identifier = @"shopCell";
    OrderShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    OrderListEntity *entity = [orderListArr objectAtIndex:section];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//商品列表
-(WXTUITableViewCell*)tableViewForGoodsInfoCell:(NSInteger)row atSection:(NSInteger)section{
    static NSString *identifier = @"GoodsListCell";
    OrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *entity = [orderListArr objectAtIndex:section];
    OrderListEntity *ent = [entity.goodsArr objectAtIndex:row-1];
    [cell setCellInfo:ent];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//价格统计
-(WXTUITableViewCell*)tableViewForGoodsConsultCellAtRow:(NSInteger)row atSection:(NSInteger)section{
    static NSString *identifier = @"consultCell";
    OrderConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *entity = [orderListArr objectAtIndex:section];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//用户操作
-(WXTUITableViewCell*)tableViewForUserHandleCell:(NSInteger)section{
    static NSString *identifier = @"userHandleCell";
    OrderUserHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderUserHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *entity = [orderListArr objectAtIndex:section];
    [cell setCellInfo:entity];
    [cell setDelegate:self];
    [cell load];
    return cell;
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_Shop){
        cell = [self tableViewForShopCell:section];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self tableViewForUserHandleCell:section];
    }
    if(row == [self numberOfRowInSection:section]-2){
        cell = [self tableViewForGoodsConsultCellAtRow:row atSection:section];
    }
    if(row > Order_Show_Shop && row < [self numberOfRowInSection:section]-2){
        cell = [self tableViewForGoodsInfoCell:row atSection:section];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    OrderListEntity *infoEntity = [orderListArr objectAtIndex:section];
    if(row == Order_Show_Shop){
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_OrderInfo object:infoEntity];
    }
}

-(NSInteger)indexPathOfOptCellWithOrder:(OrderListEntity*)orderEntity{
    orderListArr = [OrderListModel shareOrderListModel].orderListAll;
    NSInteger index = 0;
    if (orderEntity){
        index = [orderListArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark loadOrderlist
-(void)loadOrderListSucceed{
    [self unShowWaitView];
    if(orderlistCount == [[OrderListModel shareOrderListModel].orderListAll count] && self.e_cellRefreshing != E_CellRefreshing_Finish){
        _tableView.reachedTheEnd = YES;
    }
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    orderListArr = [OrderListModel shareOrderListModel].orderListAll;
    orderlistCount = [orderListArr count];
    [self loadEmptyOrderListView];
    [_tableView reloadData];
}

-(void)loadOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"获取订单失败";
    }
    [UtilTool showAlertView:message];
//    if([orderListArr count] == [[OrderListModel shareOrderListModel].orderListAll count] && self.e_cellRefreshing != E_CellRefreshing_Finish){
//        _tableView.reachedTheEnd = YES;
//    }
}

#pragma mark cancelOrderList
-(void)cancelOrderListSucceed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *orderID = notification.object;
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == [orderID integerValue]){
            entity.order_status = Order_Status_Cancel;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(void)cancelOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"取消订单失败";
    }
    [UtilTool showAlertView:message];
}

#pragma mark completeOrderList
-(void)completeOrderListSucceed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *orderID = notification.object;
    orderListArr = [OrderListModel shareOrderListModel].orderListAll;
    for(OrderListEntity *entity in orderListArr){
        if(entity.order_id == [orderID integerValue]){
            entity.order_status = Order_Status_None;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(void)completeOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"确认订单失败";
    }
    [UtilTool showAlertView:message];
}

#pragma mark paySucceed
-(void)payOrderListSucceed{
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == [[OrderListModel shareOrderListModel].orderID integerValue]){
            entity.pay_status = Pay_Status_HasPay;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

#pragma mark userHandleDelegate
//支付
-(void)userPayBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [OrderListModel shareOrderListModel].orderID = [NSString stringWithFormat:@"%ld",(long)entity.order_id];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToPay object:entity];
}
//取消订单
-(void)userCancelBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [[OrderListModel shareOrderListModel] dealUserOrderListWithType:DealOrderList_Type_Cancel with:[NSString stringWithFormat:@"%ld",(long)entity.order_id]];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}
//确认订单
-(void)userCompleteBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [[OrderListModel shareOrderListModel] dealUserOrderListWithType:DealOrderList_Type_Complete with:[NSString stringWithFormat:@"%ld",(long)entity.order_id]];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}
//催单
-(void)userHurryBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_CallShopPhone object:entity.shopPhone];
}
//退款
-(void)userRefundBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToRefund object:entity];
}

//申请退款成功
-(void)applyRefundSucceed:(NSNotification*)notification{
    OrderListEntity *ent = notification.object;
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == ent.order_id){
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index>=0){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

//单品状态
-(void)toOrderRefundSucceed:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToRefundSucceed object:entity];
}
//商品详情
-(void)toGoodsInfoWithGoodsID:(NSInteger)goodsID{
    if(goodsID<=0){
        return;
    }
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)goodsID];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToGoodsInfo object:goodsIDStr];
}

#pragma mark pullingDelegate
-(void)pullingTableViewDidStartRefreshing:(OrderListTableView *)tableView{
    self.e_cellRefreshing = E_CellRefreshing_UnderWay;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(NSDate*)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [UtilTool getCurDateTime:1];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

-(void)pullingTableViewDidStartLoading:(OrderListTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadData{
    if(self.e_cellRefreshing == E_CellRefreshing_UnderWay){
        self.e_cellRefreshing = E_CellRefreshing_Finish;
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [_tableView tableViewDidFinishedLoadingWithMessage:@"刷新完成"];
        [[OrderListModel shareOrderListModel] setOrderlist_type:OrderList_Type_Refresh];
        [[OrderListModel shareOrderListModel] loadUserOrderList:0 to:[orderListArr count]];
    }else{
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [[OrderListModel shareOrderListModel] setOrderlist_type:OrderList_Type_Loading];
        [[OrderListModel shareOrderListModel] loadUserOrderList:[orderListArr count] to:GetOrderArrayEveryTime];
    }
    if(!_tableView.reachedTheEnd){
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd = NO;
    }
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CancelSucceed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CancelFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CompleteFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Notification_UserOderList_CompleteSucceed object:nil];
}

@end
