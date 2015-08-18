//
//  LuckyGoodsMakeOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsMakeOrderVC.h"
#import "MakeOrderDef.h"
#import "MakeOrderUserInfoCell.h"
#import "LuckyMakeOrderCompanyCell.h"
#import "LuckyGoodsMakeOrderCell.h"
#import "MakeOrderPayStatusCell.h"
#import "LuckyGoodsMakeOrderMoneyCell.h"
#import "LuckyGoodsMakeOrderDateCell.h"
#import "AboutShopVC.h"
#import "LuckyGoodsMakeOrderModel.h"
#import "OrderPayVC.h"
#import "GoodsInfoEntity.h"
#import "ManagerAddressVC.h"

#define Size self.bounds.size
#define DownViewHeight 55

enum{
    MakeOrder_Section_UserInfo = 0,
    MakeOrder_Section_Company,
    MakeOrder_Section_GoodsList,
    MakeOrder_Section_PayWay,
    MakeOrder_Section_PayMoney,
    
    MakeOrder_Section_Invalid,
};

@interface LuckyGoodsMakeOrderVC ()<UITableViewDataSource,UITableViewDelegate,LuckyGoodsMakeOrderModelDelegate>{
    UITableView *_tableView;
    LuckyGoodsMakeOrderModel *_model;
}

@end

@implementation LuckyGoodsMakeOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_tableView){
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:MakeOrder_Section_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"下单"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownViewHeight);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addSubview:[self tableViewForFootView]];
    
    _model = [[LuckyGoodsMakeOrderModel alloc] init];
    [_model setDelegate:self];
}

-(UIView*)tableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    CGFloat xOffset = 10;
    CGFloat btnWidth = 75;
    CGFloat btnHeight = 35;
    WXUIButton *payBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(Size.width-xOffset-btnWidth, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [payBtn setBorderRadian:2.0 width:0.5 color:WXColorWithInteger(0xdd2726)];
    [payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(gotoPayVC) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:payBtn];
    
    footView.frame = CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight);
    return footView;
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
    return MakeOrder_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 1;
    if(section == MakeOrder_Section_PayMoney){
        number = 2;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44;
    NSInteger section = indexPath.section;
    switch (section) {
        case MakeOrder_Section_UserInfo:
            height = Order_Section_Height_UserInfo;
            break;
        case MakeOrder_Section_Company:
            height = Order_Section_Height_ShopName;
            break;
        case MakeOrder_Section_GoodsList:
            height = Order_Section_Height_GoodsList;
            break;
        case MakeOrder_Section_PayWay:
            height = Order_Section_Height_PayStatus;
            break;
        case MakeOrder_Section_PayMoney:
            height = LuckyGoodsMakeOrderMoneyCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//个人信息
-(WXUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    MakeOrderUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//公司名称
-(WXUITableViewCell*)tableViewForCompanyCell{
    static NSString *identifier = @"companyCell";
    LuckyMakeOrderCompanyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyMakeOrderCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)tableViewForGoodsListCellAtRow{
    static NSString *identifier = @"goodsListCell";
    LuckyGoodsMakeOrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LuckyGoodsMakeOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[_goodsList objectAtIndex:0]];
    [cell load];
    return cell;
}

//支付方式
-(WXUITableViewCell*)tableViewForPayStatusCell{
    static NSString *identifier = @"payCell";
    MakeOrderPayStatusCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderPayStatusCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//总价
-(WXUITableViewCell*)tableViewForAllMoneyCell{
    static NSString *identifier = @"allMoneyCell";
    LuckyGoodsMakeOrderMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsMakeOrderMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[NSString stringWithFormat:@"%f",_payMoney]];
    [cell load];
    return cell;
}

//下单时间
-(WXUITableViewCell*)tableViewForDateCell{
    static NSString *identifier = @"dateCell";
    LuckyGoodsMakeOrderDateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsMakeOrderDateCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[NSString stringWithFormat:@"%f",_payMoney]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case MakeOrder_Section_UserInfo:
            cell = [self tableViewForUserInfoCell];
            break;
        case MakeOrder_Section_Company:
            cell = [self tableViewForCompanyCell];
            break;
        case MakeOrder_Section_GoodsList:
            cell = [self tableViewForGoodsListCellAtRow];
            break;
        case MakeOrder_Section_PayWay:
            cell = [self tableViewForPayStatusCell];
            break;
        case MakeOrder_Section_PayMoney:
        {
            if(indexPath.row == 0){
                cell = [self tableViewForAllMoneyCell];
            }else{
                cell = [self tableViewForDateCell];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case MakeOrder_Section_UserInfo:
        {
            ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
            [self.wxNavigationController pushViewController:addressVC];
        }
            break;
        case MakeOrder_Section_Company:
        {
            AboutShopVC *vc = [[AboutShopVC alloc] init];
            vc.wxID = 1000000;
            [self.wxNavigationController pushViewController:vc];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark payBtnClicked
-(void)gotoPayVC{
    if(!_goodsList){
        return;
    }
    GoodsInfoEntity *goodsEntity = [_goodsList objectAtIndex:0];
    NSInteger length = AllImgPrefixUrlString.length;
    NSString *smallImgStr = [goodsEntity.smallImg substringFromIndex:length];
    [_model luckyGoodsMakeOrderWith:_lotty_id withGoodsID:goodsEntity.goods_id withName:goodsEntity.intro withImgUrl:smallImgStr withGoodsStockID:goodsEntity.stockID withStockName:goodsEntity.stockName WithMoney:_payMoney];
}

-(void)luckyGoodsMakeOrderSucceed{
    [self unShowWaitView];
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.payMoney = _payMoney;
    payVC.orderID = _model.orderID;
    payVC.orderpay_type = OrderPay_Type_Lucky;
    [self.wxNavigationController pushViewController:payVC];
}

-(void)luckyGoodsMakeOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"下单失败";
    }
    [UtilTool showAlertView:errorMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
