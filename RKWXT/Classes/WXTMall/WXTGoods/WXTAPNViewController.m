//
//  WXTAPNViewController.m
//  RKWXT
//
//  Created by app on 6/10/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTAPNViewController.h"

@interface WXTAPNViewController(){
    NSMutableArray * msgTitleArray;
    NSMutableArray * msgDetailArray;
}

@end

@implementation WXTAPNViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"消息"];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    CGFloat _tableViewY = NAVIGATION_BAR_HEGITH+20;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _tableViewY, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT-_tableViewY)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    msgTitleArray = [NSMutableArray arrayWithObjects:@"我信活动",@"我信新闻", nil];
    msgDetailArray = [NSMutableArray arrayWithObjects:@"狼赢天下，王者归来；剑锋所指，所向披靡",@"不吃饭，不睡觉，打起精神赚钞票",nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return msgTitleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    cell = [self defaultTableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

-(UITableViewCell*)defaultTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"MessageIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.imageView.frame = CGRectMake(10, 10, 45, 45);
    cell.imageView.image = [UIImage imageNamed:@"Icon"];
    cell.textLabel.text = [msgTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.text = [msgDetailArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.numberOfLines = 3;
    UILabel * labelDate = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-50, 17, 40, 9)];
    labelDate.font = [UIFont systemFontOfSize:10];
    labelDate.text = @"09-08";
    [cell addSubview:labelDate];
    return cell;
}

#pragma mark 处理分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
