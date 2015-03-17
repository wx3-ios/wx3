//
//  MyOrderInfoVC.m
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "MyOrderInfoVC.h"
#import "OrderInfoFoodCell.h"
#import "OrderListEntity.h"
#import "OrderInfoPersonalView.h"
#import "RpRuleEntity.h"
#import "UseRedPagerVC.h"
#import "WXUIGoodEntity.h"
#import "OrderInfoOfficeNameCell.h"

#import "RedPacket.h"
#import "RedPacketBalance.h"
#import "RedPacketRule.h"

#define ViewBesidesOftableViewHeight (40.0)

enum{
    O_OrderInfo_ShopName = 0,
    O_OrderInfo_FoodList,
    
    O_OrderInfo_Invalid,
};

@interface MyOrderInfoVC ()<UITableViewDataSource,UITableViewDelegate>{
    WXUITableView *_tableView;
    OrderListEntity *_orderEntity;
    OrderInfoPersonalView *_orderInfoView;
}
@end

@implementation MyOrderInfoVC

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_orderInfoView);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setCSTTitleColor:[UIColor blackColor]];
    
    _orderInfoView = [[OrderInfoPersonalView alloc] init];
    
    _tableView = [[WXUITableView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.bounds.size.height) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:WXColorWithInteger(0xF0F0F0)];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableFootView]];
    if (isIOS7) {
        [_tableView setSeparatorInset:(UIEdgeInsetsMake(0, 8, 0, 8))];
        [_tableView setSeparatorColor:WXColorWithInteger(0xEBEBEB)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 17.0;
}

-(UIView *)tableFootView{
    UIView *footView = [_orderInfoView orderInfoPersonalView:_orderEntity];

    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return O_OrderInfo_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    switch (section) {
        case O_OrderInfo_ShopName:
            row = 1;
            break;
        case O_OrderInfo_FoodList:
            row = 2+[_orderEntity.dataArr count];
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == O_OrderInfo_FoodList){
        if(row > 0 && row <= [_orderEntity.dataArr count]){
            height = OrderInfoFoodCellHeight;
        }else{
            height = 30;
        }
    }else{
        height = OrderInfoOfficeNameCellHeight;
    }
    
    return height;
}

//点餐时间Cell
-(WXUITableViewCell *)orderTimeCellAtRow:(NSInteger)row{
    static NSString *identifier = @"orderTimeCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.userInteractionEnabled = NO;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_orderEntity.time];
	
	NSString *orderTimeStr = @"订单时间";
    [cell.textLabel setText:[NSString stringWithFormat:@"%@:%@",orderTimeStr,[date YMRSFMString]]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12.0]];
    [cell.textLabel setTextColor:WXColorWithInteger(0x969696)];
    return cell;
}

//点菜合计
-(WXUITableViewCell *)orderTotalCellAtRow:(NSInteger)row{
    static NSString *identifier = @"orderTotalCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.userInteractionEnabled = NO;
    NSInteger count = 0;
    NSInteger num = 0;
    CGFloat money = 0.0;
    CGFloat price = 0.0;
    for(NSDictionary *dic in _orderEntity.dataArr){
        num = [[dic objectForKey:@"num"] integerValue];
        count += num;
        money = [[dic objectForKey:@"price"] floatValue];
        price += num*money;
    }
	NSString *txt = @"点菜合计";
	if (kIsAppModePublic){
		txt = @"商品合计";
	}
	NSString *priceString = [UtilTool convertFloatToString:price];
	[cell.textLabel setText:[NSString stringWithFormat:@"%@:%ld份, ￥%@",txt,(long)count,priceString]];
    [cell.textLabel setTextAlignment:NSTextAlignmentRight];
    return cell;
}

//点餐食物列表
-(OrderInfoFoodCell *)orderFoodListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"orderFoodCell";
    OrderInfoFoodCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[OrderInfoFoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.userInteractionEnabled = NO;
    if(row == 0){
        cell = (OrderInfoFoodCell *)[self orderTimeCellAtRow:row];
    }
    if(row > [_orderEntity.dataArr count]){
        cell = (OrderInfoFoodCell *)[self orderTotalCellAtRow:row];
    }
    if(row > 0 && row <= [_orderEntity.dataArr count]){
        [cell setCellInfo:[_orderEntity.dataArr objectAtIndex:row-1]];
        [cell load];
    }
    
    return cell;
}

//分店名称
-(WXUITableViewCell *)shopNameAtRow:(NSInteger)row{
    static NSString *identifier = @"shopNameCell";
    OrderInfoOfficeNameCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[OrderInfoOfficeNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    }
    [cell setCellInfo:_orderEntity];
    [cell load];
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case O_OrderInfo_ShopName:
            cell = [self shopNameAtRow:row];
            break;
        case O_OrderInfo_FoodList:
            cell = [self orderFoodListCellAtRow:row];
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == O_OrderInfo_ShopName){
        [[CoordinateController sharedCoordinateController] toBranchOfficeInfo:self animated:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
