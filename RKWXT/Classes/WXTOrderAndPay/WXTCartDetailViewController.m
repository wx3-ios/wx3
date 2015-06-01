//
//  WXTCartDetailViewController.m
//  RKWXT
//
//  Created by app on 5/30/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTCartDetailViewController.h"
#import "CartDetailCell.h"
@interface WXTCartDetailViewController ()

@end

@implementation WXTCartDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"我的购物车"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    CGFloat tableViewH = IPHONE_SCREEN_HEIGHT-TAB_NAVIGATION_BAR_HEGITH-NAVIGATION_BAR_HEGITH-20;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEGITH + 20, IPHONE_SCREEN_WIDTH, tableViewH)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    CGFloat bottomY = IPHONE_SCREEN_HEIGHT - TAB_NAVIGATION_BAR_HEGITH;
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomY, IPHONE_SCREEN_WIDTH, 0.5)];
    dividerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:dividerView];
    
    UIButton * btnSelectAll = [[UIButton alloc]initWithFrame:CGRectMake(15, bottomY+19.5, 15, 15)];
    [btnSelectAll setImage:[UIImage imageNamed:@"CircleAll.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnSelectAll];
    
    // 全选
    UILabel * btnAll = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnSelectAll.frame)+5, bottomY+19.5, 30, 12)];
    btnAll.text = @"全选";
    btnAll.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:btnAll];
    
    // 结算
    UIButton * btnFinal = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFinal.layer.masksToBounds = YES;
    btnFinal.layer.cornerRadius = 8.0;
//    btnFinal.layer.borderWidth = 1.0;
    btnFinal.frame = CGRectMake(IPHONE_SCREEN_WIDTH-85,bottomY+8, 72.5, TAB_NAVIGATION_BAR_HEGITH-15);
    btnFinal.backgroundColor = [UIColor redColor];
    [btnFinal setTitle:@"结算" forState:UIControlStateNormal];
    [btnFinal addTarget:self action:@selector(finalPayGoods) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFinal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 结算支付
-(void)finalPayGoods{
    
}

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cartIdentifier = @"CartIdentifier";
    CartDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cartIdentifier];
    if (cell == NULL) {
        cell = [[CartDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cartIdentifier];
    }
    
    return cell;
}

@end
