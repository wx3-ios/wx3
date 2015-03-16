//
//  BaseVC.m
//  RKWXT
//
//  Created by SHB on 15/3/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseVC.h"
#import "WXTWaitingHud.h"

#define kTopLayerZPosition 10000.0

@interface BaseVC (){
    WXTWaitingHud *_hud;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    _hud = [[WXTWaitingHud alloc] initWithParentView:self.view];
    [_hud setHidden:YES];
    [_hud setFrame:CGRectMake(0, IPHONE_STATUS_BAR_HEIGHT+44, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height-(IPHONE_STATUS_BAR_HEIGHT+44))];
}

-(void)showWaitViewMode:(E_WaiteView_Mode)mode tip:(NSString *)tip{
}

-(void)showWaitView:(UIView*)onView{
    [_hud setHidden:NO];
    [_hud startAnimate];
    [self.view addSubview:_hud];
}

-(void)unShowWaitView{
    [_hud stopAniamte];
    [_hud setHidden:YES];
    [_hud removeFromSuperview];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
