//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "WXTWebViewController.h"
@interface WXTFindVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * _tableView;
    NSArray * array;
}
@end
@implementation WXTFindVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createTopView:@"发现"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    array = [NSArray arrayWithObjects:@"商家联盟",@"天气", nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 50 - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kFindCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFindCellIdentifier];
    }
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[[WXTWebViewController alloc] initWithRequestUrl:kUrl] animated:YES];
    
}

@end
