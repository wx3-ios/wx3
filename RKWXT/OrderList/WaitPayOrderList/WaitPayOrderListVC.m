//
//  WaitPayOrderListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitPayOrderListVC.h"
#import "WaitPayOrderListDef.h"

@interface WaitPayOrderListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation WaitPayOrderListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return OrderList_WaitPay_Invalid;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case OrderList_WaitPay_Title:
            height = OrderListWaitPayTitleCellHeight;
            break;
        case OrderList_WaitPay_GoodsInfo:
            height = OrderWaitPayGoodsInfoCellHeight;
            break;
        case OrderList_WaitPay_Consult:
            height = OrderWaitPayConsultCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//title
-(WXUITableViewCell*)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setText:@"等待付款"];
    [cell.textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [cell.textLabel setFont:WXFont(12.0)];
    return cell;
}

//商品
-(WXUITableViewCell*)tabelViewForGoodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"goodInfoCell";
    OrderWaitPayGoodsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderWaitPayGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//统计
-(WXUITableViewCell*)tabelViewForConsultCell{
    static NSString *identifier = @"goodInfoCell";
    OrderWaitPayConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderWaitPayConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case OrderList_WaitPay_Title:
            cell = [self tableViewForTitleCell];
            break;
        case OrderList_WaitPay_GoodsInfo:
            cell = [self tabelViewForGoodsInfoCell:row];
            break;
        case OrderList_WaitPay_Consult:
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
