//
//  RechargeTypeVC.m
//  RKWXT
//
//  Created by SHB on 15/8/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeTypeVC.h"
#import "RechargeTypeCell.h"
#import "RechargeVC.h"
#import "RechargeListVC.h"

enum{
    Recharge_Type_Card,
    Recharge_Type_Alipay,
    
    Recharge_Type_Invalid,
};

#define Size self.bounds.size

@interface RechargeTypeVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation RechargeTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"充值中心"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RechargeTypeCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Recharge_Type_Invalid;
}

-(WXUITableViewCell*)tableviewForRechargeTypeCellAtRow:(NSInteger)row{
    static NSString *identifier = @"rechargeTypeCell";
    RechargeTypeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RechargeTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setCellInfo:[NSString stringWithFormat:@"%ld",(long)row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableviewForRechargeTypeCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if(row == Recharge_Type_Card){
        RechargeVC *rechargeVC = [[RechargeVC alloc] init];
        [self.wxNavigationController pushViewController:rechargeVC];
    }
    if(row == Recharge_Type_Alipay){
        RechargeListVC *listVC = [[RechargeListVC alloc] init];
        [self.wxNavigationController pushViewController:listVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
