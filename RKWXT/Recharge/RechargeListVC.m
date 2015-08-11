//
//  RechargeListVC.m
//  RKWXT
//
//  Created by SHB on 15/8/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeListVC.h"
#import "RechargeListCell.h"
#import "OrderPayVC.h"
#import "RechargeListModel.h"

#define Size self.bounds.size

@interface RechargeListVC ()<UITableViewDataSource,UITableViewDelegate,RechargeListDelegate>{
    UITableView *_tableView;
    
    NSArray *nameArr;
    NSArray *infoArr;
    NSArray *moneyArr;
    
    NSInteger rechargeMoney;
    RechargeListModel *_model;
}

@end

@implementation RechargeListVC

-(id)init{
    self = [super init];
    if(self){
        moneyArr = @[@"10", @"30", @"50", @"100", @"300", @"500", @"1000"];
        nameArr = @[@"10元 (到账金额26元)", @"30元 (到账金额90元)", @"50元 (到账金额242元)", @"100元 (到账金额556元)", @"300元 (到账金额1950元)", @"500元 (到账金额3900元)", @"1000元 (到账金额13000元)"];
        infoArr = @[@"折后1毛5打遍全国", @"折后1毛3打遍全国", @"折后8分打遍全国", @"折后7分打遍全国", @"折后6分打遍全国", @"折后5分打遍全国", @"折后4分打遍全国"];
        NSAssert([nameArr count] == [infoArr count], @"充值标题和内容不符");
        
        _model = [[RechargeListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"充值话费"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
    return [nameArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RechargeListCellHeight;
}

-(WXUITableViewCell*)tableviewForRechargeListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"rechargeListCell";
    RechargeListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RechargeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setTitle:nameArr[row]];
    [cell setInfo:infoArr[row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableviewForRechargeListCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if(row > [moneyArr count]){
        return;
    }
    rechargeMoney = [moneyArr[row] integerValue];
    [_model rechargeListWithMoney:rechargeMoney];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

#pragma mark rechargeDelegate
-(void)rechargeListSucceed{
    [self unShowWaitView];
    if(_model.orderID && rechargeMoney > 0){
        OrderPayVC *payVC = [[OrderPayVC alloc] init];
        payVC.orderpay_type = OrderPay_Type_Recharge;
        payVC.orderID = _model.orderID;
        payVC.payMoney = rechargeMoney;
        [self.wxNavigationController pushViewController:payVC];
    }
}

-(void)rechargeListFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"充值失败";
    }
    [UtilTool showAlertView:errorMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
