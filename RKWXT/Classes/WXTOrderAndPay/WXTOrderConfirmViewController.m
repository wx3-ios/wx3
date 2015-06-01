//
//  WXTOrderConfirmViewController.m
//  RKWXT
//
//  Created by app on 5/30/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTOrderConfirmViewController.h"

@interface WXTOrderConfirmViewController ()

@end

@implementation WXTOrderConfirmViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"待付款"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
//    UILabel * lbOrderNo = [[UILabel alloc]initWithFrame:CGRectMake(13, NAVIGATION_BAR_HEGITH+20+13, IPHONE_SCREEN_WIDTH-13, 18)];
//    lbOrderNo.text = @"订单号:20150522110";
//    [self.view addSubview:lbOrderNo];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEGITH+20, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT-59)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView * divideView = [[UIView alloc]initWithFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT-59, IPHONE_SCREEN_WIDTH, 0.5)];
    divideView.backgroundColor = [UIColor redColor];
    [self.view addSubview:divideView];
    
    
    
//    UIView * di[]
    
//    UIButton * cancelOrder = [[UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    
//    [self.view addSubview:c]
    
//    UIButton * cancelOrder = [[UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    
//    [self.view addSubview:c]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            UIView * personView = [self personInfo];
            return personView;
        }
            break;
        case 1:{
            UIView * goodsView = [self goodsDetailInfo];
            return goodsView;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

// 个人信息
-(UIView*)personInfo{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 100)];
    UILabel * lbOrderNo = [[UILabel alloc]initWithFrame:CGRectMake(13, 13, IPHONE_SCREEN_WIDTH-13, 18)];
    lbOrderNo.text = @"订单号:20150522110";
    lbOrderNo.font = [UIFont systemFontOfSize:14];
    [view addSubview:lbOrderNo];
    
    UIView * orderLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, IPHONE_SCREEN_WIDTH, 0.5)];
    orderLine.backgroundColor = [UIColor redColor];
    [view addSubview:orderLine];
    // 个人信息
    CGFloat divideY =  44+13;
    UIView * divideUp = [[UIView alloc]initWithFrame:CGRectMake(0,divideY, IPHONE_SCREEN_WIDTH, 2)];
    divideUp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_divide"]];
    [view addSubview:divideUp];
    // 姓名
    CGFloat nameY = divideY+21;
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
    
    UIView * divideDown = [[UIView alloc]initWithFrame:CGRectMake(0, 44+13+79, IPHONE_SCREEN_WIDTH, 2)];
    divideDown.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_divide"]];
    [view addSubview:divideDown];
    return view;
}

-(UIView*)goodsDetailInfo{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 100)];
//    UIView * divideView = [UIView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    UIImageView * ivWoxin = [[UIImageView alloc]initWithFrame:CGRectMake(13, 16, 100, 18)];
    [view addSubview:ivWoxin];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * orderIdentifier = @"";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
    }
    return cell;
}

@end
