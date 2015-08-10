//
//  UserCutVC.m
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserCutVC.h"
#import "UserCutCell.h"
#import "UserCutModel.h"

#define Size self.bounds.size

@interface UserCutVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    WXUILabel *_bigMoney;
    WXUILabel *_smallMoney;
    
    NSArray *listArr;
}

@end

@implementation UserCutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的提成"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableviewForHeadView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [[UserCutModel shareUserCutBalanceModel] loadUserCutBalance];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadUserCutbalanceSucceed) name:K_Notification_Name_UserCut_LoadSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadUserCutbalanceFailed:) name:K_Notification_Name_UserCut_LoadFailed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView*)tableviewForHeadView{
    UIView *headView = [[UIView alloc] init];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yOffset = 27;
    CGFloat bigHeight = 40;
    _bigMoney = [[WXUILabel alloc] init];
    _bigMoney.frame = CGRectMake(0, yOffset, Size.width, bigHeight);
    [_bigMoney setBackgroundColor:[UIColor clearColor]];
    [_bigMoney setFont:WXFont(41.0)];
    [_bigMoney setText:@"0.00"];
    [_bigMoney setTextAlignment:NSTextAlignmentCenter];
    [_bigMoney setTextColor:WXColorWithInteger(0xf36f25)];
    [headView addSubview:_bigMoney];
    
    yOffset += bigHeight+10;
    CGFloat btnWidth = 140;
    CGFloat btnHeight = 20;
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [button setBackgroundColor:[UIColor clearColor]];
    [button setImage:[UIImage imageNamed:@"UserCut.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitle:@"账户安全保障中" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 10)];
    [button setTitleColor:WXColorWithInteger(0x59b904) forState:UIControlStateNormal];
    [button setEnabled:NO];
    [button.titleLabel setFont:WXFont(12.0)];
    [headView addSubview:button];
    
    yOffset = 130;
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [line setBackgroundColor:WXColorWithInteger(0xcfcfcf)];
    [headView addSubview:line];
    
    yOffset += 15;
    CGFloat smallWidth = 80;
    CGFloat smallHeight = 20;
    _smallMoney = [[WXUILabel alloc] init];
    _smallMoney.frame = CGRectMake((Size.width-smallWidth)/2, yOffset, smallWidth, smallHeight);
    [_smallMoney setBackgroundColor:[UIColor clearColor]];
    [_smallMoney setText:@"0.00"];
    [_smallMoney setTextAlignment:NSTextAlignmentCenter];
    [_smallMoney setFont:WXFont(15.0)];
    [_smallMoney setTextColor:WXColorWithInteger(0x000000)];
    [headView addSubview:_smallMoney];
    
    yOffset += smallHeight;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-smallWidth)/2, yOffset, smallWidth, smallHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"余额"];
    [textLabel setTextColor:WXColorWithInteger(0x828282)];
    [textLabel setFont:WXFont(11.0)];
    [headView addSubview:textLabel];
    
    headView.frame = CGRectMake(0, 0, Size.width, 196);
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UserCutCellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    [headView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat xOffset = 10;
    CGFloat yOffset = 18;
    UILabel *text = [[UILabel alloc] init];
    text.frame = CGRectMake(xOffset, yOffset, 120, 18);
    [text setBackgroundColor:[UIColor clearColor]];
    [text setTextAlignment:NSTextAlignmentLeft];
    [text setText:@"我的提成"];
    [text setTextColor:WXColorWithInteger(0x000000)];
    [text setFont:WXFont(15.0)];
    [headView addSubview:text];
    
    headView.frame = CGRectMake(0, 0, Size.width, 42);
    return headView;
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }

    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(WXUITableViewCell*)tableViewForUserCutCellAtRow:(NSInteger)row{
    static NSString *identifier = @"cutCell";
    UserCutCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserCutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setCellInfo:[listArr objectAtIndex:row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForUserCutCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark userCut
-(void)loadUserCutbalanceSucceed{
    [self unShowWaitView];
    listArr = [UserCutModel shareUserCutBalanceModel].userCutBalance;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",[UserCutModel shareUserCutBalanceModel].cutMoney];
    [_bigMoney setText:moneyStr];
    [_smallMoney setText:moneyStr];
}

-(void)loadUserCutbalanceFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"获取数据失败";
    }
    [UtilTool showAlertView:message];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
