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
#import "LuckyOrderNumberCell.h"
#import "LuckyOrderEntity.h"
#import "AboutShopVC.h"
#import "CallBackVC.h"
#import "OrderPayVC.h"
#import "NewGoodsInfoVC.h"
#import "LuckyOrderListModel.h"
#import "LuckyGoodsInfoModel.h"

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

@interface LuckyGoodsOrderInfoVC ()<UITableViewDataSource,UITableViewDelegate,LuckyOrderContactSellerCellDelegate,UIActionSheetDelegate,LuckyGoodsInfoModelDelegate>{
    UITableView *_tableView;
    LuckyOrderEntity *entity;
    NSString *shopPhone;
    
    LuckyGoodsInfoModel *_model;
}

@end

@implementation LuckyGoodsOrderInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    entity = _luckyEntity;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame= CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _model = [[LuckyGoodsInfoModel alloc] init];
    [_model setDelegate:self];
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
            height = [LuckyOrderUserInfoCell cellHeightOfInfo:entity.address];
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
        case LuckyGoodsOrderInfo_Section_OrderNumber:
            height = LuckyOrderNumberCellHeight;
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
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
    [cell setCellInfo:entity];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//物流
-(WXUITableViewCell*)tableViewForOrderSendCell{
    static NSString *identifier = @"OrderSendCell";
    LuckyOrderNumberCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyOrderNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
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
        case LuckyGoodsOrderInfo_Section_OrderNumber:
            cell = [self tableViewForOrderSendCell];
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
        case LuckyGoodsOrderInfo_Section_Company:
        {
            AboutShopVC *vc = [[AboutShopVC alloc] init];
            vc.shopID = 100000;
            [self.wxNavigationController pushViewController:vc];
        }
            break;
        case LuckyGoodsOrderInfo_Section_GoodsList:
        {
            NewGoodsInfoVC *vc = [[NewGoodsInfoVC alloc] init];
            vc.goodsInfo_type = GoodsInfo_LuckyGoods;
            vc.goodsId = entity.goods_id;
            [self.wxNavigationController pushViewController:vc];
        }
            break;
        default:
            break;
    }
}

#pragma mark cellDelegate
-(void)luckyOrderCompleteBtnClicked{
    [_model completeLuckyOrderWith:entity.order_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)completeLuckyOrderSucceed{
    [self unShowWaitView];
    [_tableView reloadData];
}

-(void)completeLuckyOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"确认收货失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)luckyOrderPayBtnClicked{
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.orderpay_type = OrderPay_Type_Lucky;
    payVC.payMoney = entity.goods_price;
    payVC.orderID = [NSString stringWithFormat:@"%ld",(long)entity.order_id];
    [self.wxNavigationController pushViewController:payVC];
}

#pragma mark call
-(void)luckyOrderLeftBtnClicked{
    [self showAlertView];
}

-(void)showAlertView{
    NSString *phoneStr = [self phoneWithoutNumber:entity.sellerPhone];
    shopPhone = phoneStr;
    if(!phoneStr){
        [UtilTool showAlertView:@"号码不存在"];
        return;
    }
    NSString *title = [NSString stringWithFormat:@"联系客服:%@",phoneStr];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:kMerchantName
                                  otherButtonTitles:@"系统", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex > 2){
        return;
    }
    if(buttonIndex == 1){
        [UtilTool callBySystemAPI:shopPhone];
        return;
    }
    if(buttonIndex == 0){
        CallBackVC *backVC = [[CallBackVC alloc] init];
        backVC.phoneName = @"我信云客服";
        if([backVC callPhone:shopPhone]){
            [self presentViewController:backVC animated:YES completion:^{
            }];
        }
    }
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
