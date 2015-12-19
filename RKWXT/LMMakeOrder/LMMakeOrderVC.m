//
//  LMMakeOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderVC.h"
#import "LMMakeOrderDef.h"

@interface LMMakeOrderVC()<UITableViewDataSource,UITableViewDelegate,LMMakeOrderUserMsgCellDelegate,SearchCarriageMoneyDelegate>{
    UITableView *_tableView;
    WXUILabel *moneyLabel;
    NSArray *listArr;
    SearchCarriageMoney *carriageModel;
    CGFloat goodsMoney;
}
@property (nonatomic,strong) NSString *userMessage;
@end

@implementation LMMakeOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_tableView){
        [self loadCarriageMoney];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:LMMakeOrder_Section_UserAddress] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(id)init{
    self = [super init];
    if(self){
        carriageModel = [[SearchCarriageMoney alloc] init];
        [carriageModel setDelegate:self];
    }
    return self;
}

-(void)loadCarriageMoney{
    BOOL is_postage = YES;  //默认包邮
    NSInteger provinceID = [self parseUserAddressProvinceID];
    NSString *goodsInfo = [[NSString alloc] init];
    for(LMGoodsInfoEntity *entity in listArr){
        if(goodsInfo.length > 0){
            goodsInfo = [goodsInfo stringByAppendingString:@"^"];
        }
        goodsInfo = [goodsInfo stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld",(long)entity.goodsID,(long)entity.stockNum]];
        
        if(entity.postage == LMGoods_Postage_Have){
            is_postage = NO;  //不包邮
        }
    }
    if(!is_postage){
        [carriageModel searchCarriageMoneyWithProvinceID:provinceID goodsInfo:goodsInfo];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"确认订单"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    listArr = _goodsArr;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownviewHeight);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:[self createDownView]];
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
    [textlabel setText:@"实付款:"];
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
    
    if([listArr count] > 0){
        for(LMGoodsInfoEntity *entity in listArr){
            goodsMoney += entity.stockPrice;
        }
    }
    [moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",goodsMoney]];
    
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
    return LMMakeOrder_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat row = 0;
    if(section == LMMakeOrder_Section_GoodsList){
        row = [_goodsArr count];
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

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    CGFloat height = 0;
//    switch (section) {
//        case LMMakeOrder_Section_GoodsMoney:
//            height = 10;
//            break;
//        default:
//            break;
//    }
//    return height;
//}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, Size.width, 10);
//    [view setBackgroundColor:WXColorWithInteger(0xefeff4)];
//    return view;
//}

//个人信息
-(WXUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    LMMakeOrderUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMakeOrderUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
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
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:0]];
    }
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
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
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
-(WXUITableViewCell*)tableViewForGoodsMoneyInfo{
    static NSString *identifier = @"allMoneyCell";
    LMMakeOrderGoodsMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMakeOrderGoodsMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCarriageMoney:carriageModel.carriageMoney];
    if([listArr count] > 0){
        [cell setCellInfo:listArr];
    }
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
            cell = [self tableViewForGoodsMoneyInfo];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == LMMakeOrder_Section_UserAddress){
        ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
        [self.wxNavigationController pushViewController:addressVC];
    }
}

-(void)submitOrder{
    
}

//省份ID
-(NSInteger)parseUserAddressProvinceID{
    for(AreaEntity *entity in [NewUserAddressModel shareUserAddress].userAddressArr){
        if(entity.normalID == 1){
            return entity.proID;
        }
    }
    return 0;
}

#pragma mark carriageDelegate
-(void)searchCarriageMoneySucceed{
    [self unShowWaitView];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:LMMakeOrder_Section_GoodsMoney] withRowAnimation:UITableViewRowAnimationFade];
    [moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",goodsMoney+carriageModel.carriageMoney]];
}

-(void)searchCarriageMoneyFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取运费失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark userMessageDelegate
-(void)userMessageChanged:(LMMakeOrderUserMsgCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath){
        NSInteger section = indexPath.section;
        if(section == LMMakeOrder_Section_UserMessage){
            self.userMessage = cell.textField.text;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

@end
