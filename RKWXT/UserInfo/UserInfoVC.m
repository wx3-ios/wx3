//
//  UserInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoCommonCell.h"

#define UserBgImageViewHeight (125)
#define Size self.view.bounds.size
#define bgImg [UIImage imageNamed:@"PersonalBgImg.jpg"]

@interface UserInfoVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation UserInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
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
    
    xOffset += iconImg.size.width+15;
    CGFloat phoneLabelWidth = 140;
    CGFloat phoneLabelHeight = 20;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(xOffset, (UserBgImageViewHeight-yOffset-iconImg.size.height/2-phoneLabelHeight/2), phoneLabelWidth, phoneLabelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setText:@"18613213051"];
    [phoneLabel setFont:WXTFont(18.0)];
    [phoneLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [headView addSubview:phoneLabel];
    
    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [headView setFrame:rect];
    return headView;
}

-(UIView*)viewForTableFootView{
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
//    CGFloat yOffset = 28;
//    CGFloat footViewHeight = 45;
//    CGFloat btnWidth = 110;
    CGFloat btnHeight = 35;
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    quitBtn.frame = CGRectMake((Size.width-btnWidth)/2, Size.height-yOffset-footViewHeight+(footViewHeight-btnHeight)/2, btnWidth, btnHeight);
    quitBtn.frame = CGRectMake(0, 400, Size.width, btnHeight);
    [quitBtn setBackgroundColor:[UIColor whiteColor]];
    [quitBtn setTitle:@"切换登录帐号" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
    
    CGRect rect = CGRectMake(0, 0, Size.width, btnHeight);
    [footView setFrame:rect];
    return footView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return WXT_UserInfo_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Size.height-UserBgImageViewHeight-20-3*44;
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
}

-(void)quit{
    KFLog_Normal(YES, @"退出登陆");
}

@end