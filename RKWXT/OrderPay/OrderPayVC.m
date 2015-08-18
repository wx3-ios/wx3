//
//  OrderPayVC.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderPayVC.h"
#import "OrderAlipayCell.h"
#import "OrderWechatCell.h"
#import "OrderPayMoneyCell.h"
#import "AliPayControl.h"
#import "PaySucceedModel.h"
#import "WechatPayObj.h"
#import "WechatPayModel.h"
#import "WechatEntity.h"
#import "LuckyGoodsOrderList.h"

#define size self.bounds.size

enum{
    OrderPay_Section_Money = 0,
    OrderPay_Section_Alipay,
//    OrderPay_Section_Wechat,
    
    OrderPay_Section_Invalid
};

@interface OrderPayVC()<UITableViewDataSource,UITableViewDelegate,WechatPayModelDelegate>{
    UITableView *_tableView;
    WechatPayModel *_model;
}
@end

@implementation OrderPayVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[WechatPayModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"收银台"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(alipaySucceed) name:D_Notification_Name_AliPaySucceed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return OrderPay_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case OrderPay_Section_Money:
            height = OrderPayMoneyCellHeight;
            break;
        case OrderPay_Section_Alipay:
            height = OrderAlipayCellHeight;
            break;
//        case OrderPay_Section_Wechat:
//            height = OrderWechatCellHeight;
//            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell*)tableViewForPayMoneyCell{
    static NSString *identifier = @"payMoneyCell";
    OrderPayMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderPayMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[NSNumber numberWithFloat:_payMoney]];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAlipayCell{
    static NSString *identifier = @"alipayCell";
    OrderAlipayCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderAlipayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForWechatCell{
    static NSString *identifier = @"wechatCell";
    OrderWechatCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderWechatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case OrderPay_Section_Money:
            cell = [self tableViewForPayMoneyCell];
            break;
        case OrderPay_Section_Alipay:
            cell = [self tableViewForAlipayCell];
            break;
//        case OrderPay_Section_Wechat:
//            cell = [self tableViewForWechatCell];
//            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case OrderPay_Section_Alipay:
            [self alipay];
            break;
//        case OrderPay_Section_Wechat:
//            [self wechatPay];
//            break;
        default:
            break;
    }
}

#pragma mark wechat
-(void)wechatPay{
    [_model wechatPayWithOrderID:_orderID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)wechatPayLoadSucceed{
    [self unShowWaitView];
    if([_model.wechatArr count] <= 0){
        return;
    }
    WechatEntity *entity = [_model.wechatArr objectAtIndex:0];
    WechatPayObj *wechatObj = [[WechatPayObj alloc] init];
    [wechatObj wechatPayWith:entity];
}

-(void)wechatPayLoadFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"调用微支付失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark alipay
-(void)alipay{
    if(!_orderID){
        return;
    }
    
    [[AliPayControl sharedAliPayOBJ] alipayOrderID:[self newChangeOrderID] title:kMerchantName amount:_payMoney phpURL:@"" payTag:nil];
}

-(void)alipaySucceed{
    [[PaySucceedModel sharePaySucceed] updataPayOrder:Pay_Type_AliPay withOrderID:[self newChangeOrderID]];
    if(_orderpay_type == OrderPay_Type_Recharge){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    if(_orderpay_type == OrderPay_Type_Lucky){
        [self toLuckyGoodsOrderList];
        return;
    }
    [self toOrderList];
}

-(void)back{
    if(_orderpay_type == OrderPay_Type_Recharge){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    if(_orderpay_type == OrderPay_Type_Lucky){
        [self toLuckyGoodsOrderList];
        return;
    }
    [self toOrderList];
}

-(void)toLuckyGoodsOrderList{
    WXUINavigationController *navigationController = [CoordinateController sharedNavigationController];
    UIViewController *orderVC = [navigationController lastViewControllerOfClass:NSClassFromString(@"LuckyGoodsOrderList")];
    if(orderVC){
        [navigationController popToViewController:orderVC animated:YES Completion:^{
        }];
    }else{
        [navigationController popToRootViewControllerAnimated:NO Completion:^{
            [[CoordinateController sharedCoordinateController] toLuckyOrderList:navigationController.rootViewController animated:YES];
        }];
    }
}

//去商城订单列表
-(void)toOrderList{
    WXUINavigationController *navigationController = [CoordinateController sharedNavigationController];
    UIViewController *orderVC = [navigationController lastViewControllerOfClass:NSClassFromString(@"HomeOrderVC")];
    if(orderVC){
        [navigationController popToViewController:orderVC animated:YES Completion:^{
        }];
    }else{
        [navigationController popToRootViewControllerAnimated:NO Completion:^{
            [[CoordinateController sharedCoordinateController] toOrderList:navigationController.rootViewController selectedShow:0 animated:YES];
        }];
    }
}

-(NSString*)newChangeOrderID{
    NSString *newStr = nil;
    switch (_orderpay_type) {
        case OrderPay_Type_Order:
            newStr = [NSString stringWithFormat:@"S%@",_orderID];
            break;
        case OrderPay_Type_Recharge:
            newStr = [NSString stringWithFormat:@"R%@",_orderID];
            break;
        case OrderPay_Type_Lucky:
            newStr = [NSString stringWithFormat:@"P%@",_orderID];
            break;
        default:
            break;
    }
    return newStr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
