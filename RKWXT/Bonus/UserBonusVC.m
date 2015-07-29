//
//  UserBonusVC.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserBonusVC.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "BonusWaitReceiveVC.h"
#import "BonusOverdueVC.h"

#import "UserBonusModel.h"

enum{
    Bonus_Status_WaitReceive = 0,
    Bonus_Status_Overdue,
    
    Bonus_Status_Invalid,
};

@interface UserBonusVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
    WXUIButton *rightBtn;
}
@end

@implementation UserBonusVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我的红包"];
    
    tabedSlideView = [[DLTabedSlideView alloc] init];
    tabedSlideView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [tabedSlideView setDelegate:self];
    
    [tabedSlideView setBaseViewController:self];
    [tabedSlideView setTabItemNormalColor:WXColorWithInteger(0x646464)];
    [tabedSlideView setTabItemSelectedColor:WXColorWithInteger(0xdd2726)];
    [tabedSlideView setTabbarTrackColor:[UIColor redColor]];
    [tabedSlideView setTabbarBottomSpacing:3.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"可领取" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"不可领取" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
    
    [self.view addSubview:[self rightBtn]];
    
    [self addOBS];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadUserBonusSucceed) name:K_Notification_UserBonus_UserBonusSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadUserBonusFailed:) name:K_Notification_UserBonus_UserBonusFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(changeUserBonusMoney) name:K_Notification_UserBonus_ChangeBonusValue object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(WXUIButton*)rightBtn{
    CGFloat xgap = 8;
    CGFloat btnWidth = 70;
    CGFloat btnHeight = 16;
    rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.bounds.size.width-xgap-btnWidth, 35, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"获取余额" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(toUseBonusRule) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *moneyStr = [NSString stringWithFormat:@"红包:%ld元",(long)[UserBonusModel shareUserBonusModel].bonusMoney];
    if([UserBonusModel shareUserBonusModel].bonusMoney > 0){
        [rightBtn setTitle:moneyStr forState:UIControlStateNormal];
    }
    return rightBtn;
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case Bonus_Status_WaitReceive:
        {
            BonusWaitReceiveVC *listAll = [[BonusWaitReceiveVC alloc] init];
            return listAll;
        }
            break;
        case Bonus_Status_Overdue:
        {
            BonusOverdueVC *overdueVC = [[BonusOverdueVC alloc] init];
            return overdueVC;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)changeUserBonusMoney{
    NSString *moneyStr = [NSString stringWithFormat:@"红包:%ld元",(long)[UserBonusModel shareUserBonusModel].bonusMoney];
    if([UserBonusModel shareUserBonusModel].bonusMoney > 0){
        [rightBtn setTitle:moneyStr forState:UIControlStateNormal];
    }else{
        [rightBtn setTitle:@"0元" forState:UIControlStateNormal];
    }
}

-(void)loadUserBonusSucceed{
    [self unShowWaitView];
    NSString *moneyStr = [NSString stringWithFormat:@"红包:%ld元",(long)[UserBonusModel shareUserBonusModel].bonusMoney];
    if([UserBonusModel shareUserBonusModel].bonusMoney > 0){
        [rightBtn setTitle:moneyStr forState:UIControlStateNormal];
    }else{
        [rightBtn setTitle:@"0元" forState:UIControlStateNormal];
    }
}

-(void)loadUserBonusFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *msg = notification.object;
    if(!msg){
        msg = @"获取红包余额失败";
    }
    [UtilTool showAlertView:msg];
}

-(void)toUseBonusRule{
    [[UserBonusModel shareUserBonusModel] loadUserBonusMoney];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
