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

#define size self.bounds.size

enum{
    OrderPay_Section_Money = 0,
    OrderPay_Section_Alipay,
    OrderPay_Section_Wechat,
    
    OrderPay_Section_Invalid
};

@interface OrderPayVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation OrderPayVC

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
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(alipaySucceed) name:D_Notification_Name_AliPaySucceed object:nil];
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
        case OrderPay_Section_Wechat:
            height = OrderWechatCellHeight;
            break;
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
        case OrderPay_Section_Wechat:
            cell = [self tableViewForWechatCell];
            break;
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
            
        default:
            break;
    }
}

#pragma mark alipay
-(void)alipay{
    [[AliPayControl sharedAliPayOBJ] alipayOrderID:@"123456100" title:@"我信云科技" amount:0.01 phpURL:@"" payTag:nil];
}

-(void)alipaySucceed{
}

@end
