//
//  BonusOverdueVC.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BonusOverdueVC.h"
#import "OverdueCell.h"
#import "UserBonusModel.h"

@interface BonusOverdueVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *denyBonusArr;
}
@end

@implementation BonusOverdueVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    denyBonusArr = [UserBonusModel shareUserBonusModel].denyBonusArr;
    if(_tableView){
        [_tableView reloadData];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 1, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadBonusSucceed) name:K_Notification_UserBonus_LoadDateSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadBonusFailed:) name:K_Notification_UserBonus_LoadDateFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(gainBonusSucceed) name:K_Notification_UserBonus_GainBonusSucceed object:nil];
}

-(void)removeObs{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [denyBonusArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(WXUITableViewCell *)tableViewForReceiveCell:(NSInteger)row{
    static NSString *identifier = @"receiveCell";
    OverdueCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OverdueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[denyBonusArr objectAtIndex:row]];
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

#pragma mark userbonus
-(void)loadBonusSucceed{
    [self unShowWaitView];
    denyBonusArr = [UserBonusModel shareUserBonusModel].denyBonusArr;
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
-(void)gainBonusSucceed{
    [self unShowWaitView];
    denyBonusArr = [UserBonusModel shareUserBonusModel].denyBonusArr;
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeObs];
}

@end