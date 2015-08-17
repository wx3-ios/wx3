//
//  LuckyGoodsOrderList.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderList.h"
#import "LuckyGoodsOrderListCell.h"

#define Size self.bounds.size

@interface LuckyGoodsOrderList ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *orderListArr;
}

@end

@implementation LuckyGoodsOrderList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"奖品订单"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LuckyGoodsOrderListCellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [orderListArr count];
}

-(WXUITableViewCell *)tableViewForLuckyGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"luckyOrderListCell";
    LuckyGoodsOrderListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForLuckyGoodsListCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
