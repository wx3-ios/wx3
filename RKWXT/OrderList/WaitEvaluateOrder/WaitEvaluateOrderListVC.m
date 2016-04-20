//
//  WaitEvaluateOrderListVC.m
//  RKWXT
//
//  Created by SHB on 16/4/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitEvaluateOrderListVC.h"
#import "WaitEvaluateOrderDef.h"
#import "OrderListModel.h"
#import "OrderListEntity.h"
#import "OrderGoodsCell.h"
#import "OrderCommonDef.h"
#import "OrderEvaluateVC.h"

@interface WaitEvaluateOrderListVC()<UITableViewDataSource,UITableViewDelegate,WaitEvaluateConsultCellDelegate,OrderGoodsDelegate>{
    UITableView *_tableView;
    NSMutableArray *listArr;
    
    UIView *_shell;
}
@end

@implementation WaitEvaluateOrderListVC

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
        if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Complete && entity.evaluate == Order_Evaluate_None){
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evaluateSucceed:) name:K_Notification_Name_EvaluateOrderSucceed object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    OrderListEntity *entity = [listArr objectAtIndex:section];
    return OrderList_WaitEvaluate_Invalid+[entity.goodsArr count]-1;
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
    if(row == OrderList_WaitEvaluate_Title){
        height = WaitEvaluateTitleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = WaitEvaluateConsultCellHeight;
    }
    if(row > OrderList_WaitEvaluate_Title && row < [self numberOfRowInSection:section]-1){
        height = 91;
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
    [cell.textLabel setText:@"订单已完成"];
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
    WaitEvaluateConsultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitEvaluateConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    if(row == OrderList_WaitEvaluate_Title){
        cell = [self tableViewForTitleCell];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self tabelViewForConsultCell:section];
    }
    if(row > OrderList_WaitEvaluate_Title && row < [self numberOfRowInSection:section]-1){
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
        if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Complete && entity.evaluate == Order_Evaluate_None){
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
-(void)userEvaluateOrder:(id)sender{
    OrderListEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToEvaluate object:entity];
}

-(void)evaluateSucceed:(NSNotification*)notification{
    OrderListEntity *entity = notification.object;
    NSArray *arr = [NSArray arrayWithArray:listArr];
    for(OrderListEntity *ent in arr){
        if(entity.order_id == ent.order_id){
            entity.evaluate = Order_Evaluate_Done;
            NSInteger index = [self indexPathOfOptCellWithOrder:entity];
            if (index<10000){
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [_tableView reloadData];
            }
        }
    }
}

-(void)toOrderRefundSucceed:(id)sender{}

-(void)toGoodsInfoWithGoodsID:(NSInteger)goodsID{
    if(goodsID<=0){
        return;
    }
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)goodsID];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_HomeOrder_ToGoodsInfo object:goodsIDStr];
}

@end
