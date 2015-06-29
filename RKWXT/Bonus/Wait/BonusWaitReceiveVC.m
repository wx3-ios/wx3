//
//  BonusWaitReceiveVC.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BonusWaitReceiveVC.h"
#import "WaitReceiveCell.h"
#import "UserBonusModel.h"
#import "UserBonusEntity.h"

@interface BonusWaitReceiveVC()<UITableViewDataSource,UITableViewDelegate,ReceiveBonusDelegate>{
    UITableView *_tableView;
    NSArray *userBonusArr;
}
@end

@implementation BonusWaitReceiveVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addObs];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self]; 
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    BOOL shouldLoad = [[UserBonusModel shareUserBonusModel] shouldDataReload];
    if(shouldLoad){
        [[UserBonusModel shareUserBonusModel] loadUserBonus];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }else{
        userBonusArr = [UserBonusModel shareUserBonusModel].userBonusArr;
    }
}

-(void)addObs{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadBonusSucceed) name:K_Notification_UserBonus_LoadDateSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadBonusFailed:) name:K_Notification_UserBonus_LoadDateFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(gainBonusSucceed) name:K_Notification_UserBonus_GainBonusSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(gainBonusFailed:) name:K_Notification_UserBonus_GainBonusFailed object:nil];
}

-(void)removeObs{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [userBonusArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(WXUITableViewCell *)tableViewForReceiveCell:(NSInteger)row{
    static NSString *identifier = @"receiveCell";
    WaitReceiveCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    if([userBonusArr count] > 0){
        [cell setCellInfo:[userBonusArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForReceiveCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 获取红包
-(void)loadBonusSucceed{
    [self unShowWaitView];
    userBonusArr = [UserBonusModel shareUserBonusModel].userBonusArr;
    [_tableView reloadData];
}

-(void)loadBonusFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"获取红包数据失败";
    }
    [UtilTool showAlertView:message];
}

#pragma mark 领取红包
-(void)receiveBonus:(id)sender{
    UserBonusEntity *entity = sender;
    [[UserBonusModel shareUserBonusModel] gainUserBonus:entity.bonusID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)gainBonusSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"红包领取成功"];
    userBonusArr = [UserBonusModel shareUserBonusModel].userBonusArr;
    [_tableView reloadData];
}

-(void)gainBonusFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"获取红包数据失败";
    }
    [UtilTool showAlertView:message];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeObs];
}

@end
