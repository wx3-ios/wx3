//
//  OrderAllListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderAllListVC.h"
#import "OrderAllListDef.h"

@interface OrderAllListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSInteger number;
}
@end

@implementation OrderAllListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    number = 1;
    [self loadEmptyOrderListView];
}

-(void)loadEmptyOrderListView{
    if(number != 0){
        return;
    }
    [_tableView setHidden:YES];
    
    CGFloat yOffset = 120;
    UIImage *img = [UIImage imageNamed:@"NoOrderImg.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((self.bounds.size.width-img.size.width)/2, yOffset, img.size.width, img.size.height);
    [imgView setImage:img];
    [self addSubview:imgView];
    
    yOffset += img.size.height+18;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, yOffset, self.bounds.size.width, 20);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"您还没有相关订单"];
    [label setTextColor:WXColorWithInteger(0x000000)];
    [label setFont:WXFont(18.0)];
    [self addSubview:label];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Order_Show_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger row = indexPath.row;
    switch (row) {
        case Order_Show_Shop:
            height = OrderShopCellHeight;
            break;
        case Order_Show_Goods:
            height = OrderGoodsCellHeight;
            break;
        case Order_Show_Consult:
            height = OrderConsultCellHeight;
            break;
        case Order_Shop_UserHandle:
            height = OrderHandleCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//商品所在的店铺
-(WXTUITableViewCell*)tableViewForShopCell{
    static NSString *identifier = @"shopCell";
    OrderShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//商品列表
-(WXTUITableViewCell*)tableViewForGoodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"shopCell";
    OrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//价格统计
-(WXTUITableViewCell*)tableViewForGoodsConsultCell{
    static NSString *identifier = @"consultCell";
    OrderConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//用户操作
-(WXTUITableViewCell*)tableViewForUserHandleCell{
    static NSString *identifier = @"userHandleCell";
    OrderUserHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderUserHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case Order_Show_Shop:
            cell = [self tableViewForShopCell];
            break;
        case Order_Show_Goods:
            cell = [self tableViewForGoodsInfoCell:row];
            break;
        case Order_Show_Consult:
            cell = [self tableViewForGoodsConsultCell];
            break;
        case Order_Shop_UserHandle:
            cell = [self tableViewForUserHandleCell];
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
