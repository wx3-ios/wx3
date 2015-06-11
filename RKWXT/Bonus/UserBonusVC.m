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

enum{
    Bonus_Status_WaitReceive = 0,
    Bonus_Status_Overdue,
    
    Bonus_Status_Invalid,
};

@interface UserBonusVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}
@end

@implementation UserBonusVC

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
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"已过期" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
    
    [self.view addSubview:[self rightBtn]];
}

-(WXUIButton*)rightBtn{
    CGFloat xgap = 8;
    CGFloat btnWidth = 70;
    CGFloat btnHeight = 16;
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.bounds.size.width-xgap-btnWidth, 35, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"使用规则" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WXColorWithInteger(0xff9d9b) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(toUseBonusRule) forControlEvents:UIControlEventTouchUpInside];
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

-(void)toUseBonusRule{
    
}

@end
