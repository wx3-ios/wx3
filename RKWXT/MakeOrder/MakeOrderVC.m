//
//  MakeOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/6/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderVC.h"
#import "MakeOrderDef.h"
#import "MakeOrderModel.h"
#import "GoodsInfoEntity.h"
#import "OrderPayVC.h"
#import "ManagerAddressVC.h"
#import "UserBonusModel.h"
#import "SearchCarriageMoney.h"
//地址
#import "NewUserAddressModel.h"
#import "AreaEntity.h"

#define Size self.bounds.size
#define DownViewHeight (59)

@interface MakeOrderVC()<UITableViewDataSource,UITableViewDelegate,MakeOrderUserMsgTextFieldCellDelegate,WXUITableViewCellDelegate,MakeOrderSwitchCellDelegate,MakeOrderDelegate,SearchCarriageMoneyDelegate/*,MakeOrderBananceSwitchCellDelegate*/>{
    UITableView *_tableView;
    MakeOrderModel *_model;
    
//    BOOL userbalance;
//    NSInteger _balance;
    
    BOOL userBonus;
    NSInteger _bonus;
    
    CGFloat allGoodsMoney;
    
    SearchCarriageMoney *carriageModel;
}
@property (nonatomic,strong) NSString *userMessage;
@end

@implementation MakeOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
    if(_tableView){
        [self loadCarriageMoney];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[MakeOrderModel alloc] init];
        [_model setDelegate:self];
        
        carriageModel = [[SearchCarriageMoney alloc] init];
        [carriageModel setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"订单确认"];
    [self setBackgroundColor:[UIColor whiteColor]];
    userBonus = NO;
//    userbalance = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height-DownViewHeight) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:[self createDownView]];
    
    [self loadCarriageMoney];
    [self addNotification];
    [self censusBonusValue];
    [self censusBalanceValue];
}

-(void)loadCarriageMoney{
    BOOL is_postage = YES;  //默认包邮
    NSInteger provinceID = [self parseUserAddressProvinceID];
    NSString *goodsInfo = [[NSString alloc] init];
    for(GoodsInfoEntity *entity in _goodsList){
        if(goodsInfo.length > 0){
            goodsInfo = [goodsInfo stringByAppendingString:@"^"];
        }
        goodsInfo = [goodsInfo stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld",(long)entity.goods_id,(long)entity.buyNumber]];
        
        if(entity.postage == Goods_Postage_Have){
            is_postage = NO;  //不包邮
        }
    }
    if(!is_postage){
        [carriageModel searchCarriageMoneyWithProvinceID:provinceID goodsInfo:goodsInfo];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }
}

//可使用红包
-(void)censusBonusValue{
    for(GoodsInfoEntity *entity in _goodsList){
        _bonus += entity.stockBonus*entity.buyNumber;
    }
    if(_bonus > [UserBonusModel shareUserBonusModel].bonusMoney){
        _bonus = [UserBonusModel shareUserBonusModel].bonusMoney;
    }
}

////可使用余额
-(void)censusBalanceValue{
//    for(GoodsInfoEntity *entity in _goodsList){
//        _balance += entity.stockBonus*entity.buyNumber;
//    }
//    if(_balance > [UserBonusModel shareUserBonusModel].bonusMoney){
//        _balance = [UserBonusModel shareUserBonusModel].bonusMoney;
//    }
}

-(void)addNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(InfokeyboardWillShown:)
                         name:UIKeyboardWillShowNotification object:nil];
    [notification addObserver:self selector:@selector(InfokeyboardWillHide:)
                         name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView*)createDownView{
    UIView *downView = [[UIView alloc] init];
    [downView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat xGap = 13;
    CGFloat btnWidth = 85;
    CGFloat btnHeight = 40;
    WXUIButton *okBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(Size.width-xGap-btnWidth, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"MakeOrderBtnImg.png"] forState:UIControlStateNormal];
    [okBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:okBtn];
    
    [downView setFrame:CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight)];
    return downView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Order_Section_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section > Order_Section_PayStatus){
        height = 0.5;
    }else{
        height = 0.1;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case Order_Section_UserInfo:
            height = Order_Section_Height_UserInfo;
            break;
        case Order_Section_ShopName:
            height = Order_Section_Height_ShopName;
            break;
        case Order_Section_GoodsList:
            height = Order_Section_Height_GoodsList;
            break;
        case Order_Section_PayStatus:
            height = Order_Section_Height_PayStatus;
            break;
        case Order_Section_UserMessage:
            height = Order_Section_Height_UserMesg;
            break;
        case Order_Section_UseBonus:
        {
            if(row == 0){
                height = Order_Section_Height_UseBonus;
            }else{
                height = Order_Section_Height_BonusInfo;
            }
        }
            break;
//        case Order_Section_UserBalance:
//        {
//            if(row == 0){
//                height = Order_Section_Height_UseBonus;
//            }else{
//                height = Order_Section_Height_BonusInfo;
//            }
//        }
//            break;
        case Order_Section_GoodsMoney:
            if(row == 0){
                height = Order_Section_Height_MoneyInfo;
            }else{
                height = Order_Section_Height_GoodsMoney;
            }
            break;
        default:
            break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case Order_Section_UserInfo:
        case Order_Section_ShopName:
        case Order_Section_PayStatus:
        case Order_Section_UserMessage:
            row = 1;
            break;
        case Order_Section_UseBonus:
            row = (userBonus?2:1);
            break;
//        case Order_Section_UserBalance:
//            row = (userbalance?2:1);
//            break;
        case Order_Section_GoodsList:
            row = [_goodsList count];
            break;
        case Order_Section_GoodsMoney:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

//个人信息
-(WXUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    MakeOrderUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//店铺
-(WXUITableViewCell*)tabelViewForShopNameCell{
    static NSString *identifier = @"shopNameCell";
    MakeOrderShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)tableViewForGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    MakeOrderGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MakeOrderGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[_goodsList objectAtIndex:row]];
    [cell load];
    return cell;
}

