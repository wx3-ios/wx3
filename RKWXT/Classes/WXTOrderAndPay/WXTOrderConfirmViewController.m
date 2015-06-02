//
//  WXTOrderConfirmViewController.m
//  RKWXT
//
//  Created by app on 5/30/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTOrderConfirmViewController.h"
#import "OrderDetailCell.h"
@interface WXTOrderConfirmViewController (){
    NSMutableArray * _payDeliveryKey;
    NSMutableArray * _payDeliveryValue;
    NSMutableArray * _redPacketsIntegral;
}


@end

@implementation WXTOrderConfirmViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"等待付款"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initUI];
}

-(void)loadData{
    _payDeliveryKey = [[NSMutableArray alloc] initWithObjects:@"支付方式",@"配送方式",@"发票信息", nil];
    _payDeliveryValue = [[NSMutableArray alloc]initWithObjects:@"在线支付",@"",@"不开发票", nil];
    _redPacketsIntegral = [[NSMutableArray alloc]initWithObjects:@"使用红包抵现",@"使用积分抵现",@"使用优惠券抵现", nil];
    
}

-(void)initUI{
    [self initTableView];

    CGFloat divideY = IPHONE_SCREEN_HEIGHT-59;
    UIView * divideView = [[UIView alloc]initWithFrame:CGRectMake(0,divideY , IPHONE_SCREEN_WIDTH, 0.3)];
    divideView.backgroundColor = WXColorWithInteger(0x7f7f7f);
    [self.view addSubview:divideView];
    
    CGFloat cancelOrderX = IPHONE_SCREEN_WIDTH-150-25;
    UIButton * cancelOrder = [[UIButton alloc] initWithFrame:CGRectMake(cancelOrderX, divideY+13, 75, 34)];
    [cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelOrder];
    
    CGFloat payBtnX = IPHONE_SCREEN_WIDTH - 13 - 75 ;
    UIButton * payBtn = [[UIButton alloc]initWithFrame:CGRectMake(payBtnX, divideY+13, 75, 34)];
    [payBtn setImage:[UIImage imageNamed:@"PayBtn"] forState:UIControlStateNormal];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
}

-(void)cancelOrder{
    NSLog(@"%s",__FUNCTION__);
}

-(void)payProduct{
    NSLog(@"%s",__FUNCTION__);
}

-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEGITH+20, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT-49-64)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            return 100;
        }
            break;
        case 2:{
            return 100;
        }
            break;
        default:{
            return 13;
        }
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 111;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            UIView * personView = [self personInfo];
            return personView;
        }
            break;
        case 2:{
            UIView * productView = [self productDetail];
            return productView;
        }
            break;
        default:
            return nil;
            break;
    }
}

// 个人信息
-(UIView*)personInfo{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 79)];
    UIView * divideUp = [[UIView alloc]initWithFrame:CGRectMake(0,0, IPHONE_SCREEN_WIDTH, 2)];
    divideUp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_divide"]];
    [view addSubview:divideUp];
    // 姓名
    CGFloat nameY = 21;
    UIImageView *ivName = [[UIImageView alloc]initWithFrame:CGRectMake(13, nameY, 11, 16)];
    ivName.image = [UIImage imageNamed:@"NamePic"];
    [view addSubview:ivName];
    UILabel *lbName = [[UILabel alloc]initWithFrame:CGRectMake(13+11+5, nameY, 90, 16)];
    lbName.font = [UIFont systemFontOfSize:12];
    lbName.text = @"刘某某";
    [view addSubview:lbName];
    
    // 电话号码
    UIImageView *ivPhone = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbName.frame), nameY, 11, 16)];
    ivPhone.image = [UIImage imageNamed:@"PhonePic"];
    [view addSubview:ivPhone];
    UILabel *lbPhone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ivPhone.frame)+5, nameY, 90, 16)];
    lbPhone.font = [UIFont systemFontOfSize:12];
    lbPhone.text = @"158****6589";
    [view addSubview:lbPhone];
    
    // 地址
    UILabel * lbAddress = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(ivName.frame)+7, IPHONE_SCREEN_WIDTH-13, 32)];
    lbAddress.text = @"广东省深圳市龙华新区民德大厦5楼";
    lbAddress.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbAddress];
    
    UIView * divideDown = [[UIView alloc]initWithFrame:CGRectMake(0, 79, IPHONE_SCREEN_WIDTH, 2)];
    divideDown.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_divide"]];
    [view addSubview:divideDown];
    return view;
}

// 产品信息
-(UIView*)productDetail{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 100)];
    
    UIView * downblackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 0.3)];
    downblackView.backgroundColor = WXColorWithInteger(0x7f7f7f);
    [view addSubview:downblackView];
    
    CGFloat ivProY = CGRectGetMaxY(downblackView.frame)+15;
    UIImageView * ivPro = [[UIImageView alloc]initWithFrame:CGRectMake(13,ivProY , 64, 64)];
    ivPro.image = [UIImage imageNamed:@"prodcut"];
    [view addSubview:ivPro];
    
    UILabel * lbProTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ivPro.frame)+13, ivProY-20, 100, 64)];
    lbProTitle.text = @"夏威夷果218g1袋奶油味干果炒货";
    lbProTitle.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbProTitle];
    
    //    UILabel * lbPrice = [UILabel alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    UIView * bottomblackView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ivPro.frame)+15, IPHONE_SCREEN_WIDTH, 0.3)];
    bottomblackView.backgroundColor = WXColorWithInteger(0x7f7f7f);
    [view addSubview:bottomblackView];
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (section) {
        case 3:{
            UIView * view = [self productPriceDetail];
            return view;
        }
            break;
        default:{
            return nil;
        }
            break;
    }
}

