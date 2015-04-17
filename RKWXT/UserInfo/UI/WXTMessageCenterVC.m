//
//  WXTMessageCenterVC.m
//  RKWXT
//
//  Created by app on 4/17/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTMessageCenterVC.h"

@interface WXTMessageCenterVC ()

@end

@implementation WXTMessageCenterVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"消息中心";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WXColorWithInteger(0xefeff4);
    msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    msgTableView.delegate = self;
    msgTableView.dataSource = self;
    [self.view addSubview:msgTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * msgIdentifier = @"MassageIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:msgIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgIdentifier];
    }
    return cell;
}

@end
