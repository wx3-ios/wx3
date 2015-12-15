//
//  LMAllOrderListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMAllOrderListVC.h"
#import "LMAllOrderListShopCell.h"
#import "LMAllOrderGoodsListCell.h"
#import "LMAllOrderUserHandleCell.h"
#import "MJRefresh.h"

//测试
#import "OrderListEntity.h"

enum{
    Order_Show_Shop = 0,
    Order_Show_Goods,
    Order_Shop_UserHandle,
    
    Order_Show_Invalid
};

@interface LMAllOrderListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *orderListArr;
}
@end

@implementation LMAllOrderListVC

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
    
    [self setupRefresh];
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
    return 5.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_Shop){
        height = LMAllOrderListShopCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = LMAllOrderUserHandleCellHeight;
    }
    if(row > Order_Show_Shop && row < [self numberOfRowInSection:section]-1){
        height = LMAllOrderGoodsListCellHeight;
    }
    return height;
}

//店铺名称
-(WXUITableViewCell*)orderShopCell{
    static NSString *identifier = @"shopCell";
    LMAllOrderListShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMAllOrderListShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)orderGoodsListCell:(NSInteger)row{
    static NSString *identfier = @"goodsListCell";
    LMAllOrderGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMAllOrderGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell load];
    return cell;
}

//用户操作
-(WXUITableViewCell*)userHandleCell{
    static NSString *identifier = @"handleCell";
    LMAllOrderUserHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMAllOrderUserHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_Shop){
        cell = [self orderShopCell];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self userHandleCell];
    }
    if(row > Order_Show_Shop && row < [self numberOfRowInSection:section]-1){
        cell = [self orderGoodsListCell:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark mjRefresh
-(void)headerRefreshing{
    
}

-(void)footerRefreshing{
    
}

@end
