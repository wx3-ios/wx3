//
//  WaitPayOrderListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitPayOrderListVC.h"
#import "WaitPayOrderListDef.h"
#import "OrderListModel.h"
#import "OrderListEntity.h"
#import "OrderGoodsCell.h"
#import "AliPayControl.h"
#import "OrderCommonDef.h"

@interface WaitPayOrderListVC()<UITableViewDataSource,UITableViewDelegate,WaitPayOrderListDelegate,OrderGoodsDelegate>{
    UITableView *_tableView;
    NSMutableArray *listArr;
    
    UIView *_shell;
}
@end

@implementation WaitPayOrderListVC

-(id)init{
    self = [super init];
    if(self){
        listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    [listArr removeAllObjects];
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){
            [listArr addObject:entity];
        }
    }
    if(_tableView){
        [_tableView reloadData];
    }
    if([listArr count] == 0){
        [_shell setHidden:NO];
        [_tableView setHidden:YES];
    }else{
        [_tableView setHidden:NO];
        [_shell setHidden:YES];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
    
    [self loadEmptyOrderListView];
}

-(void)loadEmptyOrderListView{
    _shell = [[UIView alloc] init];
    [_shell setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yOffset = 10;
    UIImage *img = [UIImage imageNamed:@"NoOrderImg.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((self.bounds.size.width-img.size.width)/2, yOffset, img.size.width, img.size.height);
    [imgView setImage:img];
    [_shell addSubview:imgView];
    
    yOffset += img.size.height+18;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, yOffset, self.bounds.size.width, 20);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"您还没有相关订单"];
    [label setTextColor:WXColorWithInteger(0x000000)];
    [label setFont:WXFont(15.0)];
    [_shell addSubview:label];
    
    yOffset += 30;
    [_shell setHidden:YES];
    [_shell setFrame:CGRectMake(0, 110, IPHONE_SCREEN_WIDTH, 100)];
    [self addSubview:_shell];
    
    if([listArr count] == 0){
        [_tableView setHidden:YES];
        [_shell setHidden:NO];
    }else{
        [_tableView setHidden:NO];
        [_shell setHidden:YES];
    }
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderListSucceed) name:D_Notification_Name_AliPaySucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderListSucceed:) name:K_Notification_UserOderList_CancelSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderListFailed:) name:K_Notification_UserOderList_CancelFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyRefundSucceed:) name:K_Notification_HomeOrder_RefundSucceed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    OrderListEntity *entity = [listArr objectAtIndex:section];
    return OrderList_WaitPay_Invalid+[entity.goodsArr count]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section > 0){
        height = 15;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(row == OrderList_WaitPay_Title){
        height = OrderListWaitPayTitleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = OrderWaitPayConsultCellHeight;
    }
    if(row > OrderList_WaitPay_Title && row < [self numberOfRowInSection:section]-1){
        height = OrderWaitPayGoodsInfoCellHeight;
    }
    return height;
}

//title
-(WXTUITableViewCell*)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setText:@"等待付款"];
    [cell.textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [cell.textLabel setFont:WXFont(15.0)];
    return cell;
}

//商品
-(WXTUITableViewCell*)tabelViewForGoodsInfoCell:(NSInteger)row atSection:(NSInteger)section{
    static NSString *identifier = @"goodInfoCell";
    OrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderListEntity *entity = [listArr objectAtIndex:section];
    OrderListEntity *ent = [entity.goodsArr objectAtIndex:row-1];
    [cell setCellInfo:ent];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//统计
-(WXTUITableViewCell*)tabelViewForConsultCellAtSection:(NSInteger)section{
    static NSString *identifier = @"waitCell";
    OrderWaitPayConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderWaitPayConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDelegate:self];
    OrderListEntity *entity = [listArr objectAtIndex:section];
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(row == OrderList_WaitPay_Title){
        cell = [self tableViewForTitleCell];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForConsultCellAtSection:section];
    }
    if(row > OrderList_WaitPay_Title && row < [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForGoodsInfoCell:row atSection:section];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)indexPathOfOptCellWithOrder:(OrderListEntity*)orderEntity{
    [listArr removeAllObjects];
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){
            [listArr addObject:entity];
        }
    }
    NSInteger index = 100000;
    if (orderEntity && [listArr count] > 0){
        index = [listArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark paySucceed
-(void)payOrderListSucceed{
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == [[OrderListModel shareOrderListModel].orderID integerValue]){
            entity.pay_status = Pay_Status_HasPay;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<10000){
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [_tableView reloadData];
            }
        }
    }
}

#pragma mark goods
-(void)toGoodsInfoWithGoodsID:(NSInteger)goodsID{
    if(goodsID<=0){
        return;
    }
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)goodsID];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToGoodsInfo object:goodsIDStr];
}

-(void)applyRefundSucceed:(NSNotification*)notification{
    OrderListEntity *ent = notification.object;
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == ent.order_id){
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<10000){
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [_tableView reloadData];
            }
        }
    }
}

#pragma mark delegate
-(void)userPayBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [OrderListModel shareOrderListModel].orderID = [NSString stringWithFormat:@"%ld",(long)entity.order_id];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToPay object:entity];
}

-(void)userCancelBtnClicked:(id)sender{
    [self unShowWaitView];
    OrderListEntity *entity = sender;
    [[OrderListModel shareOrderListModel] dealUserOrderListWithType:DealOrderList_Type_Cancel with:[NSString stringWithFormat:@"%ld",(long)entity.order_id]];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

#pragma mark cancel
-(void)cancelOrderListSucceed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *orderID = notification.object;
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == [orderID integerValue]){
            entity.order_status = Order_Status_Cancel;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<10000){
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [_tableView reloadData];
            }
        }
    }
}

-(void)cancelOrderListFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"取消订单失败";
    }
    [UtilTool showAlertView:message];
}

-(void)toOrderRefundSucceed:(id)sender{
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
