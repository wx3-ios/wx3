//
//  LMShopInfoAllGoodsVC.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoAllGoodsVC.h"
#import "LMShopInfoALlGoodsListCell.h"
#import "MJRefresh.h"
#import "LMShopInfoListModel.h"

#define Size self.bounds.size
#define EveryItmeLoadData (10)

@interface LMShopInfoAllGoodsVC()<UITableViewDataSource,UITableViewDelegate,LMShopInfoListModelDelegate>{
    UITableView *_tableView;
    NSArray *goodsList;
    LMShopInfoListModel *_model;
}
@end

@implementation LMShopInfoAllGoodsVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMShopInfoListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"全部商品"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setupRefresh];
    
    [_model loadShopInfoListDataWith:LMShopInfo_DataType_AllGoods and:_sshop_id andStartItem:0 andLenth:EveryItmeLoadData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

//集成刷新控件
-(void)setupRefresh{
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [goodsList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMShopInfoALlGoodsListCellHeight;
}

-(WXUITableViewCell*)goodsListCell:(NSInteger)row{
    static NSString *identifier = @"listCell";
    LMShopInfoALlGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoALlGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([_model.data count] > 0){
        [cell setCellInfo:[_model.data objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self goodsListCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//上拉加载
-(void)footerRefreshing{
    
    [_model loadShopInfoListDataWith:LMShopInfo_DataType_AllGoods and:_sshop_id andStartItem:[goodsList count] andLenth:EveryItmeLoadData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)loadShopListDataSucced{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    goodsList = _model.data;
    [_tableView reloadData];
}

-(void)loadShopListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
