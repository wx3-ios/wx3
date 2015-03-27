//
//  WXTUITabBarController.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITabBarController.h"
#import "WXTFindVC.h"
#import "WXTMallViewController.h"
#import "WXTMallVC.h"
#import "UserInfoVC.h"
#import "ContactsCallViewController.h"
#import "CallViewController.h"
#import "ContactsViewController.h"

#define kTabBarHeight (50.0)
#define Size self.view.bounds.size

@interface WXTUITabBarController(){
    NSArray *views;
    UIView *tabBar;
    ContactsCallViewController * callview;
    CallViewController *recentCall;
}

@property (nonatomic,strong) UIButton *but;
@property (nonatomic,strong) UIButton *but0;
@property (nonatomic,strong) UIButton *but1;
@property (nonatomic,strong) UIButton *but2;

//@property (nonatomic,strong) WXTUIButton *callBtn;
//@property (nonatomic,strong) UIButton *delBtn;
@property (nonatomic,strong) UIView *downView;

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *label0;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@end

@implementation WXTUITabBarController
@synthesize but,but1,but2,but0,label,label0,label1,label2,downView;

-(id)init{
    self = [super init];
    if(self){
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification addObserver:self selector:@selector(inputNumber) name:InputNumber object:nil];
        [notification addObserver:self selector:@selector(delNumberToEnd) name:DelNumberToEnd object:nil];
        [notification addObserver:self selector:@selector(showDownView) name:ShowDownView object:nil];
        [notification addObserver:self selector:@selector(hideDownView) name:HideDownView object:nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    CGSize size = self.view.bounds.size;
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-kTabBarHeight, Size.width, kTabBarHeight)];
    tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBar];
    
    NSArray *qian = @[@"MallSelected.png",@"CallSelected.png",@"FindNormal.png",@"UserNormal.png"];
    NSArray *hou = @[@"MallNormal.png",@"CallNormal.png",@"FindSelected.png",@"UserSelected.png"];
    
    
    CGFloat ygap = 8;
    CGFloat btnGapHeight = 10;
    //第一个
    CGFloat xGap = Size.width/4;
    but = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, Size.width/4, kTabBarHeight/2+btnGapHeight)];
    [but setImage:[UIImage imageNamed:hou[0]] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:hou[0]] forState:UIControlStateHighlighted];
    but.tag = 0;
    [but addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, kTabBarHeight/2+ygap, Size.width/4, kTabBarHeight/2-btnGapHeight);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"商城"];
    [label setFont:WXTFont(12.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:WXColorWithInteger(0x808080)];
    [tabBar addSubview:label];
    
    //第二个
    label0 = [[UILabel alloc] init];
    label0.frame = CGRectMake(xGap, kTabBarHeight/2+ygap, Size.width/4, kTabBarHeight/2-btnGapHeight);
    [label0 setBackgroundColor:[UIColor clearColor]];
    [label0 setText:@"通话"];
    [label0 setFont:WXTFont(12.0)];
    [label0 setTextAlignment:NSTextAlignmentCenter];
    [label0 setTextColor:WXColorWithInteger(0x0c8bdf)];
    [tabBar addSubview:label0];
    
    but0 = [[UIButton alloc] initWithFrame:CGRectMake(xGap, 3, Size.width/4, kTabBarHeight/2+btnGapHeight)];
    [but0 setImage:[UIImage imageNamed:qian[1]] forState:UIControlStateNormal];
    [but0 setImage:[UIImage imageNamed:hou[1]] forState:UIControlStateHighlighted];
    but0.tag = 1;
    [but0 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but0];
    
    //第三个
    label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(2*xGap, kTabBarHeight/2+ygap, Size.width/4, kTabBarHeight/2-btnGapHeight);
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setText:@"发现"];
    [label1 setFont:WXTFont(12.0)];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:WXColorWithInteger(0x808080)];
    [tabBar addSubview:label1];
    
    but1 = [[UIButton alloc] initWithFrame:CGRectMake(2*xGap, 3, Size.width/4, kTabBarHeight/2+btnGapHeight)];
    [but1 setImage:[UIImage imageNamed:qian[2]] forState:UIControlStateNormal];
    [but1 setImage:[UIImage imageNamed:hou[2]] forState:UIControlStateHighlighted];
    but1.tag = 2;
    [but1 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but1];
    
    //第四个
    label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(3*xGap, kTabBarHeight/2+ygap, Size.width/4, kTabBarHeight/2-btnGapHeight);
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setText:@"我"];
    [label2 setFont:WXTFont(12.0)];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:WXColorWithInteger(0x808080)];
    [tabBar addSubview:label2];
    
    but2 = [[UIButton alloc] initWithFrame:CGRectMake(3*xGap, 3, Size.width/4, kTabBarHeight/2+btnGapHeight)];
    [but2 setImage:[UIImage imageNamed:qian[3]] forState:UIControlStateNormal];
    [but2 setImage:[UIImage imageNamed:hou[3]] forState:UIControlStateHighlighted];
    but2.tag = 3;
    [but2 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:but2];
    
    [self createDownView];
}

