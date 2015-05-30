//
//  WXTProductDetailViewController.m
//  RKWXT
//
//  Created by app on 5/28/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTProductDetailViewController.h"
#import "ProductListCell.h"
@interface WXTProductDetailViewController ()

@end

@implementation WXTProductDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"商品详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [self initUI];
}

-(void)initUI{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * proListIdentifier = @"ProductList";
    ProductListCell * cell = [tableView dequeueReusableCellWithIdentifier:proListIdentifier];
    if (cell == NULL) {
        cell = [[ProductListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:proListIdentifier];
    }
//    cell.textLabel.text = @"测试";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
