//
//  GoodsInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/7/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "GoodsInfoVC.h"
#import "OrderListEntity.h"
#import "OrderGoodsInfoDef.h"
#import "CallBackVC.h"

@interface GoodsInfoVC()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UITableView *_tableView;
    OrderListEntity *entity;
    
    NSString *shopPhone;
}
@end

@implementation GoodsInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    entity = _goodsEntity;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableViewForFootView]];
}

-(UIView*)tableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, 1, self.bounds.size.width, 0.3);
    [line setBackgroundColor:[UIColor grayColor]];
    [footView addSubview:line];
    
    CGFloat xOffset = 10;
    CGFloat yOffset = 6;
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 25;
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(self.bounds.size.width-xOffset-btnWidth, yOffset, btnWidth, btnHeight);
    [phoneBtn setBackgroundColor:[UIColor whiteColor]];
    [phoneBtn setBorderRadian:2.0 width:0.4 color:[UIColor grayColor]];
    [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [phoneBtn.titleLabel setFont:WXFont(13.0)];
    [phoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:phoneBtn];
    
    yOffset += btnHeight;
    CGFloat labelWidth = self.bounds.size.width/2;
    CGFloat labelHeight = 15;
    UILabel *numberlabel = [[UILabel alloc] init];
    numberlabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [numberlabel setBackgroundColor:[UIColor clearColor]];
    [numberlabel setText:[NSString stringWithFormat:@"订单号: %ld",(long)entity.order_id]];
    [numberlabel setTextAlignment:NSTextAlignmentLeft];
    [numberlabel setFont:WXFont(11.0)];
    [numberlabel setTextColor:[UIColor grayColor]];
    [footView addSubview:numberlabel];
    
    yOffset += labelHeight+3;
    footView.frame = CGRectMake(0, 0, self.bounds.size.width, yOffset);
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return OrderGoodsInfo_Section_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section > OrderGoodsInfo_Section_OrderState){
        height = 9;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case OrderGoodsInfo_Section_OrderState:
        case OrderGoodsInfo_Section_UserInfo:
        case OrderGoodsInfo_Section_Company:
            row = 1;
            break;
        case OrderGoodsInfo_Section_GoodsList:
            row = [entity.goodsArr count];
            break;
        case OrderGoodsInfo_Section_Consult:
            row = GoodsInfo_Row_Invalid;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case OrderGoodsInfo_Section_OrderState:
            height = OrderInfoStateCellHeight;
            break;
        case OrderGoodsInfo_Section_UserInfo:
            height = [OrderInfoUserInfoCell cellHeightOfInfo:entity];
            break;
        case OrderGoodsInfo_Section_Company:
            height = OrderInfoCompanyCellHeight;
            break;
        case OrderGoodsInfo_Section_GoodsList:
            height = OrderInfoGoodsListCellHeight;
            break;
        case OrderGoodsInfo_Section_Consult:
            height = OrderInfoConsultCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//订单状态
-(WXTUITableViewCell*)tableViewForOrderStateCell{
    static NSString *identifier = @"stateCell";
    OrderInfoStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//收货人信息
-(WXTUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    OrderInfoUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//公司显示
-(WXTUITableViewCell*)tableViewForCompanyCell{
    static NSString *identifier = @"companyCell";
    OrderInfoCompanyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//商品列表
-(WXTUITableViewCell*)tableViewForGoodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"GoodsListCell";
    OrderInfoGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *ent = [entity.goodsArr objectAtIndex:row];
    [cell setCellInfo:ent];
    [cell load];
    return cell;
}

//商品总额
-(WXTUITableViewCell*)tableViewForConsultCell:(NSInteger)row{
    static NSString *identifier = @"GoodsListCell";
    OrderInfoConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//订单实付金额
-(WXTUITableViewCell*)tableViewForFactMoneyCell:(NSInteger)row{
    static NSString *identifier = @"GoodsFactMoneyCell";
    OrderInfoFactMOneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderInfoFactMOneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case OrderGoodsInfo_Section_OrderState:
            cell = [self tableViewForOrderStateCell];
            break;
        case OrderGoodsInfo_Section_UserInfo:
            cell = [self tableViewForUserInfoCell];
            break;
        case OrderGoodsInfo_Section_Company:
            cell = [self tableViewForCompanyCell];
            break;
        case OrderGoodsInfo_Section_GoodsList:
            cell = [self tableViewForGoodsInfoCell:row];
            break;
        case OrderGoodsInfo_Section_Consult:
        {
            if(row == GoodsInfo_Row_MoneyInfo){
                cell = [self tableViewForConsultCell:row];
            }else{
                cell = [self tableViewForFactMoneyCell:row];
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
        case OrderGoodsInfo_Section_Company:
        {
            [[CoordinateController sharedCoordinateController] toAboutShopVC:self animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)showAlertView:(NSString*)phone{
    NSString *title = [NSString stringWithFormat:@"联系商家:%@",phone];
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
    if(shopPhone.length == 0){
        return;
    }
    if(buttonIndex == 1){
        [UtilTool callBySystemAPI:shopPhone];
        return;
    }
    if(buttonIndex == 0){
        CallBackVC *backVC = [[CallBackVC alloc] init];
        backVC.phoneName = kMerchantName;
        if([backVC callPhone:shopPhone]){
            [self presentViewController:backVC animated:YES completion:^{
            }];
        }
    }
}

-(void)callPhone{
    NSString *phoneStr = [self phoneWithoutNumber:entity.shopPhone];
    shopPhone = phoneStr;
    [self showAlertView:shopPhone];
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

@end
