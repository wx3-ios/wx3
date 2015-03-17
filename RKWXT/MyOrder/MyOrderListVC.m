//
//  MyOrderListVC.m
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "MyOrderListVC.h"
#import "ServiceCommon.h"
#import "MyOrderListViewCell.h"
#import "MyOrderListObj.h"
#import "MyOrderInfoVC.h"
#import "OrderListEntity.h"
#import "RpRuleEntity.h"
#import "UseRedPagerVC.h"
#import "WXUIPacketGoodEntity.h"

#import "RedPacketRule.h"
#import "RedPacket.h"
#import "RedPacketBalance.h"

@interface MyOrderListVC ()<UITableViewDataSource,UITableViewDelegate,UseRedPagerDelegate>{
    WXUITableView *_tablewView;
    NSMutableArray *orderListArr;
    NSArray *ruleArr;
}
@property (nonatomic,retain) NSMutableArray *infoArr;
@end

@implementation MyOrderListVC

-(void)dealloc{
    RELEASE_SAFELY(_tablewView);
    RELEASE_SAFELY(orderListArr);
    RELEASE_SAFELY(_infoArr);
	[self removeNotification];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCSTTitle:@"我的订单"];
    [self setCSTTitleColor:[UIColor blackColor]];
    [self setBackNavigationBarItem];
    
    _tablewView = [[WXUITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];;
    [_tablewView setDataSource:self];
    [_tablewView setDelegate:self];
    [self addSubview:_tablewView];
    
    _infoArr = [[NSMutableArray alloc] init];  //传递给红包使用详情页的数据
    orderListArr = [[NSMutableArray alloc] init]; //订单列表数据
    
    BOOL isLoad = [[MyOrderListObj sharedOrderList] isLoadOrderList];
    if(!isLoad){
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@"数据加载中"];
        [[MyOrderListObj sharedOrderList] loadOrderList];
    }else{
        NSArray *oldOrderListArr = [[MyOrderListObj sharedOrderList] orderListArr];
        [orderListArr addObjectsFromArray:oldOrderListArr];
    }

    ruleArr = [[RedPacketRule sharedRedPacketRule] ruleList];  //红包规则数据
	[self addNotification];
}

