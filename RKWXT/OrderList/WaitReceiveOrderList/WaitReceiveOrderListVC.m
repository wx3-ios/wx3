//
//  WaitReceiveOrderListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveOrderListVC.h"
#import "OrderListWaitReceiveDef.h"

@interface WaitReceiveOrderListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation WaitReceiveOrderListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return OrderList_WaitPay_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger row = indexPath.row;
    switch (row) {
        case OrderList_WaitReceive_Title:
            height = WaitReceiveTitleCellHeight;
            break;
        case OrderList_WaitReceive_GoodsInfo:
            height = WaitReceiveGoodsInfoCellHeight;
            break;
        case OrderList_WaitReceive_Consult:
            height = WaitReceiveConsultCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//title
-(WXUITableViewCell*)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WaitReceiveTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    return cell;
}

//商品
-(WXUITableViewCell*)tabelViewForGoodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"goodInfoCell";
    WaitReceiveGoodsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//统计
-(WXUITableViewCell*)tabelViewForConsultCell{
    static NSString *identifier = @"goodInfoCell";
    WaitReceiveConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case OrderList_WaitReceive_Title:
            cell = [self tableViewForTitleCell];
            break;
        case OrderList_WaitReceive_GoodsInfo:
            cell = [self tabelViewForGoodsInfoCell:row];
            break;
        case OrderList_WaitReceive_Consult:
            cell = [self tabelViewForConsultCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
