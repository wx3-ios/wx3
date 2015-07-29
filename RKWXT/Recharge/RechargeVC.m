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

#define Size self.bounds.size
#define HeadViewHeight (80)
#define kAnimatedDur (0.7)

enum{
    WXT_Rechagre_wx = 0,
    
    WXT_Rechagre_Invalid,
}WXT_Rechagre;

@interface RechargeVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    BOOL showRecharge;
    RechargeView *_rechargeView;
    
    WXUITextField *_textField;
}
@end

@implementation RechargeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"充值中心"];
    
//    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-HeadViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableForHeadView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    showRecharge = YES;
    _rechargeView = [[RechargeView alloc] init];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    _rechargeView.rechargeUserphoneStr = userDefault.user;
    [self addSubview:_rechargeView];
    
    [_rechargeView setFrame:CGRectMake(0, ViewNormalDistance, Size.width, RechargeViewHeight)];
//    [self showRechargeInfo];
}

-(UIView*)tableForHeadView{
    UIView *headView = [[UIView alloc] init];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    CGFloat yOffset = 15;
    CGFloat labelHeight = 18;
    CGFloat labelWidth = 80;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(10, yOffset, labelWidth, labelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setText:[NSString stringWithFormat:@"充值账号: "]];
    [phoneLabel setFont:WXTFont(16.0)];
    [phoneLabel setTextColor:WXColorWithInteger(0x000000)];
    [headView addSubview:phoneLabel];
    
    CGFloat xOffset = labelWidth+10;
    _textField = [[WXUITextField alloc] init];
    _textField.frame = CGRectMake(xOffset-5, yOffset, Size.width*2/3, labelHeight);
    [_textField setBackgroundColor:[UIColor clearColor]];
    [_textField setText:userDefault.user];
    [_textField setFont:WXTFont(16.0)];
    [_textField setEnabled:NO];
    [_textField setTextColor:WXColorWithInteger(0xc8c8c8)];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    [_textField setKeyboardType:UIKeyboardTypeNumberPad];
    [_textField setTextAlignment:NSTextAlignmentLeft];
    [headView addSubview:_textField];
    
    yOffset += labelHeight+10;
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(10, yOffset, Size.width-20, 0.5);
    [line setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:line];
    
    yOffset += 6;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(10, yOffset, Size.width-20, 25);
    [textLabel setBackgroundColor:WXColorWithInteger(0xe8e8e8)];
    [textLabel setFont:WXTFont(12.0)];
    [textLabel setText:@" 请确认要充值的手机号码是否正确"];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setTextColor:WXColorWithInteger(0xaf8638)];
    [headView addSubview:textLabel];
    
//    [headView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, Size.width, HeadViewHeight);
    return headView;
}

-(void)textFieldDone:(id)sender{
    [_textField resignFirstResponder];
}

-(void)textFieldChange{
    _rechargeView.rechargeUserphoneStr = _textField.text;
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
    [cell load];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, Size.width, 40);
//    [headView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    return headView;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 30;
//}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footview = [[UIView alloc] init];
//    footview.frame = CGRectMake(0, 0, Size.width, 50);
////    [footview setBackgroundColor:WXColorWithInteger(0xefeff4)];
//    return footview;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [self tableForRechargeCell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self showRechargeInfo];
}

-(void)showRechargeInfo{
    if(!showRecharge){
//        showRecharge = YES;
        [UIView animateWithDuration:kAnimatedDur animations:^{
            //            _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, yOffset, Size.width, 120)];
            //            [_rechargeView setDelegate:self];
            //            [_tableView setTableFooterView:_rechargeView];
            [_rechargeView setFrame:CGRectMake(0, ViewNormalDistance, Size.width, RechargeViewHeight)];
        }completion:^(BOOL finished){
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_rechargeView removeNotification];
}

@end
