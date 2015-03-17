//
//  BaseViewController.m
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseViewController.h"
#import "WXTWaitingHud.h"
#define kTopLayerZPosition 10000.0

@interface BaseViewController (){
    WXTWaitingHud *_hud;
    //    UIView *_baseView;
    UIActivityIndicatorView *_waitingView;
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    //    _baseView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    [_baseView setHidden:YES];
    //    [_baseView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
    //    [self.view addSubview:_baseView];
    //
    //    _hud = [[WXTWaitingHud alloc] initWithParentView:self.view];
    //    [_hud setHidden:YES];
    //    [_hud setFrame:CGRectMake(0, 20+44, self.view.bounds.size.width, self.view.bounds.size.height-20-44)];
    ////    [_hud setFrame:self.view.bounds];
    //    [self.view addSubview:_hud];
    
    CGSize size = self.view.bounds.size;
    _waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _waitingView.frame = CGRectMake(0, 0, 100, 100);
    [_waitingView setCenter:CGPointMake(size.width*0.5, size.height*0.5)];
    [_waitingView.layer setZPosition:kTopLayerZPosition];
    [_waitingView setBackgroundColor:[UIColor clearColor]];
    [_waitingView setColor:[UIColor colorWithRed:16.0/255.0 green:209.0/255.0 blue:244.0/255.0 alpha:1.0]];
    [_waitingView setHidesWhenStopped:YES];
    [self.view addSubview:_waitingView];
}

-(void)showWaitViewMode:(E_WaiteView_Mode)mode tip:(NSString *)tip{
    //    [_hud setHidden:NO];
    //    [_hud setText:@"努力加载中"];
    //    [_hud startAnimate];
    [_waitingView startAnimating];
}

-(void)showWaitView{
    [_waitingView startAnimating];
}

-(void)unShowWaitView{
    //    [_hud stopAniamte];
    //    [_hud setHidden:YES];
    [_waitingView stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