// 商品支付详情
-(UIView*)productPriceDetail{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 111)];
    
    UIImageView *upDivide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, IPHONE_SCREEN_WIDTH, 0.3)];
    upDivide.backgroundColor = WXColorWithInteger(0x7f7f7f);
    [view addSubview:upDivide];
    
    UILabel * lbProTotal = [[UILabel alloc] initWithFrame:CGRectMake(13, 13, 100, 18)];
    lbProTotal.text = @"商品总额";
    lbProTotal.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbProTotal];
    
    CGFloat priceX = IPHONE_SCREEN_WIDTH - 13 -50;
    UILabel * lbPrice = [[UILabel alloc]initWithFrame:CGRectMake(priceX, 13, 50, 18)];
    lbPrice.text = @"￥29.00";
    lbPrice.font = [UIFont systemFontOfSize:12];
    lbPrice.textColor = [UIColor redColor];
    [view addSubview:lbPrice];
    
    CGFloat lbRedPackagesY = CGRectGetMaxY(lbProTotal.frame);
    UILabel * lbRedPackages = [[UILabel alloc]initWithFrame:CGRectMake(13, lbRedPackagesY, 100, 18)];
    lbRedPackages.text = @"+红包抵现:";
    lbRedPackages.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbRedPackages];
    
    UILabel * lbRedNumber = [[UILabel alloc]initWithFrame:CGRectMake(priceX, lbRedPackagesY, 50, 18)];
    lbRedNumber.text = @"-50";
    lbRedNumber.textColor = [UIColor redColor];
    lbRedNumber.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbRedNumber];
    
    CGFloat lbDiscountY = CGRectGetMaxY(lbRedPackages.frame);
    UILabel * lbDiscount = [[UILabel alloc]initWithFrame:CGRectMake(13,lbDiscountY, 100, 18)];
    lbDiscount.text = @"+折扣返现:";
    lbDiscount.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbDiscount];
    
    UILabel * lbDisNumber = [[UILabel alloc]initWithFrame:CGRectMake(priceX, lbDiscountY, 50, 18)];
    lbDisNumber.text = @"-50";
    lbDisNumber.font = [UIFont systemFontOfSize:12];
    lbDisNumber.textColor = [UIColor redColor];
    [view addSubview:lbDisNumber];
    
    CGFloat lbFreightY = CGRectGetMaxY(lbDiscount.frame);
    UILabel * lbFreight = [[UILabel alloc] initWithFrame:CGRectMake(13, lbFreightY, 100, 18)];
    lbFreight.text = @"+运费";
    lbFreight.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbFreight];
    
    UILabel * lbFreightPrice = [[UILabel alloc]initWithFrame:CGRectMake(priceX, lbFreightY, 50, 18)];
    lbFreightPrice.text = @"￥8.0";
    lbFreightPrice.font = [UIFont systemFontOfSize:12];
    lbFreightPrice.textColor = [UIColor redColor];
    [view addSubview:lbFreightPrice];
    
    UIImageView *downDivide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13+111, IPHONE_SCREEN_WIDTH, 0.3)];
    downDivide.backgroundColor = WXColorWithInteger(0x7f7f7f);
    [view addSubview:downDivide];
    
    UILabel * lbDisbursements = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-150, CGRectGetMaxY(downDivide.frame)+13, 150, 18)];
    lbDisbursements.text = @"实付款:￥37.90";
    lbDisbursements.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbDisbursements];
    
    UILabel * lbOrderTime = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-180, CGRectGetMaxY(lbDisbursements.frame), 200, 18)];
    lbOrderTime.text = @"下单时间:2015-05-22 09:36:05";
    lbOrderTime.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbOrderTime];
    
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 1;
        }
            break;
        case 2:{
            return _payDeliveryKey.count;
        }
            break;
        case 3:{
            return _redPacketsIntegral.count;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            static NSString * defaultIdentifier = @"DefaultIdentifier";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
            if (cell == NULL) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
            }
            cell.textLabel.text = @"订单号：20150522110";
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            return cell;
        }
            break;
        case 1:{
            UITableViewCell *cell = [self productDatil:tableView cellForRowAtIndexPath:indexPath];
            return cell;
        }
            break;
        case 2:{
            UITableViewCell *cell = [self payDeliveryBill:tableView cellForRowAtIndexPath:indexPath];
            return cell;
        }
            break;
        case 3:{
            UITableViewCell *cell = [self radPackagesIntegral:tableView cellForRowAtIndexPath:indexPath];
            return cell;
        }
            break;
        default:{
            static NSString * defaultIdentifier = @"DefaultIdentifier";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
            if (cell == NULL) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
            }
            return cell;
        }
            break;
    }
}

-(UITableViewCell*)productDatil:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * productIdentifier = @"ProductIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"Woxin"];
    cell.textLabel.text = @"我信科技有限公司";
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

-(UITableViewCell*)payDeliveryBill:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * orderIdentifier = @"OrderIdentifier";
    OrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
    if (cell == NULL) {
        cell = [[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
        cell.orderDetailStyle = OrderDetailDefaultCell;
    }
    cell.defaultTitleKey.text = [_payDeliveryKey objectAtIndex:indexPath.row];
    cell.defaultTitleValue.text = [_payDeliveryValue objectAtIndex:indexPath.row];
    return cell;
}

-(UITableViewCell*)radPackagesIntegral:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * radPackagesIdentifier = @"RadPackagesIdentifier";
    OrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:radPackagesIdentifier];
    if (cell == NULL) {
        cell = [[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:radPackagesIdentifier];
        cell.orderDetailStyle = OrderDetailSwitchCell;
    }
    cell.defaultTitleKey.text = [_redPacketsIntegral objectAtIndex:indexPath.row];
    return cell;
}

@end
