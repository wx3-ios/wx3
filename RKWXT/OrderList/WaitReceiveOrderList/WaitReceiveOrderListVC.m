//
//  WaitReceiveOrderListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveOrderListVC.h"
#import "OrderListWaitReceiveDef.h"
#import "OrderListModel.h"
#import "OrderListEntity.h"
#import "OrderGoodsCell.h"
#import "OrderCommonDef.h"

@interface WaitReceiveOrderListVC()<UITableViewDataSource,UITableViewDelegate,ReceiveOrderDelegate,OrderGoodsDelegate>{
    UITableView *_tableView;
    NSMutableArray *listArr;
    
    UIView *_shell;
}
@end

@implementation WaitReceiveOrderListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    [listArr removeAllObjects];
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_HasSend && entity.order_status == Order_Status_Normal){
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

-(id)init{
    self = [super init];
    if(self){
        listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeOrderSucceed:) name:K_Notification_UserOderList_CompleteSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeOrderFailed:) name:K_Notification_UserOderList_CompleteFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyrefundSucceed:) name:K_Notification_HomeOrder_RefundSucceed object:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
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
    if(row == OrderList_WaitReceive_Title){
        height = WaitReceiveTitleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = WaitReceiveConsultCellHeight;
    }
    if(row > OrderList_WaitReceive_Title && row < [self numberOfRowInSection:section]-1){
        height = WaitReceiveGoodsInfoCellHeight;
    }
    return height;
}

//title
-(WXTUITableViewCell*)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WaitReceiveTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
-(WXTUITableViewCell*)tabelViewForConsultCell:(NSInteger)section{
    static NSString *identifier = @"consultCell";
    WaitReceiveConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderListEntity *entity = [listArr objectAtIndex:section];
    [cell setCellInfo:entity];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(row == OrderList_WaitReceive_Title){
        cell = [self tableViewForTitleCell];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForConsultCell:section];
    }
    if(row > OrderList_WaitReceive_Title && row < [self numberOfRowInSection:section]-1){
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
        if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Normal && entity.goods_status == Goods_Status_HasSend){
            [listArr addObject:entity];
        }
    }
    NSInteger index = 100000;
    if (orderEntity && [listArr count] > 0){
        index = [listArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark receive
-(void)receiveOrderBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [[OrderListModel shareOrderListModel] dealUserOrderListWithType:DealOrderList_Type_Complete with:[NSString stringWithFormat:@"%ld",(long)entity.order_id]];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)refundOrderBtnClicked:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToRefund object:entity];
}

-(void)applyrefundSucceed:(NSNotification*)notification{
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

-(void)completeOrderSucceed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *orderID = notification.object;
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == [orderID integerValue]){
            entity.order_status = Order_Status_None;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<10000){
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [_tableView reloadData];
            }
        }
    }
}

-(void)completeOrderFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"确认订单失败";
    }
    [UtilTool showAlertView:message];
}

//单品状态
-(void)toOrderRefundSucceed:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToRefundSucceed object:entity];
}

#pragma mark goods
-(void)toGoodsInfoWithGoodsID:(NSInteger)goodsID{
    if(goodsID<=0){
        return;
    }
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)goodsID];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToGoodsInfo object:goodsIDStr];
}

@end
