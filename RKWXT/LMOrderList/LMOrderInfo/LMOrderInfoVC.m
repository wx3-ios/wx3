//
//  LMOrderInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoVC.h"
#import "LMOrderInfoOrderStateCell.h"
#import "LMOrderInfoUserAddressCell.h"
#import "LMOrderInfoShopCell.h"
#import "LMOrderInfoGoodsListCell.h"
#import "LMOrderInfoMoneyCell.h"
#import "LMOrderInfoContactShopCell.h"
#import "LMOrderInfoOrderTimeCell.h"
#import "LMOrderListEntity.h"
#import "LMRefundOrderVC.h"
#import "LMRefundOrderSucceedVC.h"
#import "CallBackVC.h"
#import "LMShopInfoVC.h"

#define Size self.bounds.size

enum{
    LMOrderInfo_Section_OrderState = 0,
    LMOrderInfo_Section_UserAddress,
    LMOrderInfo_Section_ShopName,
    LMOrderInfo_Section_GoodsList,
    LMOrderInfo_Section_GoodsMoney,
    LMOrderInfo_Section_ContactShop,
    LMOrderInfo_Section_OrderTime,
    
    LMOrderInfo_Section_Invalid,
};

@interface LMOrderInfoVC()<UITableViewDataSource,UITableViewDelegate,LMOrderInfoContactShopCellDelegate,LMOrderInfoGoodsListCellDelegate,UIActionSheetDelegate>{
    UITableView *_tableView;
    LMOrderListEntity *entity;
    NSString *shopPhone;
}
@end

@implementation LMOrderInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    entity = _orderEntity;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
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
    return LMOrderInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if(section == LMOrderInfo_Section_GoodsList){
        row = [entity.goodsListArr count];
    }else{
        row = 1;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case LMOrderInfo_Section_OrderState:
            height = LMOrderInfoOrderStateCellHeight;
            break;
        case LMOrderInfo_Section_UserAddress:
            height = [LMOrderInfoUserAddressCell cellHeightOfInfo:entity];
            break;
        case LMOrderInfo_Section_ShopName:
            height = LMOrderInfoShopCellHeight;
            break;
        case LMOrderInfo_Section_GoodsList:
            height = LMOrderInfoGoodsListCellHeight;
            break;
        case LMOrderInfo_Section_GoodsMoney:
            height = LMOrderInfoMoneyCellHeight;
            break;
        case LMOrderInfo_Section_ContactShop:
            height = LMOrderInfoContactShopCellHeight;
            break;
        case LMOrderInfo_Section_OrderTime:
            height = LMOrderInfoOrderTimeCellHieght;
            break;
        default:
            break;
    }
    return height;
}

//订单状态
-(WXUITableViewCell*)orderStateCell{
    static NSString *identifier = @"stateCell";
    LMOrderInfoOrderStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoOrderStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//收货人信息
-(WXUITableViewCell*)userInfoCell{
    static NSString *identifier = @"userInfoCell";
    LMOrderInfoUserAddressCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoUserAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//店铺名称
-(WXUITableViewCell*)shopNameCell{
    static NSString *identifier = @"shopNameCell";
    LMOrderInfoShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)goodsListCell:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    LMOrderInfoGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[entity.goodsListArr objectAtIndex:row]];
    [cell setDelgate:self];
    [cell load];
    return cell;
}

//商品价格
-(WXUITableViewCell*)orderMoneyCell{
    static NSString *identifier = @"orderMoneyCell";
    LMOrderInfoMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

//联系卖家
-(WXUITableViewCell*)contactShopCell{
    static NSString *identifier =  @"contactShopCell";
    LMOrderInfoContactShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoContactShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//订单信息
-(WXUITableViewCell*)orderInfoCell{
    static NSString *identifier = @"orderInfoCell";
    LMOrderInfoOrderTimeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMOrderInfoOrderTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case LMOrderInfo_Section_OrderState:
            cell = [self orderStateCell];
            break;
        case LMOrderInfo_Section_UserAddress:
            cell = [self userInfoCell];
            break;
        case LMOrderInfo_Section_ShopName:
            cell = [self shopNameCell];
            break;
        case LMOrderInfo_Section_GoodsList:
            cell = [self goodsListCell:row];
            break;
        case LMOrderInfo_Section_GoodsMoney:
            cell = [self orderMoneyCell];
            break;
        case LMOrderInfo_Section_ContactShop:
            cell = [self contactShopCell];
            break;
        case LMOrderInfo_Section_OrderTime:
            cell = [self orderInfoCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == LMOrderInfo_Section_ShopName){
        [[CoordinateController sharedCoordinateController] toLMShopInfoVC:self shopID:entity.shopID animated:YES];
    }
    if(section == LMOrderInfo_Section_GoodsList){
        LMOrderListEntity *ent = [entity.goodsListArr objectAtIndex:row];
        [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:ent.goodsID animated:YES];
    }
}

#pragma mark contactShop
-(void)userRefundBtnClicked{
    LMRefundOrderVC *refundVC = [[LMRefundOrderVC alloc] init];
    refundVC.entity = entity;
    [self.wxNavigationController pushViewController:refundVC];
}

-(void)refundBtnClicked:(id)sender{
    LMRefundOrderSucceedVC *refundSucceedVC = [[LMRefundOrderSucceedVC alloc] init];
    refundSucceedVC.entity = sender;
    [self.wxNavigationController pushViewController:refundSucceedVC];
}

-(void)contactSellerWith:(NSString *)phone{
    NSString *phoneStr = [self phoneWithoutNumber:entity.shopPhone];
    shopPhone = phoneStr;
    [self showAlertView:shopPhone];
}

-(void)showAlertView:(NSString*)phone{
    NSString *title = [NSString stringWithFormat:@"联系商家:%@",phone];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:[NSString stringWithFormat:@"使用%@",kMerchantName]
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