-(void)createDownView{
    downView = [[UIView alloc] init];
    downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
    [downView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [self.view addSubview:downView];
    
    WXTUIButton *keyboardBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    keyboardBtn.frame = CGRectMake(0, 5, Size.width/4, kTabBarHeight/2);
    [keyboardBtn setImage:[UIImage imageNamed:@"CallSelected.png"] forState:UIControlStateNormal];
    [keyboardBtn addTarget:self action:@selector(downviewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:keyboardBtn];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(0, kTabBarHeight/2, Size.width/4, kTabBarHeight/2);
    [textLabel setText:@"通话"];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:WXTFont(12.0)];
    [textLabel setTextColor:WXColorWithInteger(0x0c8bdf)];
    [downView addSubview:textLabel];
    
    WXTUIButton *callBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(Size.width/4, 0, Size.width/2, kTabBarHeight);
    [callBtn setImage:[UIImage imageNamed:@"CallBtnImg.png"] forState:UIControlStateNormal];
    [callBtn setBackgroundImageOfColor:WXColorWithInteger(0x2fbf62) controlState:UIControlStateNormal];
    [callBtn setBackgroundImageOfColor:WXColorWithInteger(0x0e8739) controlState:UIControlStateSelected];
    [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:callBtn];
    
//    WXTUIButton *delBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
//    delBtn.frame = CGRectMake(Size.width*3/4, 5, Size.width/4, kTabBarHeight/2);
//    [delBtn setBackgroundColor:[UIColor clearColor]];
//    [delBtn setImage:[UIImage imageNamed:@"delSel.png"] forState:UIControlStateNormal];
//    [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:delBtn];
//    
//    UILabel *textLabel1 = [[UILabel alloc] init];
//    textLabel1.frame = CGRectMake(Size.width*3/4, kTabBarHeight/2, Size.width/4, kTabBarHeight/2);
//    [textLabel1 setText:@"删除"];
//    [textLabel1 setBackgroundColor:[UIColor clearColor]];
//    [textLabel1 setTextAlignment:NSTextAlignmentCenter];
//    [textLabel1 setFont:WXTFont(12.0)];
//    [textLabel1 setTextColor:WXColorWithInteger(0x969696)];
//    [downView addSubview:textLabel1];
}

//收起键盘和底部
-(void)downviewBtnClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
    if(recentCall.downview_type == DownView_Del || recentCall.downview_type == DownView_Init){
        [UIView animateWithDuration:KeyboardDur animations:^{
            downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
        }];
    }
}

-(void)showDownView{
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height-kTabBarHeight, Size.width*3/4, kTabBarHeight);
    }];
}

-(void)hideDownView{
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
    }];
}

//键盘输入
-(void)inputNumber{
    if(recentCall.downview_type == DownView_show){
        return;
    }
    recentCall.downview_type = DownView_show;
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height-kTabBarHeight, Size.width*3/4, kTabBarHeight);
    }];
//    callview.segmentControl.hidden = YES;
}
//删除
//-(void)delBtnClicked{
//    [[NSNotificationCenter defaultCenter] postNotificationName:DelNumber object:nil];
//    if(recentCall.downview_type == DownView_Del){
//        [UIView animateWithDuration:KeyboardDur animations:^{
//            downView.frame = CGRectMake(0, Size.height, Size.width, kTabBarHeight);
//        }];
//    }
//}

-(void)delNumberToEnd{
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
    }];
}

-(void)keyboardBtnClicked{
   [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
  [UIView animateWithDuration:KeyboardDur animations:^{
       downView.frame = CGRectMake(0, Size.height-kTabBarHeight, Size.width*3/4, kTabBarHeight);
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
        [[NSNotificationCenter defaultCenter] postNotificationName:ClickedKeyboardBtn object:nil];
//        if(recentCall.downview_type == DownView_Del){
//            [UIView animateWithDuration:KeyboardDur animations:^{
//                downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
//            }];
//        }
//        if(recentCall.downview_type == DownView_show){
//            [UIView animateWithDuration:KeyboardDur animations:^{
//                downView.frame = CGRectMake(0, Size.height-kTabBarHeight, Size.width*3/4, kTabBarHeight);
//            }];
//        }
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
        [UIView animateWithDuration:KeyboardDur animations:^{
            downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
        }];
    }
}

//初始化子控制器
-(void)createViewController{
    WXTMallViewController * mallVC = [[WXTMallViewController alloc] init];
    callview = [[ContactsCallViewController alloc] init];
    WXTFindVC *phoneView = [[WXTFindVC alloc] init];
    UserInfoVC *infoVC = [[UserInfoVC alloc] init];
    views = [NSArray arrayWithObjects:mallVC,callview,phoneView,infoVC, nil];
    [self setViewControllers:views];
    [self setSelectedIndex:1];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
