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
#import "ContactsViewController.h"
#import "WXContacterVC.h"
#import "WXKeyPadVC.h"

#define kTabBarHeight (50.0)

@interface WXTUITabBarController(){
    NSArray *views;
    UIView *tabBar;
    WXTMallVC *recentCall;
}

@property (nonatomic,strong) UIButton *but;
@property (nonatomic,strong) UIButton *but0;
@property (nonatomic,strong) UIButton *but1;
@property (nonatomic,strong) UIButton *but2;

@property (nonatomic,strong) UIButton *callBtn;
@property (nonatomic,strong) UIButton *delBtn;

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *label0;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@end

@implementation WXTUITabBarController
@synthesize but,but1,but2,but0,label,label0,label1,label2,callBtn,delBtn;

-(id)init{
    self = [super init];
    if(self){
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification addObserver:self selector:@selector(inputNumber) name:InputNumber object:nil];
        [notification addObserver:self selector:@selector(delBtnClicked) name:DelNumber object:nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    CGSize size = self.view.bounds.size;
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-kTabBarHeight, IPHONE_SCREEN_WIDTH, kTabBarHeight)];
    tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBar];
    
    
    NSArray *qian = @[@"MallNormal.png",@"CallNormal.png",@"FindNormal.png",@"UserNormal.png"];
    NSArray *hou = @[@"MallSelected.png",@"CallSelected.png",@"FindSelected.png",@"UserSelected.png"];
    
    
    //第一个
    CGFloat xGap = IPHONE_SCREEN_WIDTH/4;
    but = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2)];
    [but setImage:[UIImage imageNamed:hou[0]] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:hou[0]] forState:UIControlStateHighlighted];
    but.tag = 0;
    [but addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, kTabBarHeight/2, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"商城"];
    [label setFont:WXTFont(12.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:WXColorWithInteger(0x0c8bdf)];
    [tabBar addSubview:label];
    
    //第二个
    label0 = [[UILabel alloc] init];
    label0.frame = CGRectMake(xGap, kTabBarHeight/2, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2);
    [label0 setBackgroundColor:[UIColor clearColor]];
    [label0 setText:@"通话"];
    [label0 setFont:WXTFont(12.0)];
    [label0 setTextAlignment:NSTextAlignmentCenter];
    [label0 setTextColor:WXColorWithInteger(0x808080)];
    [tabBar addSubview:label0];
    
    but0 = [[UIButton alloc] initWithFrame:CGRectMake(xGap, 5, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2)];
    [but0 setImage:[UIImage imageNamed:qian[1]] forState:UIControlStateNormal];
    [but0 setImage:[UIImage imageNamed:hou[1]] forState:UIControlStateHighlighted];
    but0.tag = 1;
    [but0 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but0];
    
    //第三个
    label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(2*xGap, kTabBarHeight/2, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2);
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setText:@"发现"];
    [label1 setFont:WXTFont(12.0)];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:WXColorWithInteger(0x808080)];
    [tabBar addSubview:label1];
    
    but1 = [[UIButton alloc] initWithFrame:CGRectMake(2*xGap, 5, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2)];
    [but1 setImage:[UIImage imageNamed:qian[2]] forState:UIControlStateNormal];
    [but1 setImage:[UIImage imageNamed:hou[2]] forState:UIControlStateHighlighted];
    but1.tag = 2;
    [but1 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but1];
    
    //第四个
    label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(3*xGap, kTabBarHeight/2, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2);
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setText:@"我"];
    [label2 setFont:WXTFont(12.0)];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:WXColorWithInteger(0x808080)];
    [tabBar addSubview:label2];
    
    but2 = [[UIButton alloc] initWithFrame:CGRectMake(3*xGap, 5, IPHONE_SCREEN_WIDTH/4, kTabBarHeight/2)];
    [but2 setImage:[UIImage imageNamed:qian[3]] forState:UIControlStateNormal];
    [but2 setImage:[UIImage imageNamed:hou[3]] forState:UIControlStateHighlighted];
    but2.tag = 3;
    [but2 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but2];
    
    
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/4, kTabBarHeight);
    [delBtn setBackgroundColor:[UIColor whiteColor]];
    [delBtn setImage:[UIImage imageNamed:@"CallSelected.png"] forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(keyboardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delBtn];
    
    callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/4, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/2, kTabBarHeight);
    [callBtn setBackgroundColor:[UIColor purpleColor]];
    [callBtn setTitle:@"呼叫" forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
}

-(void)inputNumber{
    if(recentCall.downview_type == DownView_show){
        return;
    }
    recentCall.downview_type = DownView_show;
    [UIView animateWithDuration:KeyboardDur animations:^{
        callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/4, IPHONE_SCREEN_HEIGHT-kTabBarHeight, IPHONE_SCREEN_WIDTH/2, kTabBarHeight);
        delBtn.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-kTabBarHeight, IPHONE_SCREEN_WIDTH/4, kTabBarHeight);
    }];
}

