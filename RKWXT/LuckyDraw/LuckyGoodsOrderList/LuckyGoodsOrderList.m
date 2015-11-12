//
//  LuckyGoodsOrderList.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderList.h"
#import "LuckyGoodsOrderListCell.h"
#import "LuckyOrderListModel.h"
#import "LuckyGoodsOrderInfoVC.h"
#import "OrderListTableView.h"
#import "AliPayControl.h"
#import "LuckyOrderEntity.h"

#define Size self.bounds.size
#define EveryTimeLoadDataNumber 5

typedef enum{
    E_CellRefreshing_Nothing = 0,
    E_CellRefreshing_UnderWay,
    E_CellRefreshing_Finish,
    
    E_CellRefreshing_Invalid,
}E_CellRefreshing;

@interface LuckyGoodsOrderList ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    OrderListTableView *_tableView;
    NSArray *orderListArr;
    
    NSInteger orderlistCount;
    NSInteger orderID;
}
@property (nonatomic,assign) E_CellRefreshing e_cellRefreshing;
@end

@implementation LuckyGoodsOrderList

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS1];
    if(_tableView){
        orderListArr = [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"奖品订单"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    _tableView = [[OrderListTableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setPullingDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
    [[LuckyOrderListModel shareLuckyOrderList] setType:LuckyOrder_Type_Normal];
    [[LuckyOrderListModel shareLuckyOrderList] loadLuckyOrderListWithStrat:0 withLength:EveryTimeLoadDataNumber];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadLuckyOrderListSucceed) name:D_Notification_Name_LuckyOrderList_LoadSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadLuckyOrderListFailed:) name:D_Notification_Name_LuckyOrderList_LoadFailed object:nil];
}

-(void)addOBS1{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(paySucceed) name:D_Notification_Name_AliPaySucceed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:D_Notification_Name_LuckyOrderList_LoadSucceed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:D_Notification_Name_LuckyOrderList_LoadFailed object:nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LuckyGoodsOrderListCellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [orderListArr count];
}

-(WXUITableViewCell *)tableViewForLuckyGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"luckyOrderListCell";
    LuckyGoodsOrderListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:orderListArr[row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForLuckyGoodsListCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    LuckyOrderEntity *en = [orderListArr objectAtIndex:row];
    orderID = en.order_id;
    
    LuckyGoodsOrderInfoVC *vc = [[LuckyGoodsOrderInfoVC alloc] init];
    vc.luckyEntity = en;
    [self.wxNavigationController pushViewController:vc];
}

#pragma mark luckyModelDelegate
-(void)loadLuckyOrderListSucceed{
    [self unShowWaitView];
    if(orderlistCount == [[LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr count] && self.e_cellRefreshing != E_CellRefreshing_Finish){
        _tableView.reachedTheEnd = YES;
    }
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    orderListArr = [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr;
    orderlistCount = [orderListArr count];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadLuckyOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"获取订单列表失败";
    }
    if([errorMsg isEqualToString:@"没有您要查询的数据"]){
        _tableView.reachedTheEnd = YES;
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark pay
-(void)paySucceed{
    for(LuckyOrderEntity *enti in [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr){
        if(enti.order_id == orderID){
            enti.pay_status = LuckyOrder_Pay_Done;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self indexPathWithLuckyOrderEntity:enti] inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath ,nil] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }
}

-(NSInteger)indexPathWithLuckyOrderEntity:(LuckyOrderEntity*)luckyEnt{
    orderListArr = [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr;
    NSInteger index = 0;
    if (luckyEnt){
        index = [orderListArr indexOfObject:luckyEnt];
    }
    return index;
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
        [[LuckyOrderListModel shareLuckyOrderList] setType:LuckyOrder_Type_Refresh];
        [[LuckyOrderListModel shareLuckyOrderList] loadLuckyOrderListWithStrat:0 withLength:[orderListArr count]];
    }else{
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [[LuckyOrderListModel shareLuckyOrderList] setType:LuckyOrder_Type_Loading];
        [[LuckyOrderListModel shareLuckyOrderList] loadLuckyOrderListWithStrat:[orderListArr count] withLength:EveryTimeLoadDataNumber];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
    [self addOBS1];
}

@end