-(WXUIView *)loadEmptyOrderListArrView{
    WXUIView *emptyView = [[[WXUIView alloc] init] autorelease];
    
    CGFloat yOffset = 80;
    UIImage *img = [UIImage imageNamed:@"OrderListEmpty.png"];
    CGSize size = img.size;
    
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-size.width)/2, yOffset, size.width, size.height);
    [imgView setImage:img];
    [emptyView addSubview:imgView];
    RELEASE_SAFELY(imgView);
    
    yOffset += size.height+50;
    CGFloat textHeight = 20;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, textHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:[UIFont systemFontOfSize:16.0]];
    [textLabel setText:@"您目前还没订单，赶快去下单吧"];
    [textLabel setTextColor:WXColorWithInteger(0x969696)];
    [emptyView addSubview:textLabel];
    RELEASE_SAFELY(textLabel);
    
    CGRect rect = self.bounds;
    emptyView.frame = rect;
    return emptyView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [orderListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSString *foodNameStr = [[[NSString alloc] init] autorelease];
    NSInteger section = indexPath.section;
    OrderListEntity *orderEntity = [orderListArr objectAtIndex:section];
    for(NSDictionary *dic in orderEntity.dataArr){
        foodNameStr = [foodNameStr stringByAppendingString:[NSString stringWithFormat:@"%@、",[dic objectForKey:@"name"]]];
    }
    height = [foodNameStr stringHeight:[UIFont systemFontOfSize:14.0] width:300]+110;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(WXUITableViewCell *)myOrderListCellAtSection:(NSInteger)section{
    static NSString *identifier = @"myOrderListCell";
    MyOrderListViewCell *cell = [_tablewView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[MyOrderListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    OrderListEntity *orderEntity = [orderListArr objectAtIndex:section];
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(![orderEntity.shop_name isEqualToString:userObj.subShopName]){
        cell.userInteractionEnabled = NO;
        [cell setBackgroundColor:WXColorWithInteger(0xDCDCDC)];
    }else{
        cell.userInteractionEnabled = YES;
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    cell.delegate = self;
    [cell setCellInfo:orderEntity];
    [cell load];
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self myOrderListCellAtSection:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tablewView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    MyOrderInfoVC *orderInfo = [[[MyOrderInfoVC alloc] init] autorelease];
    orderInfo.orderEntity = [orderListArr objectAtIndex:section];
    [self.wxNavigationController pushViewController:orderInfo];
}

-(void)useRedPager:(id)entity{
    OrderListEntity *orderEntity = entity;
    NSInteger num = 0;
    CGFloat money = 0.0;
    CGFloat price = 0.0;
    for(NSDictionary *dic in orderEntity.dataArr){
        num = [[dic objectForKey:@"num"] integerValue];
        money = [[dic objectForKey:@"price"] floatValue];
        price += num * money;
    }
	NSInteger ret = [[RedPacketBalance sharedRedPacketBalance] useRedPacket:[self redPagerRules:price withOrderID:orderEntity.order_id] orderID:orderEntity.order_id];
    if(ret == 0){
        [self showWaitViewMode:E_WaiteView_Mode_FullScreenBlock title:@"使用红包"];
    }
}

-(NSInteger)redPagerRules:(CGFloat)money withOrderID:(NSString*)orderIDStr{
	NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];   //使用红包跳转页面数据
	NSArray *rules = [RedPacketRule sharedRedPacketRule].ruleList;
	if([rules count] == 0){
		[UtilTool showAlertView:@"对不起，此店暂不开放红包"];
		return 0;
	}
    RpRuleEntity *rpRuleEntity = [[[RpRuleEntity alloc] init] autorelease];
    rpRuleEntity = [[RedPacketRule sharedRedPacketRule] suitRPRuleFor:money];
	CGFloat minus = rpRuleEntity.minus;
	CGFloat balance = [RedPacketBalance sharedRedPacketBalance].balance;
	if (balance < minus){
        minus = balance;
	}
	if (minus > 0){
		[UtilTool showAlertView:[NSString stringWithFormat:@"根据您的消费和余额情况, 可使用%@元红包",[UtilTool convertFloatToString:minus]]];
	}else {
		[UtilTool showAlertView:@"你的消费未满足使用红包的标准"];
	}
	[dic setObject:[NSString stringWithFormat:@"%f",minus] forKey:@"balance"];
	[dic setObject:[NSString stringWithFormat:@"%f",money] forKey:@"money"];
	[_infoArr addObject:dic];
    
    if(minus > 0){
        for(OrderListEntity *entity in orderListArr){
            if([entity.order_id isEqualToString:orderIDStr]){
                entity.red_package = minus;
                break;
            }
        }
    }
	return minus;
}

-(void)loadOrderListSucceed{
    [self unShowWaitView];
    NSArray *oldOrderListArr = [[MyOrderListObj sharedOrderList] orderListArr];
    [self orderDataChangeTurn:oldOrderListArr];
}

-(void)loadOrderListFailed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"加载订单列表失败"];
}

-(void)orderDataChangeTurn:(NSArray *)arr{
    [orderListArr removeAllObjects];
    for(NSInteger i = 0;i < [arr count]; i++){
        [orderListArr addObject:[arr objectAtIndex:i]];
    }
    if([arr count] == 0){
        [self addSubview:[self loadEmptyOrderListArrView]];
    }
    [_tablewView reloadData];
}

-(void)reloadOrderList{
    [[MyOrderListObj sharedOrderList] loadOrderList];
}

//使用红包成功跳转
-(void)useRedPagerSucceed{
    [self unShowWaitView];
    [_tablewView reloadData];
    
    UseRedPagerVC *useRpVC = [[[UseRedPagerVC alloc] init] autorelease];
    useRpVC.infoArr = _infoArr;
    [self.wxNavigationController pushViewController:useRpVC];
}

-(void)useRedPagerFailed{
    [self unShowWaitView];
}

-(void)addNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(useRedPagerSucceed) name:D_Notification_RedPacketBalanceUsedSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(useRedPagerFailed) name:D_Notification_RedPacketBalanceUsedFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadOrderListSucceed) name:loadMyOrderListSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadOrderListFailed) name:loadMyOrderListFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(reloadOrderList) name:D_Notification_Name_Lib_SubmitOrderSucceed object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
