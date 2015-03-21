//
//  RootViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RootViewController.h"
#import "WXUITabBar.h"

#import "WXTMallVC.h"
#import "WXContacterVC.h"
#import "WXTFindVC.h"
#import "UserInfoVC.h"
@interface RootViewController ()

@end

@implementation RootViewController

-(id)init{
    WXUITabBarItem *t_homepage = [self createTabBarItem];
    [t_homepage setTabBarItemImage:[UIImage imageNamed:@"MallNormal.png"] forState:WXButtonControlState_Normal];
    [t_homepage setTabBarItemImage:[UIImage imageNamed:@"MallSelected.png"] forState:WXButtonControlState_Selected];
    [t_homepage setTabBarItemTitle:@"商城" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *keyPadItem = [self createTabBarItem];
    [keyPadItem setTabBarItemImage:[UIImage imageNamed:@"CallNormal.png"] forState:WXButtonControlState_Normal];
    [keyPadItem setTabBarItemImage:[UIImage imageNamed:@"CallSelected.png"] forState:WXButtonControlState_Selected];
    //    [keyPadItem setRepeatSelectedImage:[UIImage imageNamed:@"keyPadSelDown.png"]];
    [keyPadItem setTabBarItemTitle:@"通话" forState:WXButtonControlState_Normal];
    
    
    WXUITabBarItem *contacterItem = [self createTabBarItem];
    [contacterItem setTabBarItemImage:[UIImage imageNamed:@"FindNormal.png"] forState:WXButtonControlState_Normal];
    [contacterItem setTabBarItemImage:[UIImage imageNamed:@"FindSelected.png"] forState:WXButtonControlState_Selected];
    [contacterItem setTabBarItemTitle:@"发现" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *rechargeItem = [self createTabBarItem];
    [rechargeItem setTabBarItemImage:[UIImage imageNamed:@"UserNormal.png"] forState:WXButtonControlState_Normal];
    [rechargeItem setTabBarItemImage:[UIImage imageNamed:@"UserSelected.png"] forState:WXButtonControlState_Selected];
    [rechargeItem setTabBarItemTitle:@"我" forState:WXButtonControlState_Normal];
    
    wxTabBar = [[WXUITabBar alloc] init];
    [wxTabBar setTabBarItems:[NSArray arrayWithObjects:t_homepage,keyPadItem,contacterItem,rechargeItem, nil]];
    WXTMallVC *mallVC = [[WXTMallVC alloc] init];
    WXContacterVC *callview = [[WXContacterVC alloc]init];
    WXTFindVC *phoneView = [[WXTFindVC alloc]init];
    UserInfoVC *infoVC = [[UserInfoVC alloc] init];
    if (self = [super initWithControllers:[NSArray arrayWithObjects:mallVC,callview,phoneView, infoVC,nil] tabBar:wxTabBar]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)tabBarItemSize{
    return CGSizeMake(IPHONE_SCREEN_WIDTH/kTabBarItemNumber, kTabBarHeight);
}

- (WXUITabBarItem*)createTabBarItem{
    CGSize size = [self tabBarItemSize];
    WXUITabBarItem *itme = [WXUITabBarItem tabBarItem];
    [itme setFrame:CGRectMake(0, 0, size.width, size.height)];
//    [itme setTitleColor:kOtherColor(E_App_Other_Color_TabBarTitleNormal) forState:WXButtonControlState_Normal];
//    [itme setTitleColor:kOtherColor(E_App_Other_Color_TabBarTitleHighlight) forState:WXButtonControlState_Selected];
    return itme;
}

-(void)selectedAtIndex:(NSInteger)index{
    
}

- (void)repeatSelectedAtIndex:(NSInteger)index{
    
}

@end
