//
//  LMRefundOrderVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMRefundOrderVC.h"
#import "OrderListEntity.h"
#import "RefundCompanyCell.h"
#import "RefundGoodsListCell.h"
#import "RefundConsultCell.h"
#import "OrderListModel.h"
#import "RefundSucceedVC.h"
#import "OrderCommonDef.h"

#define TextViewHeight (65)
#define Size self.bounds.size

enum{
    Refund_Section_Company = 0,
    Refund_Section_GoodsInfo,
    Refund_Section_Consult,
    
    Refund_Section_Invalid,
};

@interface LMRefundOrderVC ()<UITableViewDataSource,UITableViewDelegate,SelectGoodsDelegate,SelectAllGoodsDelegate>{
    UITableView *_tableView;
    OrderListEntity *orderEntity;
    
    WXUITextView *_textView;
}
@end

@implementation LMRefundOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setCSTTitle:@"退款申请"];
    
//    orderEntity = _entity;
    
    [self createTextViewWithHeight:TextViewHeight];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, TextViewHeight+1, self.bounds.size.width, self.bounds.size.height-TextViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
}

-(void)createTextViewWithHeight:(CGFloat)textViewHeight{
    CGFloat xOffset = 10;
    CGFloat yOffset = 12;
    _textView = [[WXUITextView alloc] init];
    _textView.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width-2*xOffset, TextViewHeight-2*yOffset);
    [_textView setBackgroundColor:[UIColor grayColor]];
    [_textView setPlaceholder:@"给商家留言 (必填*)"];
    [_textView setPlaceholderColor:WXColorWithInteger(0xb8b8b8)];
    [_textView setTextAlignment:NSTextAlignmentLeft];
    [_textView setFont:WXFont(14.0)];
    [self addSubview:_textView];
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refundOrderSucceed) name:K_Notification_UserOderList_RefundSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refundOrderFailed:) name:K_Notification_UserOderList_RefundFailed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Refund_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case Refund_Section_Company:
        case Refund_Section_Consult:
            number = 1;
            break;
        case Refund_Section_GoodsInfo:
            number = [orderEntity.goodsArr count];
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case Refund_Section_Company:
            height = RefundCompanyCellHeight;
            break;
        case Refund_Section_GoodsInfo:
            height = RefundGoodsListCellHeight;
            break;
        case Refund_Section_Consult:
            height = RefundConsultCellHeight;
            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForCompanyCell{
    static NSString *identifier = @"companyCell";
    RefundCompanyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RefundCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableviewForGoodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"goodsInfoCell";
    RefundGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RefundGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *ent = [orderEntity.goodsArr objectAtIndex:row];
    [cell setCellInfo:ent];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableviewForConsultCell{
    static NSString *identifier = @"consultCell";
    RefundConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RefundConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:orderEntity];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    WXUITableViewCell *cell = nil;
    switch (section) {
        case Refund_Section_Company:
            cell = [self tableViewForCompanyCell];
            break;
        case Refund_Section_GoodsInfo:
            cell = [self tableviewForGoodsInfoCell:row];
            break;
        case Refund_Section_Consult:
            cell = [self tableviewForConsultCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == Refund_Section_Company) {
        [[CoordinateController sharedCoordinateController] toAboutShopVC:self animated:YES];
    }
}

#pragma mark select
-(void)selectGoods{
    [_tableView reloadData];
}

-(void)selectAllGoods{
    [_tableView reloadData];
}

-(void)refundGoodsBtnClicked:(id)sender{
    OrderListEntity *entity1 = sender;
    NSInteger number = 0;
    NSInteger goodsArrNum = [entity1.goodsArr count];
    NSInteger refundOrderID = 0;
    for(OrderListEntity *ent in entity1.goodsArr){
        if(ent.selected && ent.refund_status == Refund_Status_Normal){
            number ++;
            refundOrderID = ent.orderGoodsID;
        }
    }
    if(number == 0){
        [UtilTool showAlertView:@"请选择要退款的单品"];
        return;
    }
    if(number != 1){
        [UtilTool showAlertView:@"抱歉!每次只允许申请退一件单品"];
        return;
    }
    if(![self checkUserMessage]){
        return;
    }
    if(number == 1){
        [[OrderListModel shareOrderListModel] refundOrderWithRefundType:Refund_Type_Goods withOrderGoodsID:refundOrderID orderID:entity1.order_id withMessage:_textView.text];
        return;
    }
    
    if((entity1.selectAll || (number == goodsArrNum)) && [self checkUserMessage]){
        [[OrderListModel shareOrderListModel] refundOrderWithRefundType:Refund_Type_Order withOrderGoodsID:0 orderID:entity1.order_id withMessage:_textView.text];
    }
}

-(BOOL)checkUserMessage{
    NSInteger length = _textView.text.length;
    if(length == 0){
        [UtilTool showAlertView:@"申请退款留言不能为空"];
        return NO;
    }
    if(length > 255){
        [UtilTool showAlertView:@"申请退款留言不能大于255个字"];
        return NO;
    }
    return YES;
}

-(void)refundOrderSucceed{
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_RefundSucceed object:_entity];
    [UtilTool showTipView:@"退款金额将在7个工作日内退还到您的账户，请注意查收!"];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)refundOrderFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"申请退款失败";
    }
    [UtilTool showAlertView:message];
}

-(void)searchRefundStatus:(id)sender{
    OrderListEntity *ent = sender;
    [[CoordinateController sharedCoordinateController] toRefundInfoVC:self orderEntity:ent animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
