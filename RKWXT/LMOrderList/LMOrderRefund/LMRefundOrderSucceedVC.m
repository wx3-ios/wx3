//
//  LMRefundOrderSucceedVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMRefundOrderSucceedVC.h"
#import "LMOrderListEntity.h"
#import "RefundStateModel.h"
#import "RefundStateEntity.h"
#import "LMApplyRefundGoodsCell.h"
#import "LMApplyRefundStateCell.h"

enum{
    RefundSucceed_Section_Title = 0,
    RefundSucceed_Section_GoodsList,
    RefundSucceed_Section_Consult,
    RefundSucceed_Section_Name,
    RefundSucceed_Section_Phone,
    RefundSucceed_Section_Address,
    
    RefundSucceed_Section_Invalid,
};

@interface LMRefundOrderSucceedVC ()<UITableViewDataSource,UITableViewDelegate,SearchRefundStateDelegate>{
    UITableView *_tableView;
    NSArray *infoArr;
    NSMutableArray *_baseArr;
    LMOrderListEntity *orderEntity;
    RefundStateModel *_model;
}

@end

@implementation LMRefundOrderSucceedVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[RefundStateModel alloc] init];
        [_model setDelegate:self];
        _baseArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setCSTTitle:@"退款申请成功"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    orderEntity = _entity;
    [_model loadRefundInfoWith:orderEntity.orderGoodsID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
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
    return RefundSucceed_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case RefundSucceed_Section_Address:
        case RefundSucceed_Section_Name:
        case RefundSucceed_Section_Consult:
        case RefundSucceed_Section_Phone:
        case RefundSucceed_Section_Title:
        case RefundSucceed_Section_GoodsList:
            number = 1;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case RefundSucceed_Section_Title:
            height = 35;
            break;
        case RefundSucceed_Section_Consult:
            height = LMApplyRefundStateCellHeight;
            break;
        case RefundSucceed_Section_GoodsList:
            height = LMApplyRefundGoodsCellHeight;
            break;
        case RefundSucceed_Section_Name:
        case RefundSucceed_Section_Phone:
        case RefundSucceed_Section_Address:
            height = 45;
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section == RefundSucceed_Section_Name){
        height = 5.0;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:@"我们已经收到您的退款申请，请将商品寄到以下地址"];
    [cell.textLabel setFont:WXFont(12.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    return cell;
}

-(WXUITableViewCell *)tableViewForInfoCell:(NSInteger)section{
    static NSString *identifier = @"infoCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_baseArr count] > 0){
        [cell.textLabel setText:[_baseArr objectAtIndex:section-3]];
    }
    [cell.textLabel setFont:WXFont(15.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    [cell.textLabel setNumberOfLines:0];
    return cell;
}

-(WXUITableViewCell*)tableViewForConsultCell{
    static NSString *identifier = @"consultCell";
    LMApplyRefundStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMApplyRefundStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:_entity];
    [cell load];
    return cell;
}


-(WXUITableViewCell*)tableViewForGoodsListCell{
    static NSString *identifier = @"goodsListCell";
    LMApplyRefundGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMApplyRefundGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:orderEntity];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    WXUITableViewCell *cell = nil;
    switch (section) {
        case RefundSucceed_Section_Title:
            cell = [self tableViewForTitleCell];
            break;
        case RefundSucceed_Section_Name:
        case RefundSucceed_Section_Phone:
        case RefundSucceed_Section_Address:
            cell = [self tableViewForInfoCell:section];
            break;
        case RefundSucceed_Section_GoodsList:
            cell = [self tableViewForGoodsListCell];
            break;
        case RefundSucceed_Section_Consult:
            cell = [self tableViewForConsultCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark delegate
-(void)loadRefundStateSucceed{
    [self unShowWaitView];
    if([_model.refundStateArr count] == 0){
        return;
    }
    RefundStateEntity *ent = [_model.refundStateArr objectAtIndex:0];
    for(int i = 0; i < 3; i++){
        NSString *str = nil;
        switch (i) {
            case 0:
                str = [NSString stringWithFormat:@"收货人:%@",ent.name];
                break;
            case 1:
                str = [NSString stringWithFormat:@"联系电话:%@",ent.phone];
                break;
            case 2:
                str = [NSString stringWithFormat:@"退货地址:%@",ent.address];
                break;
            default:
                break;
        }
        [_baseArr addObject:str];
    }
    [_tableView reloadData];
}

-(void)loadRefundStateFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取信息失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
