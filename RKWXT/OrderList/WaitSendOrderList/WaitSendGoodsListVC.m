//
//  WaitSendGoodsListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitSendGoodsListVC.h"
#import "WaitSendGoodsDef.h"

@interface WaitSendGoodsListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation WaitSendGoodsListVC

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return OrderList_WaitSend_Invalid;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case OrderList_WaitSend_Title:
            height = WaitSendTitleCellHeight;
            break;
        case OrderList_WaitSend_GoodsInfo:
            height = WaitSendGoodsInfoCellHeight;
            break;
        case OrderList_WaitSend_Consult:
            height = WaitSendConsultCellHeight;
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
    [cell.textLabel setText:@"等待商家处理"];
    [cell.textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [cell.textLabel setFont:WXFont(12.0)];
    return cell;
}

//商品
-(WXUITableViewCell*)tabelViewForGoodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"goodInfoCell";
    WaitSendGoodsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitSendGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//统计
-(WXUITableViewCell*)tabelViewForConsultCell{
    static NSString *identifier = @"goodInfoCell";
    WaitSendConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitSendConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case OrderList_WaitSend_Title:
            cell = [self tableViewForTitleCell];
            break;
        case OrderList_WaitSend_GoodsInfo:
            cell = [self tabelViewForGoodsInfoCell:row];
            break;
        case OrderList_WaitSend_Consult:
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