//支付方式
-(WXUITableViewCell*)tableViewForPayStatusCell{
    static NSString *identifier = @"payCell";
    MakeOrderPayStatusCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderPayStatusCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//用户留言
-(WXUITableViewCell *)tableViewForUserMessageTextFieldCell{
    static NSString *identififer = @"userMsgCell";
    MakeOrderUserMsgTextFieldCell *cell = [_tableView dequeueReusableCellWithIdentifier:identififer];
    if(!cell){
        cell = [[MakeOrderUserMsgTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identififer];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//使用红包
-(WXUITableViewCell *)tableViewForBonusSwitchCellAtRow:(NSInteger)row{
    static NSString *identifier = @"bonusCell";
    MakeOrderSwitchCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:[NSNumber numberWithInt:(userBonus?1:0)]];
    
    [cell.textLabel setText:@"使用红包抵现"];
    [cell.textLabel setFont:WXFont(14.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x646464)];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForBonusMoneyCellAtRow:(NSInteger)row{
    static NSString *identifier = @"bonusMoneyCell";
    MakeOrderUseBonusCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderUseBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[NSString stringWithFormat:@"%ld",(long)_bonus]];
    [cell load];
    return cell;
}

////使用余额
//-(WXUITableViewCell *)tableViewForBalanceSwitchCellAtRow:(NSInteger)row{
//    static NSString *identifier = @"balanceCell";
//    MakeOrderBananceSwitchCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
//    if(!cell){
//        cell = [[MakeOrderBananceSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setDelegate:self];
//    [cell setCellInfo:[NSNumber numberWithInt:(userbalance?1:0)]];
//    
//    [cell.textLabel setText:@"使用余额抵现"];
//    [cell.textLabel setFont:WXFont(14.0)];
//    [cell.textLabel setTextColor:WXColorWithInteger(0x646464)];
//    [cell load];
//    return cell;
//}
//
//-(WXUITableViewCell*)tableViewForBalanceMoneyCellAtRow:(NSInteger)row{
//    static NSString *identifier = @"balanceMoneyCell";
//    MakeOrderUserBalanceCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
//    if(!cell){
//        cell = [[MakeOrderUserBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setCellInfo:[NSString stringWithFormat:@"%ld",(long)_balance]];
//    [cell load];
//    return cell;
//}

//商品价格
-(WXUITableViewCell*)tableViewForGoodsMoneyInfoAtRow:(NSInteger)row{
    static NSString *identifier = @"allMoneyCell";
    MakeOrderGoodsMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderGoodsMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(userBonus){
        [cell setBonusMoney:_bonus];
    }else{
        [cell setBonusMoney:0];
    }
//    if(userbalance){
//        [cell setBalance:_balance];
//    }else{
//        [cell setBalance:0];
//    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCarriageMoney:carriageModel.carriageMoney];
    [cell setCellInfo:_goodsList];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAllGoodsMoneyAtRow:(NSInteger)row{
    static NSString *identifier = @"totalMoneyCell";
    MakeOrderAllGoodsMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderAllGoodsMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(userBonus){
        [cell setBonusMoney:_bonus];
    }else{
        [cell setBonusMoney:0];
    }
//    if(userbalance){
//
//    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCarriageMoney:carriageModel.carriageMoney];
    [cell setCellInfo:_goodsList];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case Order_Section_UserInfo:
            cell = [self tableViewForUserInfoCell];
            break;
        case Order_Section_ShopName:
            cell = [self tabelViewForShopNameCell];
            break;
        case Order_Section_GoodsList:
            cell = [self tableViewForGoodsListCellAtRow:row];
            break;
        case Order_Section_PayStatus:
            cell = [self tableViewForPayStatusCell];
            break;
        case Order_Section_UserMessage:
            cell = [self tableViewForUserMessageTextFieldCell];
            break;
        case Order_Section_UseBonus:
        {
            if(userBonus){
                if(row == 0){
                    cell = [self tableViewForBonusSwitchCellAtRow:row];
                }else{
                    cell = [self tableViewForBonusMoneyCellAtRow:row];
                }
            }else{
                cell = [self tableViewForBonusSwitchCellAtRow:row];
            }
        }
            break;
//        case Order_Section_UserBalance:
//        {
//            if(userbalance){
//                if(row == 0){
//                    cell = [self tableViewForBalanceSwitchCellAtRow:row];
//                }else{
//                    cell = [self tableViewForBalanceMoneyCellAtRow:row];
//                }
//            }else{
//                cell = [self tableViewForBalanceSwitchCellAtRow:row];
//            }
//        }
//            break;
        case Order_Section_GoodsMoney:
        {
            if(row == 0){
                cell = [self tableViewForGoodsMoneyInfoAtRow:row];
            }else{
                cell = [self tableViewForAllGoodsMoneyAtRow:row];
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
        case Order_Section_UserInfo:
        {
            ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
            [self.wxNavigationController pushViewController:addressVC];
        }
            break;
            
        case Order_Section_ShopName:
        {
            [[CoordinateController sharedCoordinateController] toAboutShopVC:self animated:YES];
        }
        default:
            break;
    }
}

#pragma mark userMessageDelegate
-(void)userMessageTextFieldChanged:(MakeOrderUserMsgTextFieldCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath){
        NSInteger section = indexPath.section;
        if(section == Order_Section_UserMessage){
            self.userMessage = cell.textField.text;
        }
    }
}

-(void)InfokeyboardWillShown:(NSNotification *)notification{
    CGRect rect = CGRectMake(0, -100, self.bounds.size.width, self.bounds.size.height-DownViewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView setFrame:rect];
    } completion:^(BOOL finished) {
    }];
}

-(void)InfokeyboardWillHide:(NSNotification *)notification{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-DownViewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView setFrame:rect];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark BonusCell下拉
-(void)didSelectCellRowFirstDo:(BOOL)firstDoInsert{
    userBonus = firstDoInsert;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_UseBonus] withRowAnimation:UITableViewRowAnimationFade];
    if(userBonus){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:Order_Section_UseBonus] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

//#pragma mark BalanceCell下拉
//-(void)didSelectBalanceCellRowFirstDo:(BOOL)firstDoInsert{
//    userbalance = firstDoInsert;
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_UserBalance] withRowAnimation:UITableViewRowAnimationFade];
//    if(userbalance){
//        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:Order_Section_UserBalance] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    }
//}

