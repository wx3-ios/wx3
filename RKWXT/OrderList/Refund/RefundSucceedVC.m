//
//  RefundSucceedVC.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundSucceedVC.h"

enum{
    RefundSucceed_Section_Title = 0,
    RefundSucceed_Section_GoodsList,
    RefundSucceed_Section_Name,
    RefundSucceed_Section_Phone,
    RefundSucceed_Section_Address,
    
    RefundSucceed_Section_Invalid,
};

@interface RefundSucceedVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *infoArr;
}

@end

@implementation RefundSucceedVC

-(id)init{
    self = [super init];
    if(self){
        infoArr = @[@"收货人:张某某", @"联系电话:1888888888", @"退货地址:东美大厦B栋5楼"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setCSTTitle:@"退款申请成功"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return RefundSucceed_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case RefundSucceed_Section_Address:
        case RefundSucceed_Section_Name:
        case RefundSucceed_Section_Phone:
        case RefundSucceed_Section_Title:
            number = 1;
            break;
        case RefundSucceed_Section_GoodsList:
            number = 2;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case RefundSucceed_Section_Title:
            height = 35;
            break;
        case RefundSucceed_Section_GoodsList:
            height = 94;
            break;
        case RefundSucceed_Section_Name:
        case RefundSucceed_Section_Phone:
        case RefundSucceed_Section_Address:
            height = 45;
            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForTitleCell{
    static NSString *identifier = @"titleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:@"我们已经收到您的退款申请，请将商品寄到以下地址"];
    [cell.textLabel setFont:WXFont(12.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    return cell;
}

-(WXUITableViewCell *)tableViewForInfoCell:(NSInteger)section{
    static NSString *identifier = @"infoCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:[infoArr objectAtIndex:section-2]];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    [cell.textLabel setNumberOfLines:0];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    WXUITableViewCell *cell = nil;
    switch (section) {
        case RefundSucceed_Section_Title:
            cell = [self tableViewForTitleCell];
            break;
        case RefundSucceed_Section_Name:
        case RefundSucceed_Section_Phone:
        case RefundSucceed_Section_Address:
            cell = [self tableViewForInfoCell:section];
            break;
        case RefundSucceed_Section_GoodsList:
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
