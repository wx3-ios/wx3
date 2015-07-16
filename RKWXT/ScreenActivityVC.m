//
//  ScreenActivityVC.m
//  RKWXT
//
//  Created by SHB on 15/7/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ScreenActivityVC.h"
#import "LoginVC.h"

@interface ScreenActivityVC(){
    NSTimer *timer;
    UIImageView *splashImageView;
    WXUINavigationController *nav;
}
@end

@implementation ScreenActivityVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor grayColor]];
    
//    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView *view = [[UIView alloc] initWithFrame:appFrame];
//    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    self.view = view;
    
    splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
    splashImageView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:splashImageView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

-(void)fadeScreen{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedFading)];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)finishedFading{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.view.alpha = 1.0;
    [UIView commitAnimations];
    
    for(UIView *my in [self.view subviews]){
        if([my isKindOfClass:[UILabel class]]){
            [my removeFromSuperview];
        }
    }
    [splashImageView removeFromSuperview];
    
    LoginVC *loginVC = [[LoginVC alloc] init];
    WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
    [self.wxNavigationController presentViewController:navigationController animated:YES completion:^{
        [self.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
        }];
    }];
}

@end
