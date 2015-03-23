//
//  BaseVC.m
//  RKWXT
//
//  Created by SHB on 15/3/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseVC.h"
#import "WXWaitingHud.h"

#define kTopLayerZPosition 10000.0

@interface BaseVC (){
    WXWaitingHud *_hud;
    UIView *_baseView;
    UIActivityIndicatorView *_waitingView;
}

@end

@implementation BaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBgImg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem.title = @"返回";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hud = [[WXWaitingHud alloc] initWithParentView:self.view];
    [_hud setHidden:YES];
    [_hud setFrame:CGRectMake(0, IPHONE_STATUS_BAR_HEIGHT+44, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height-(IPHONE_STATUS_BAR_HEIGHT+44))];
}

-(void)createTopView:(NSString*)title{
    [self.navigationController setNavigationBarHidden:YES];
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 66);
    [imgView setImage:[UIImage imageNamed:@"TopBgImg.png"]];
    [self.view addSubview:imgView];
    
    CGFloat labelWidth = 150;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((IPHONE_SCREEN_WIDTH-labelWidth)/2, 35, labelWidth, 25);
    if(title){
        [label setText:title];
    }
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:WXTFont(20.0)];
    [label setTextColor:[UIColor whiteColor]];
    [self.view addSubview:label];
}

-(void)showWaitView:(UIView*)onView{
//    [_hud setHidden:NO];
//    [_hud startAnimate];
//    [self.view addSubview:_hud];
}

-(void)unShowWaitView{
//    [_hud stopAniamte];
//    [_hud setHidden:YES];
//    [_hud removeFromSuperview];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
