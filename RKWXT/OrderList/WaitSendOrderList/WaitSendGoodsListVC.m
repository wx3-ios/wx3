//
//  WaitSendGoodsListVC.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitSendGoodsListVC.h"
#import "WaitSendGoodsDef.h"
#import "OrderListModel.h"
#import "OrderListEntity.h"
#import "OrderGoodsCell.h"
#import "OrderCommonDef.h"

@interface WaitSendGoodsListVC()<UITableViewDataSource,UITableViewDelegate,WaitSendOrderDelegate,OrderGoodsDelegate>{
    UITableView *_tableView;
    NSMutableArray *listArr;
    
    UIView *_shell;
}
@end

@implementation WaitSendGoodsListVC

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
        if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Normal && entity.goods_status == Goods_Status_WaitSend){
            NSInteger num = 0;
            for(OrderListEntity *ent in entity.goodsArr){
                if((ent.refund_status == Refund_Status_Being && ent.shopDeal_status == ShopDeal_Refund_Agree) || ent.refund_status == Refund_Status_HasDone){
                    num++;
                }
            }
            if(num != [entity.goodsArr count]){
                [listArr addObject:entity];
            }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyRefundSucceed:) name:K_Notification_HomeOrder_RefundSucceed object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    OrderListEntity *entity = [listArr objectAtIndex:section];
    return OrderList_WaitSend_Invalid+[entity.goodsArr count]-1;
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
    if(row == OrderList_WaitSend_Title){
        height = WaitSendTitleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = WaitSendConsultCellHeight;
    }
    if(row > OrderList_WaitSend_Title && row < [self numberOfRowInSection:section]-1){
        height = WaitSendGoodsInfoCellHeight;
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:@"等待商家处理"];
    [cell.textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [cell.textLabel setFont:WXFont(12.0)];
    return cell;
}

//商品
-(WXTUITableViewCell*)tabelViewForGoodsInfoCell:(NSInteger)row atSection:(NSInteger)section{
    static NSString *identifier = @"sendCell";
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
    static NSString *identifier = @"goodInfoCell";
    WaitSendConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitSendConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    if(row == OrderList_WaitSend_Title){
        cell = [self tableViewForTitleCell];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForConsultCell:section];
    }
    if(row > OrderList_WaitSend_Title && row < [self numberOfRowInSection:section]-1){
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
        if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Normal && entity.goods_status == Goods_Status_WaitSend){
            [listArr addObject:entity];
        }
    }
    NSInteger index = 100000;
    if (orderEntity && [listArr count] > 0){
        index = [listArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark userDeal
-(void)userClickHurryBtn:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_CallShopPhone object:entity.shopPhone];
}

-(void)userClickRefundBtn:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToRefund object:entity];
}

-(void)applyRefundSucceed:(NSNotification*)notification{
    OrderListEntity *ent = notification.object;
    for(OrderListEntity *entity in [OrderListModel shareOrderListModel].orderListAll){
        if(entity.order_id == ent.order_id){
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<100000){
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

//单品状态
-(void)toOrderRefundSucceed:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToRefundSucceed object:entity];
}

-(void)toGoodsInfoWithGoodsID:(NSInteger)goodsID{
    if(goodsID<=0){
        return;
    }
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)goodsID];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToGoodsInfo object:goodsIDStr];
}

@end
