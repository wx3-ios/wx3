//
//  LMMakeOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderVC.h"
#import "LMMakeOrderDef.h"

@interface LMMakeOrderVC()<UITableViewDataSource,UITableViewDelegate,LMMakeOrderUserMsgCellDelegate>{
    UITableView *_tableView;
    WXUILabel *moneyLabel;
}
@end

@implementation LMMakeOrderVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"确认订单"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self createDownView]];
}

-(WXUIView*)createDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    downView.frame = CGRectMake(0, Size.height-DownviewHeight, Size.width, DownviewHeight);
    [downView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat xOffset = 10;
    CGFloat textLabelWidth = 50;
    CGFloat textLabelHeight = 25;
    WXUILabel *textlabel = [[WXUILabel alloc] init];
    textlabel.frame = CGRectMake(xOffset, (DownviewHeight-textLabelHeight)/2, textLabelWidth, textLabelHeight);
    [textlabel setBackgroundColor:[UIColor clearColor]];
    [textlabel setText:@"实付款"];
    [textlabel setTextAlignment:NSTextAlignmentLeft];
    [textlabel setTextColor:WXColorWithInteger(0x42433e)];
    [textlabel setFont:WXFont(15.0)];
    [downView addSubview:textlabel];
    
    xOffset += textLabelWidth;
    moneyLabel = [[WXUILabel alloc] init];
    moneyLabel.frame = CGRectMake(xOffset, (DownviewHeight-textLabelHeight)/2, 150, textLabelHeight);
    [moneyLabel setBackgroundColor:[UIColor clearColor]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [moneyLabel setFont:WXFont(20.0)];
    [downView addSubview:moneyLabel];
    
    CGFloat btnWidth = 110;
    WXUIButton *submitBrn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBrn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth, 0, btnWidth, DownviewHeight);
    [submitBrn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [submitBrn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBrn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBrn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:submitBrn];
    
    return downView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return LMMakeOrder_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat row = 0;
    if(section == LMMakeOrder_Section_GoodsList){
        row = 2;
    }else{
        row = 1;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case LMMakeOrder_Section_UserAddress:
            height = LMMakeOrderUserInfoCellHeight;
            break;
        case LMMakeOrder_Section_ShopName:
            height = LMMakeOrderShopNameCellHeight;
            break;
        case LMMakeOrder_Section_GoodsList:
            height = LMMakeOrderGoodsListCellHeight;
            break;
        case LMMakeOrder_Section_PayType:
            height = LMMakeOrderPayTypeCellHeight;
            break;
        case LMMakeOrder_Section_UserMessage:
            height = LMMakeOrderUserMsgCellHeight;
            break;
        case LMMakeOrder_Section_GoodsMoney:
            height = LMMakeOrderGoodsMoneyCellHeight;
            break;
        default:
            break;
    }
    return height;
}

//个人信息
-(WXUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    LMMakeOrderUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMakeOrderUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//店铺
-(WXUITableViewCell*)tabelViewForShopNameCell{
    static NSString *identifier = @"shopNameCell";
    LMMakeOrderShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMakeOrderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)tableViewForGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    LMMakeOrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LMMakeOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setCellInfo:[_goodsList objectAtIndex:row]];
    [cell load];
    return cell;
}

//支付方式
-(WXUITableViewCell*)tableViewForPayStatusCell{
    static NSString *identifier = @"payCell";
    LMMakeOrderPayTypeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMakeOrderPayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//用户留言
-(WXUITableViewCell *)tableViewForUserMessageTextFieldCell{
    static NSString *identififer = @"userMsgCell";
    LMMakeOrderUserMsgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identififer];
    if(!cell){
        cell = [[LMMakeOrderUserMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identififer];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//商品价格
-(WXUITableViewCell*)tableViewForGoodsMoneyInfoAtRow:(NSInteger)row{
    static NSString *identifier = @"allMoneyCell";
    LMMakeOrderGoodsMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMakeOrderGoodsMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setCarriageMoney:carriageModel.carriageMoney];
//    [cell setCellInfo:_goodsList];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case LMMakeOrder_Section_UserAddress:
            cell = [self tableViewForUserInfoCell];
            break;
        case LMMakeOrder_Section_ShopName:
            cell = [self tabelViewForShopNameCell];
            break;
        case LMMakeOrder_Section_GoodsList:
            cell = [self tableViewForGoodsListCellAtRow:row];
            break;
        case LMMakeOrder_Section_PayType:
            cell = [self tableViewForPayStatusCell];
            break;
        case LMMakeOrder_Section_UserMessage:
            cell = [self tableViewForUserMessageTextFieldCell];
            break;
        case LMMakeOrder_Section_GoodsMoney:
            cell = [self tableViewForGoodsMoneyInfoAtRow:row];
            break;
        default:
            break;
    }
    return cell;
}

-(void)submitOrder{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

@end
