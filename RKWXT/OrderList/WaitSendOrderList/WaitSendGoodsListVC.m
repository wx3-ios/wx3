//
//  WaitSendGoodsListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitSendGoodsListVC.h"
#import "WaitSendGoodsDef.h"
#import "OrderListModel.h"
#import "OrderListEntity.h"
#import "OrderGoodsCell.h"

@interface WaitSendGoodsListVC()<UITableViewDataSource,UITableViewDelegate,WaitSendOrderDelegate>{
    UITableView *_tableView;
    NSMutableArray *listArr;
}
@end

@implementation WaitSendGoodsListVC

-(id)init{
    self = [super init];
    if(self){
        listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [listArr removeAllObjects];
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Normal && entity.goods_status == Goods_Status_WaitSend){
            [listArr addObject:entity];
        }
    }
    if(_tableView){
        [_tableView reloadData];
    }
}

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
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    OrderListEntity *entity = [listArr objectAtIndex:section];
    return OrderList_WaitSend_Invalid+[entity.goodsArr count]-1;
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
    if(row == OrderList_WaitSend_Title){
        height = WaitSendTitleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = WaitSendConsultCellHeight;
    }
    if(row > OrderList_WaitSend_Title && row < [self numberOfRowInSection:section]-1){
        height = WaitSendGoodsInfoCellHeight;
    }
    return height;
}

//title
-(WXTUITableViewCell*)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:@"等待商家处理"];
    [cell.textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [cell.textLabel setFont:WXFont(12.0)];
    return cell;
}

//商品
-(WXTUITableViewCell*)tabelViewForGoodsInfoCell:(NSInteger)row atSection:(NSInteger)section{
    static NSString *identifier = @"sendCell";
    OrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *entity = [listArr objectAtIndex:section];
    OrderListEntity *ent = [entity.goodsArr objectAtIndex:row-1];
    [cell setCellInfo:ent];
    [cell load];
    return cell;
}

//统计
-(WXTUITableViewCell*)tabelViewForConsultCell:(NSInteger)section{
    static NSString *identifier = @"goodInfoCell";
    WaitSendConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitSendConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDelegate:self];
    OrderListEntity *entity = [listArr objectAtIndex:section];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(row == OrderList_WaitSend_Title){
        cell = [self tableViewForTitleCell];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForConsultCell:section];
    }
    if(row > OrderList_WaitSend_Title && row < [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForGoodsInfoCell:row atSection:section];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark userDeal
-(void)userClickHurryBtn:(id)sender{

}

-(void)userClickRefundBtn:(id)sender{
    
}

@end
