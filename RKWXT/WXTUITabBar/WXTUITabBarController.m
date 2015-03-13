//
//  WXTUITabBarController.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITabBarController.h"
#import "WXTFindVC.h"
#import "WXTMallVC.h"
#import "UserInfoVC.h"
#import "CallVC.h"

#define kTabBarHeight (47.0)

@interface WXTUITabBarController(){
    NSArray *views;
    UIView *tabBar;
    CGFloat yOffset;
}
@property (nonatomic,strong) UIButton *but;
@property (nonatomic,strong) UIButton *but0;
@property (nonatomic,strong) UIButton *but1;
@property (nonatomic,strong) UIButton *but2;
@property (nonatomic,strong) UIButton *btn3;
@property (nonatomic,retain) UILabel *label_blue;
@property (nonatomic,retain) UIButton *button_backLogin1;
@end

@implementation WXTUITabBarController
@synthesize but,but1,but2,label_blue,button_backLogin1,but0,btn3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!isIOS7){
        //        yOffset = IPHONE_STATUS_BAR_HEIGHT;
    }
    
    [self createTabBar];
}

-(void)createTabBar
{
    CGSize size = self.view.bounds.size;
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-kTabBarHeight -yOffset, IPHONE_SCREEN_WIDTH, kTabBarHeight)];
    tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBar];
    
//    UILabel *labe = [[UILabel alloc] init];
//    labe.backgroundColor = [UIColor grayColor];
//    labe.frame = CGRectMake(0, size.height-kTabBarHeight-yOffset, IPHONE_SCREEN_WIDTH, 1);
//    [self.view addSubview:labe];
    
    NSArray *qian = @[@"MallNormal.png",@"CallNormal.png",@"FindNormal.png",@"UserNormal.png"];
    NSArray *hou = @[@"MallSelected.png",@"CallSelected.png",@"FindSelected.png",@"UserSelected.png"];
    
    CGFloat xGap = IPHONE_SCREEN_WIDTH/4;
    but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH/4, kTabBarHeight)];
    [but setImage:[UIImage imageNamed:hou[0]] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:hou[0]] forState:UIControlStateHighlighted];
    but.tag = 0;
    [but addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but];
    
    but0 = [[UIButton alloc] initWithFrame:CGRectMake(xGap, 0, IPHONE_SCREEN_WIDTH/4, kTabBarHeight)];
    [but0 setImage:[UIImage imageNamed:qian[1]] forState:UIControlStateNormal];
    [but0 setImage:[UIImage imageNamed:hou[1]] forState:UIControlStateHighlighted];
    but0.tag = 1;
    [but0 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but0];
    
    but1 = [[UIButton alloc] initWithFrame:CGRectMake(2*xGap, 0, IPHONE_SCREEN_WIDTH/4, kTabBarHeight)];
    [but1 setImage:[UIImage imageNamed:qian[2]] forState:UIControlStateNormal];
    [but1 setImage:[UIImage imageNamed:hou[2]] forState:UIControlStateHighlighted];
    but1.tag = 2;
    [but1 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but1];
    
    but2 = [[UIButton alloc] initWithFrame:CGRectMake(3*xGap, 0, IPHONE_SCREEN_WIDTH/4, kTabBarHeight)];
    [but2 setImage:[UIImage imageNamed:qian[3]] forState:UIControlStateNormal];
    [but2 setImage:[UIImage imageNamed:hou[3]] forState:UIControlStateHighlighted];
    but2.tag = 3;
    [but2 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but2];
    
//    label_blue = [[UILabel alloc] init];
//    label_blue.frame = CGRectMake(0, size.height-kTabBarHeight-yOffset-2, 107, 2);
//    label_blue.backgroundColor = [UIColor colorWithRed:0/255.0f green:196.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
//    [self.view addSubview:label_blue];
}

- (void)selectedTab:(UIButton *)button{
    self.selectedIndex = button.tag;
    if(button.tag == 0){
//        label_blue.frame = CGRectMake(0, size.height-kTabBarHeight-2, 107, 2);
        [but setImage:[UIImage imageNamed:@"MallSelected.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallNormal.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindNormal.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserNormal.png"] forState:UIControlStateNormal];
    }
    
    if(button.tag == 1){
//        label_blue.frame = CGRectMake(106, size.height-kTabBarHeight-2, 108, 2);
        [but setImage:[UIImage imageNamed:@"MallNormal.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallSelected.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindNormal.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserNormal.png"] forState:UIControlStateNormal];
    }
    
    if(button.tag == 2){
//        label_blue.frame = CGRectMake(215, size.height-kTabBarHeight-2, 107, 2);
        [but setImage:[UIImage imageNamed:@"MallNormal.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallNormal.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindSelected.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserNormal.png"] forState:UIControlStateNormal];
    }
    
    if(button.tag == 3){
//        label_blue.frame = CGRectMake(215, size.height-kTabBarHeight-2, 107, 2);
        [but setImage:[UIImage imageNamed:@"MallNormal.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallNormal.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindNormal.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserSelected.png"] forState:UIControlStateNormal];
    }
}

//初始化子控制器
-(void)createViewController{
    WXTMallVC *recentCall = [[WXTMallVC alloc] init];
    CallVC *callview = [[CallVC alloc]init];
    WXTFindVC *phoneView = [[WXTFindVC alloc]init];
    UserInfoVC *infoVC = [[UserInfoVC alloc] init];
    views = [NSArray arrayWithObjects:recentCall,callview,phoneView,infoVC, nil];
    [self setViewControllers:views];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