-(void)delBtnClicked{
    if(recentCall.downview_type == DownView_Del){
        [UIView animateWithDuration:KeyboardDur animations:^{
            callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/4, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/2, kTabBarHeight);
            delBtn.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/4, kTabBarHeight);
        }];
    }
}

-(void)keyboardBtnClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
    [UIView animateWithDuration:KeyboardDur animations:^{
        callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/4, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/2, kTabBarHeight);
        delBtn.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/4, kTabBarHeight);
    }];
}

-(void)callBtnClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:CallPhone object:nil];
}

- (void)selectedTab:(UIButton *)button{
    self.selectedIndex = button.tag;
    if(button.tag == 0){
        [but setImage:[UIImage imageNamed:@"MallSelected.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallNormal.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindNormal.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserNormal.png"] forState:UIControlStateNormal];
        [label setTextColor:WXColorWithInteger(0x0c8bdf)];
        [label0 setTextColor:WXColorWithInteger(0x808080)];
        [label1 setTextColor:WXColorWithInteger(0x808080)];
        [label2 setTextColor:WXColorWithInteger(0x808080)];
    }
    
    if(button.tag == 1){
        [but setImage:[UIImage imageNamed:@"MallNormal.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallSelected.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindNormal.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserNormal.png"] forState:UIControlStateNormal];
        [label setTextColor:WXColorWithInteger(0x808080)];
        [label0 setTextColor:WXColorWithInteger(0x0c8bdf)];
        [label1 setTextColor:WXColorWithInteger(0x808080)];
        [label2 setTextColor:WXColorWithInteger(0x808080)];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
        if(recentCall.downview_type == DownView_Del){
            [UIView animateWithDuration:KeyboardDur animations:^{
                callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/4, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/2, kTabBarHeight);
                delBtn.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH/4, kTabBarHeight);
            }];
        }
        if(recentCall.downview_type == DownView_show){
            [UIView animateWithDuration:KeyboardDur animations:^{
                callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/4, IPHONE_SCREEN_HEIGHT-kTabBarHeight, IPHONE_SCREEN_WIDTH/2, kTabBarHeight);
                delBtn.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-kTabBarHeight, IPHONE_SCREEN_WIDTH/4, kTabBarHeight);
            }];
        }
    }
    
    if(button.tag == 2){
        [but setImage:[UIImage imageNamed:@"MallNormal.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallNormal.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindSelected.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserNormal.png"] forState:UIControlStateNormal];
        [label setTextColor:WXColorWithInteger(0x808080)];
        [label0 setTextColor:WXColorWithInteger(0x808080)];
        [label1 setTextColor:WXColorWithInteger(0x0c8bdf)];
        [label2 setTextColor:WXColorWithInteger(0x808080)];
    }
    
    if(button.tag == 3){
        [but setImage:[UIImage imageNamed:@"MallNormal.png"] forState:UIControlStateNormal];
        [but0 setImage:[UIImage imageNamed:@"CallNormal.png"] forState:UIControlStateNormal];
        [but1 setImage:[UIImage imageNamed:@"FindNormal.png"] forState:UIControlStateNormal];
        [but2 setImage:[UIImage imageNamed:@"UserSelected.png"] forState:UIControlStateNormal];
        [label setTextColor:WXColorWithInteger(0x808080)];
        [label0 setTextColor:WXColorWithInteger(0x808080)];
        [label1 setTextColor:WXColorWithInteger(0x808080)];
        [label2 setTextColor:WXColorWithInteger(0x0c8bdf)];
    }
}

//初始化子控制器
-(void)createViewController{
    recentCall = [[WXTMallVC alloc] init];
    WXContacterVC *callview = [[WXContacterVC alloc] init];
    WXTFindVC *phoneView = [[WXTFindVC alloc] init];
    UserInfoVC *infoVC = [[UserInfoVC alloc] init];
    views = [NSArray arrayWithObjects:callview,recentCall,phoneView,infoVC, nil];
    [self setViewControllers:views];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//- (void)setTabBarHidden:(BOOL)hidden aniamted:(BOOL)animated completion:(void (^)(void))completion{
//    CGSize size = self.bounds.size;
//    CGFloat tabBarHeight = _tabBar.bounds.size.height;
//    
//    CGRect viewRect = self.bounds;
//    CGRect tabBarRect = _tabBar.bounds;
//    if(hidden){
//        tabBarRect.origin.y = size.height;
//    }else{
//        tabBarRect.origin.y = size.height - tabBarHeight;
//        viewRect.size.height -= tabBarHeight;
//    }
//    if(animated){
//        [UIView animateWithDuration:kWXUITabBarAnimatedDuration animations:^{
//            for(UIViewController *vc in self.childViewControllers){
//                [vc.view setFrame:viewRect];
//            }
//            [_tabBar setFrame:tabBarRect];
//        } completion:^(BOOL finished) {
//            completion();
//        }];
//    }else{
//        for(UIViewController *vc in self.childViewControllers){
//            [vc.view setFrame:viewRect];
//        }
//        [_tabBar setFrame:tabBarRect];
//        completion();
//    }
//    
//}

@end
