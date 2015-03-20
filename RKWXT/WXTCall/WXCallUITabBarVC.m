//
//  WXCallUITabBarVC.m
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//


#define kTabBarHeight (kBtnHeight)
#define kTabBarItemNumber (4)

#import "WXCallUITabBarVC.h"

#import "WXContacterVC.h"
#import "WXKeyPadVC.h"
//#import "WXCallHistoryVC.h"
//#import "WXMessageChatVC.h"
//#import "RechargeCenterVC.h"
#import "WXTMallVC.h"
#import "WXContacterVC.h"
#import "WXTFindVC.h"
#import "WXColorConfig.h"

//#import "NewHomePageVC.h"
//#import "T_PersonalInfoVC.h"
//#import "T_FindVC.h"

enum{
    E_TabBarIndex_KeyPad = 0,
};

@interface WXCallUITabBarVC ()
{
    WXKeyPadVC *_keyPadVC;
}
@end

@implementation WXCallUITabBarVC

- (void)dealloc{
//    [super dealloc];
}

- (id)init{
    WXTMallVC *callHistoryVC = [[WXTMallVC alloc] init] ;
    WXContacterVC *messageChatVC = [[WXContacterVC alloc] init];
    WXTFindVC *rechargeVC = [[WXTFindVC alloc] init];
    WXContacterVC *contacterVC = [[WXContacterVC alloc] init] ;
//    NewHomePageVC *newHomeVC = [NewHomePageVC sharedHomePageVC];
//    _keyPadVC = [[WXKeyPadVC alloc] init];
//    T_FindVC *findVC = [[[T_FindVC alloc] init] autorelease];
//    T_PersonalInfoVC *personalInfoVC = [[T_PersonalInfoVC alloc] init] ;
    
    WXUITabBarItem *t_homepage = [self createTabBarItem];
    [t_homepage setTabBarItemImage:[UIImage imageNamed:@"MallNormal.png"] forState:WXButtonControlState_Normal];
    [t_homepage setTabBarItemImage:[UIImage imageNamed:@"MallSelected.png"] forState:WXButtonControlState_Selected];
    [t_homepage setTabBarItemTitle:@"首页" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *keyPadItem = [self createTabBarItem];
    [keyPadItem setTabBarItemImage:[UIImage imageNamed:@"CallNormal.png"] forState:WXButtonControlState_Normal];
    [keyPadItem setTabBarItemImage:[UIImage imageNamed:@"CallSelected.png"] forState:WXButtonControlState_Selected];
//    [keyPadItem setRepeatSelectedImage:[UIImage imageNamed:@"keyPadSelDown.png"]];
    [keyPadItem setTabBarItemTitle:@"通话" forState:WXButtonControlState_Normal];
    
//    WXUITabBarItem *chatItem = [self createTabBarItem];
//    [chatItem setTabBarItemImage:[UIImage imageNamed:@"chatNor.png"] forState:WXButtonControlState_Normal];
//    [chatItem setTabBarItemImage:[UIImage imageNamed:@"chatSel.png"] forState:WXButtonControlState_Selected];
//    [chatItem setTabBarItemTitle:@"聊天" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *contacterItem = [self createTabBarItem];
    [contacterItem setTabBarItemImage:[UIImage imageNamed:@"FindNormal.png"] forState:WXButtonControlState_Normal];
    [contacterItem setTabBarItemImage:[UIImage imageNamed:@"FindSelected.png"] forState:WXButtonControlState_Selected];
    [contacterItem setTabBarItemTitle:@"发现" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *rechargeItem = [self createTabBarItem];
    [rechargeItem setTabBarItemImage:[UIImage imageNamed:@"UserNormal.png"] forState:WXButtonControlState_Normal];
    [rechargeItem setTabBarItemImage:[UIImage imageNamed:@"UserSelected.png"] forState:WXButtonControlState_Selected];
    [rechargeItem setTabBarItemTitle:@"我" forState:WXButtonControlState_Normal];
    
    WXUITabBar *tabBar = [[WXUITabBar alloc] initWithTabBarHeight:kTabBarHeight] ;
//    WXUITabBar *tabBar = [[WXUITabBar alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)] ;
    [tabBar setTabBarItems:[NSArray arrayWithObjects:t_homepage,keyPadItem,contacterItem,rechargeItem, nil]];
    [tabBar setBackgroundColor:kOtherColor(E_App_Other_Color_TabBar)];
    
    #warning 这个结构不好~ 不应该这么写~
    if(self = [super initWithControllers:
               [NSArray arrayWithObjects:callHistoryVC,messageChatVC,rechargeVC,contacterVC, nil] tabBar:tabBar]){
        
    }
    return self;
}

- (WXUITabBarItem*)keyPadBarItem{
    WXUITabBar *tabBar = self.tabBar;
    WXUITabBarItem *item = [tabBar.tabBarItemArray objectAtIndex:E_TabBarIndex_KeyPad];
    return item;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self selectedAtIndex:E_TabBarIndex_KeyPad];
    //滑动的灵敏度弄低点~
    [self setDexterity:E_Slide_Dexterity_Low];
}

- (CGSize)tabBarItemSize{
    return CGSizeMake(ScreenWidth/kTabBarItemNumber, kTabBarHeight);
}

- (WXUITabBarItem*)createTabBarItem{
    CGSize size = [self tabBarItemSize];
    WXUITabBarItem *itme = [WXUITabBarItem tabBarItem];
    [itme setFrame:CGRectMake(0, ScreenHeight - kTabBarHeight, size.width, size.height)];
    [itme setTitleColor:kOtherColor(E_App_Other_Color_TabBarTitleNormal) forState:WXButtonControlState_Normal];
    [itme setTitleColor:kOtherColor(E_App_Other_Color_TabBarTitleHighlight) forState:WXButtonControlState_Selected];
    return itme;
}

#pragma mark 对键盘的处理~ 不好的结构~
- (void)selectedAtIndex:(NSInteger)index{
    [super selectedAtIndex:index];
    if(E_TabBarIndex_KeyPad == index){
        [_keyPadVC showKeyBoardStatus:E_KeyPad_Form_PartUp animated:NO];
    }
}

- (void)repeatSelectedAtIndex:(NSInteger)index{
    [super repeatSelectedAtIndex:index];
    if(index == E_TabBarIndex_KeyPad){
        WXUITabBarItem *item = [self keyPadBarItem];
        switch (item.status) {
            case E_TabBarStatus_DoubleSelected:
                [_keyPadVC showKeyBoardStatus:E_KeyPad_Form_Down animated:YES];
                break;
            case E_TabBarStatus_SingleSelected:
                [_keyPadVC upKeyBoardButtonClicked];
                break;
            default:
                break;
        }
    }
}

- (void)keyBoardHasDown{
    WXUITabBarItem *item = [self keyPadBarItem];
    [item setStatus:E_TabBarStatus_DoubleSelected];
}

@end