#pragma mark useBonusDelegate
-(void)switchValueChanged{
    userBonus = !userBonus;
    [self didSelectCellRowFirstDo:userBonus];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_GoodsMoney] withRowAnimation:UITableViewRowAnimationFade];
}

//-(void)balanceSwitchValueChanged{
//    userbalance = !userbalance;
//    [self didSelectBalanceCellRowFirstDo:userbalance];
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_GoodsMoney] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark carriageDelegate
-(void)searchCarriageMoneySucceed{
    [self unShowWaitView];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_GoodsMoney] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)searchCarriageMoneyFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取运费失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark submit
-(void)submitOrder{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(GoodsInfoEntity *entity in _goodsList){
        NSDictionary *dic = [self goodsDicWithEntity:entity];
        [arr addObject:dic];
//        [arr addObject:dic];
    }
    [_model submitOneOrderWithAllMoney:[self allGoodsOldMoney] withTotalMoney:[self allGoodsTotalMoney] withRedPacket:(userBonus?_bonus:0) withRemark:(self.userMessage.length==0?@"无":self.userMessage) withProID:[self parseUserAddressProvinceID] withCarriage:carriageModel.carriageMoney withGoodsList:arr];
}

-(NSDictionary*)goodsDicWithEntity:(GoodsInfoEntity*)entity{
    NSString *goodsID = [NSString stringWithFormat:@"%ld",(long)entity.goods_id];
    NSString *stockID = [NSString stringWithFormat:@"%ld",(long)entity.stockID];
    NSString *stockName = [NSString stringWithFormat:@"%@",entity.stockName];
    NSString *price = [NSString stringWithFormat:@"%f",entity.stockPrice];
    NSString *number = [NSString stringWithFormat:@"%ld",(long)entity.buyNumber];
    NSInteger length = AllImgPrefixUrlString.length;
    NSString *smallImgStr = [entity.smallImg substringFromIndex:length];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:goodsID ,@"goods_id", entity.intro, @"goods_name", smallImgStr, @"goods_img", stockID, @"goods_stock_id", stockName, @"goods_stock_name", price, @"sales_price", number, @"sales_number", nil];
    return dic;
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

//订单总金额
-(CGFloat)allGoodsOldMoney{
    CGFloat price = 0.0;
    for(GoodsInfoEntity *entity in _goodsList){
        price += entity.buyNumber*entity.stockPrice;
    }
    allGoodsMoney = price;
    
    return price;
}

//订单应付金额
-(CGFloat)allGoodsTotalMoney{
    CGFloat totalMoney = [self allGoodsOldMoney];
    if(userBonus){
        totalMoney -= _bonus;
    }
    totalMoney += carriageModel.carriageMoney;
    return totalMoney;
}

-(void)makeOrderSucceed{
    [UtilTool showAlertView:@"下单成功"];
    [self unShowWaitView];
    if(allGoodsMoney == 0){
        return;
    }
    if(userBonus){
        [UserBonusModel shareUserBonusModel].bonusMoney -= _bonus;
    }
    
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.payMoney = [self allGoodsTotalMoney];
    payVC.orderID = _model.orderID;
    payVC.orderpay_type = OrderPay_Type_Order;
    [self.wxNavigationController pushViewController:payVC];
}

-(void)makeOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"下单失败,请重试";
    }
    [UtilTool showAlertView:errorMsg];
    return;
}

@end
