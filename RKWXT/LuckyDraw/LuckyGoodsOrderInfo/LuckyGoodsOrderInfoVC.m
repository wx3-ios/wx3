//
//  LuckyGoodsOrderInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderInfoVC.h"
#import "LuckyOrderStatusCell.h"
#import "LuckyOrderUserInfoCell.h"
#import "LuckyOrderCompanyCell.h"
#import "LuckyOrderGoodsInfoCell.h"
#import "LuckyOrderMoneyCell.h"
#import "LuckyOrderContactSellerCell.h"

#define Size self.bounds.size

enum{
    LuckyGoodsOrderInfo_Section_OrderStatus = 0,
    LuckyGoodsOrderInfo_Section_BaseInfo,
    LuckyGoodsOrderInfo_Section_Company,
    LuckyGoodsOrderInfo_Section_GoodsList,
    LuckyGoodsOrderInfo_Section_Money,
    LuckyGoodsOrderInfo_Section_ContactSeller,
    LuckyGoodsOrderInfo_Section_OrderNumber,
    
    LuckyGoodsOrderInfo_Section_Invalid,
};

@interface LuckyGoodsOrderInfoVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation LuckyGoodsOrderInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame= CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return LuckyGoodsOrderInfo_Section_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case LuckyGoodsOrderInfo_Section_OrderStatus:
            height = LuckyOrderStatusCellHeight;
            break;
        case LuckyGoodsOrderInfo_Section_BaseInfo:
            height = [LuckyOrderUserInfoCell cellHeightOfInfo:nil];
            break;
        case LuckyGoodsOrderInfo_Section_Company:
            height = LuckyOrderCompanyCellHeight;
            break;
        case LuckyGoodsOrderInfo_Section_GoodsList:
            height = LuckyOrderGoodsInfoCellHeight;
            break;
        case LuckyGoodsOrderInfo_Section_Money:
            height = LuckyOrderMoneyCellHeight;
            break;
        case LuckyGoodsOrderInfo_Section_ContactSeller:
            height = LuckyOrderContactSellerCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//订单状态
-(WXUITableViewCell*)tableViewForOrderStatusCell{
    static NSString *identifier = @"orderStatusCell";
    LuckyOrderStatusCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//订单用户基础信息
-(WXUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    LuckyOrderUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//我信科技
-(WXUITableViewCell*)tableViewForCompanyCell{
    static NSString *identifier = @"companyCell";
    LuckyOrderCompanyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//订单商品
-(WXUITableViewCell*)tableViewForLuckyOrderGoodsInfoCell{
    static NSString *identifier = @"goodsListCell";
    LuckyOrderGoodsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//订单总价
-(WXUITableViewCell*)tableViewForOrderMoneyCell{
    static NSString *identifier = @"orderMoneyCell";
    LuckyOrderMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//联系卖家
-(WXUITableViewCell*)tableViewForContactSellerCell{
    static NSString *identifier = @"contactSellerCell";
    LuckyOrderContactSellerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderContactSellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case LuckyGoodsOrderInfo_Section_OrderStatus:
            cell = [self tableViewForOrderStatusCell];
            break;
        case LuckyGoodsOrderInfo_Section_BaseInfo:
            cell = [self tableViewForUserInfoCell];
            break;
        case LuckyGoodsOrderInfo_Section_Company:
            cell = [self tableViewForCompanyCell];
            break;
        case LuckyGoodsOrderInfo_Section_GoodsList:
            cell = [self tableViewForLuckyOrderGoodsInfoCell];
            break;
        case LuckyGoodsOrderInfo_Section_Money:
            cell = [self tableViewForOrderMoneyCell];
            break;
        case LuckyGoodsOrderInfo_Section_ContactSeller:
            cell = [self tableViewForContactSellerCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
