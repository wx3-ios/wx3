//
//  RechargeVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeVC.h"
#import "RechargeCell.h"
#import "RechargeView.h"

#define Size self.view.bounds.size
#define HeadViewHeight (50)
#define kAnimatedDur (0.7)

enum{
    WXT_Rechagre_wx = 0,
    
    WXT_Rechagre_Invalid,
}WXT_Rechagre;

@interface RechargeVC()<UITableViewDataSource,UITableViewDelegate,RechargeViewDelegate>{
    UITableView *_tableView;
    BOOL showRecharge;
    RechargeView *_rechargeView;
}
@end

@implementation RechargeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setTitle:@"充值中心"];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-HeadViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableForHeadView]];
    [_tableView setTableFooterView:[self viewFortableFootView]];
    
    showRecharge = NO;
    _rechargeView = [[RechargeView alloc] init];
    [_rechargeView setDelegate:self];
    [self.view addSubview:_rechargeView];
    [self showRechargeInfo];
}

-(UIView*)viewFortableFootView{
    UIView *footView = [[UIView alloc] init];
    
    CGFloat yOffset = 160;
    footView.frame = CGRectMake(0, yOffset, Size.width, Size.height-yOffset);
    [footView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    return footView;
}

-(UIView*)tableForHeadView{
    UIView *headView = [[UIView alloc] init];
    
    CGFloat yOffset = 15;
    CGFloat labelHeight = 18;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(0, yOffset, Size.width, labelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setTextColor:[UIColor blackColor]];
    [phoneLabel setText:@"充值帐号:18613213051"];
    [phoneLabel setFont:WXTFont(15.0)];
    [headView addSubview:phoneLabel];
    
    yOffset += labelHeight+10;
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [line setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:line];
    
    [headView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    headView.frame = CGRectMake(0, 0, Size.width, HeadViewHeight);
    return headView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return WXT_Rechagre_Invalid;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RechargeCellHeight;
}

-(UITableViewCell*)tableForRechargeCell{
    static NSString *identifier = @"rechargeCell";
    RechargeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RechargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell load];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, Size.width, 40);
    [headView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [[UIView alloc] init];
    footview.frame = CGRectMake(0, 0, Size.width, 200);
    [footview setBackgroundColor:WXColorWithInteger(0xefeff4)];
    return footview;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [self tableForRechargeCell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showRechargeInfo];
}

-(void)showRechargeInfo{
    if(!showRecharge){
        showRecharge = YES;
        [UIView animateWithDuration:kAnimatedDur animations:^{
            //            _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, yOffset, Size.width, 120)];
            //            [_rechargeView setDelegate:self];
            //            [_tableView setTableFooterView:_rechargeView];
           
            [_rechargeView setFrame:CGRectMake(0, ViewNormalDistance, Size.width, RechargeViewHeight)];
        }completion:^(BOOL finished){
        }];
    }
}

-(void)rechargeCancel{
    showRecharge = NO;
    [UIView animateWithDuration:kAnimatedDur animations:^{
//        [_rechargeView removeFromSuperview];
        [_rechargeView setFrame:CGRectMake(0, ViewBigDistance, Size.width, RechargeViewHeight)];
    }completion:^(BOOL finished) {
    }];
}

@end
