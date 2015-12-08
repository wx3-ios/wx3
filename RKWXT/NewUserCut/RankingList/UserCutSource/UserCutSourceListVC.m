//
//  UserCutSourceListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceListVC.h"
#import "UserCutSourceListCell.h"
#import "WXRemotionImgBtn.h"
#import "UserHeaderModel.h"

#define Size self.bounds.size

@interface UserCutSourceListVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    WXUILabel *moneyLabel;
    NSArray *listArr;
}

@end

@implementation UserCutSourceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的收益"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableViewForHeaderView]];
}

-(WXUIView*)tableViewForHeaderView{
    WXUIView *headerView = [[WXUIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat headerViewHeight = 105;
    CGFloat xOffset = 10;
    CGFloat imgViewWidth = 65;
    CGFloat imgViewHeight = imgViewWidth;
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfo.png"];
    WXRemotionImgBtn *iconImageView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (92-imgViewHeight)/2, imgViewWidth, imgViewHeight)];
    [iconImageView setImage:iconImg];
    [iconImageView setUserInteractionEnabled:NO];
    [iconImageView setBorderRadian:imgViewWidth/2 width:1.0 color:[UIColor clearColor]];
    [headerView addSubview:iconImageView];
    if([UserHeaderModel shareUserHeaderModel].userHeaderImg){
        [iconImageView setCpxViewInfo:[UserHeaderModel shareUserHeaderModel].userHeaderImg];
        [iconImageView load];
    }
    
    xOffset += imgViewWidth+5;
    CGFloat yOffset = 25;
    CGFloat labelWidth = 200;
    CGFloat labelHeight = 20;
    WXUILabel *nickName = [[WXUILabel alloc] init];
    nickName.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [nickName setBackgroundColor:[UIColor clearColor]];
    [nickName setTextAlignment:NSTextAlignmentLeft];
    [nickName setTextColor:WXColorWithInteger(0x000000)];
    [nickName setFont:WXFont(16.0)];
    [headerView addSubview:nickName];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *nickNameStr = nil;
    if(userDefault.nickname){
        nickNameStr = [NSString stringWithFormat:@"%@",userDefault.nickname];
    }
    nickNameStr = [NSString stringWithFormat:@"(%@)",userDefault.wxtID];
    [nickName setText:nickNameStr];
    
    yOffset += labelHeight+14;
    moneyLabel = [[WXUILabel alloc] init];
    moneyLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [moneyLabel setBackgroundColor:[UIColor clearColor]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [moneyLabel setFont:WXFont(18.0)];
    [headerView addSubview:moneyLabel];
    
    [headerView setFrame:CGRectMake(0, 0, Size.width, headerViewHeight)];
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(WXUITableViewCell*)userCutSourceListCell:(NSInteger)row{
    static NSString *identifier = @"listCell";
    UserCutSourceListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserCutSourceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self userCutSourceListCell:row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
