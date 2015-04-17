//
//  UserInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoCommonCell.h"
#import "RechargeVC.h"
#import "UserBalanceVC.h"
#import "WXTUITabBarController.h"
#import "SignViewController.h"
#import "LoginVC.h"
#import "AboutWxtInfoVC.h"
#import "WXTResetPwdVC.h"
#import "WXTMessageCenterVC.h"
#define UserBgImageViewHeight (125)
#define Size self.view.bounds.size
#define bgImg [UIImage imageNamed:@"PersonalBgImg.jpg"]

@interface UserInfoVC()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation UserInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-20);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_tableView];
    
    [_tableView setTableHeaderView:[self viewForTableHeadView]];
    [_tableView setTableFooterView:[self viewForTableFootView]];
}

-(UIView *)viewForTableHeadView{
    UIView *headView = [[UIView alloc] init];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [bgImageView setImage:bgImg];
    [headView addSubview:bgImageView];
    
    CGFloat xOffset = 18;
    CGFloat yOffset = 18;
    UIImage *iconImg = [UIImage imageNamed:@"portrait.png"];
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake(xOffset, UserBgImageViewHeight-yOffset-iconImg.size.height, iconImg.size.width, iconImg.size.height);
    [iconImageView setImage:iconImg];
    [headView addSubview:iconImageView];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    xOffset += iconImg.size.width+15;
    CGFloat phoneLabelWidth = 140;
    CGFloat phoneLabelHeight = 20;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(xOffset, (UserBgImageViewHeight-yOffset-iconImg.size.height/2-phoneLabelHeight/2), phoneLabelWidth, phoneLabelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setFont:WXTFont(18.0)];
    [phoneLabel setText:userDefault.user];
    [phoneLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [headView addSubview:phoneLabel];
    
    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [headView setFrame:rect];
    return headView;
}

-(UIView*)viewForTableFootView{
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    CGFloat btnHeight = 45;
    WXTUIButton *quitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(0, 30, Size.width, btnHeight);
    [quitBtn setBackgroundImageOfColor:WXColorWithInteger(0xFFFFFF) controlState:UIControlStateNormal];
    [quitBtn setTitle:@"切换登录帐号" forState:UIControlStateNormal];
    [quitBtn setTitleColor:WXColorWithInteger(0x669696) forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:quitBtn];
    
    CGRect rect = CGRectMake(0, 0, Size.width, 220);
    if(Size.width == 375){
        rect = CGRectMake(0, 0, Size.width, 320);
    }
    if(Size.width == 414){
        rect = CGRectMake(0, 0, Size.width, 390);
    }
    [footView setFrame:rect];
    return footView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return WXT_UserInfo_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(WXTUITableViewCell*)tabelForUserInfoCommonCell:(NSInteger)row{
    static NSString *identifier = @"commonCell";
    UserInfoCommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserInfoCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell loadUserInfoBaseData:row];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tabelForUserInfoCommonCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    switch (row) {
        case WXT_UserInfo_Recharge:
        {
            RechargeVC *rechargeVC = [[RechargeVC alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case WXT_UserInfo_Balance:
        {
            UserBalanceVC *userBalanceVC = [[UserBalanceVC alloc] init];
            [self.navigationController pushViewController:userBalanceVC animated:YES];
        }
            break;
        case WXT_UserInfo_Sign:
        {
            SignViewController *signVC = [[SignViewController alloc] init];
            [self.navigationController pushViewController:signVC animated:YES];
        }
            break;/*
        case WXT_UserInfo_Message:{
            WXTMessageCenterVC * messageVC = [[WXTMessageCenterVC alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;*/
        case WXT_UserInfo_ResetPwd:
        {
            WXTResetPwdVC *resetPwdVC = [[WXTResetPwdVC alloc] init];
            [self.navigationController pushViewController:resetPwdVC animated:YES];
        }
            break;
        case WXT_UserInfo_About:
        {
            AboutWxtInfoVC *signVC = [[AboutWxtInfoVC alloc] init];
            [self.navigationController pushViewController:signVC animated:YES];
        }
        default:
            break;
    }
}

-(void)quit{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"确定要退出我信通吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger index = buttonIndex;
    if(index == 1){
        //清除用户信息
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        [userDefault removeAllUserInfo];
        
        LoginVC *loginVC = [[LoginVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:navigationController animated:YES completion:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
}

@end
