//
//  WXUIViewController.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIViewController.h"
#import "ServiceCommon.h"
#import "YRSideViewController.h"
#import "NetTipDelay.h"
#import "WXWaitingHud.h"

#define kAnimatedDur 0.3
#define kTopLayerZPosition 10000.0
#define kNetWorkTipHeight (20.0)
@interface WXUIViewController ()<UIGestureRecognizerDelegate>
{
    //纯粹提示
    WXUIActivityIndicatorView *_waitingView;
    //导航栏还可以点击
    WXWaitingHud *_hud;
    //全频阻塞
    WXWaitingHud *_fullScreenHud;
    
    CSTWXNavigationView *_cstNavigationView;
    WXUIView *_baseView;
    WXUIImageView *_bgImageView;
    WXUIView *_netTipView;
}
@end

@implementation WXUIViewController
@synthesize cstNavigationView = _cstNavigationView;
@synthesize baseView = _baseView;
@synthesize openKeyboardNotification = _openKeyboardNotification;

- (void)dealloc{
    RELEASE_SAFELY(_waitingView);
    RELEASE_SAFELY(_hud);
    [self showFullScreenHud:NO withTip:nil];
    RELEASE_SAFELY(_fullScreenHud);
    RELEASE_SAFELY(_baseView);
    RELEASE_SAFELY(_cstNavigationView);
    RELEASE_SAFELY(_bgImageView);
    RELEASE_SAFELY(_netTipView);
    [self removeServiceOBS];
    [self removeKeyboardNotification];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _baseView = [[WXUIView alloc] initWithFrame:self.view.bounds];
    [_baseView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
    [self.view addSubview:_baseView];
    //如果是tabBarVC的话则不显示导航栏~
    if(self.wxNavigationController && ![self isKindOfClass:[WXUITabBarVC class]]){
        [self addNavigationController];
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    _bgImageView = [[WXUIImageView alloc] initWithFrame:_baseView.bounds];
    [_bgImageView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin
     | UIViewAutoresizingFlexibleHeight
     |UIViewAutoresizingFlexibleTopMargin
     |UIViewAutoresizingFlexibleLeftMargin
     |UIViewAutoresizingFlexibleWidth
     |UIViewAutoresizingFlexibleRightMargin];
    [_baseView addSubview:_bgImageView];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ( isIOS7 ){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
    CGSize size = [self bounds].size;
    _waitingView = [[WXUIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_waitingView setCenter:CGPointMake(size.width*0.5, size.height*0.5)];
    [_waitingView.layer setZPosition:kTopLayerZPosition];
    [self addSubview:_waitingView];
    
    _hud = [[WXWaitingHud alloc] initWithParentView:_baseView];
    [_hud setHidden:YES];
    [_hud setFrame:CGRectMake(0, IPHONE_STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEGITH, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height-(IPHONE_STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEGITH))];
    [self.view addSubview:_hud];
    [self addServiceOBS];
    //    [self createNetTipView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UtilTool resignFirstResponder];
}

- (void)showFullScreenHud:(BOOL)show withTip:(NSString*)tip{
    if(show){
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _fullScreenHud = [[WXWaitingHud alloc] initWithParentView:keyWindow];
        [_fullScreenHud setText:tip];
        [keyWindow addSubview:_fullScreenHud];
        [_fullScreenHud startAnimate];
    }else{
        if(_fullScreenHud){
            [_fullScreenHud stopAniamte];
            [_fullScreenHud setHidden:YES];
            [_fullScreenHud removeFromSuperview];
            RELEASE_SAFELY(_fullScreenHud);
        }
    }
}

- (void)createNetTipView{
    CGFloat yOffset = 0;
    _netTipView = [[WXUIView alloc] initWithFrame:CGRectMake(0, yOffset, self.bounds.size.width, kNetWorkTipHeight)];
    [_netTipView setBackgroundColor:[UIColor whiteColor]];
    [_netTipView setBackgroundImage:[UIImage imageNamed:@"disconnectBg.png"]];
    WXUILabel *label = [[[WXUILabel alloc] initWithFrame:_netTipView.bounds] autorelease];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [label setTextColor:WXColorWithInteger(0xffffff)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"当前网络不可用，请检查你的网络设置"];
    [label setFont:WXFont(12.0)];
    [_netTipView addSubview:label];
    [self.view addSubview:_netTipView];
    [_netTipView setHidden:YES];
}

- (void)addServiceOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(serviceDisconnected:) name:D_Notification_Name_ServiceDisconnect object:nil];
    [notificationCenter addObserver:self selector:@selector(serviceConnected:) name:D_Notification_Name_ServiceConnectedOK object:nil];
//    [notificationCenter addObserver:self selector:@selector(netTipDelayFinished) name:D_Notification_Name_NetTipDelayFinished object:nil];
    //	[notificationCenter addObserver:self selector:@selector(netWorkDisconected) name:D_Notification_Name_NetWorkDisconnected object:nil];
    //	[notificationCenter addObserver:self selector:@selector(netWorkConnected) name:D_Notification_Name_NetWorkWifi object:nil];
    //	[notificationCenter addObserver:self selector:@selector(netWorkConnected) name:D_Notification_Name_NetWorkWWAN object:nil];
}

- (void)netWorkDisconected{
    [self showNetTipView:YES animated:YES];
}

- (void)netWorkConnected{
    [self showNetTipView:NO animated:YES];
}

- (BOOL)isContanerVC{
    if([self isKindOfClass:[WXUITabBarVC class]] || [self isKindOfClass:[YRSideViewController class]]){
        return YES;
    }
    return NO;
}

- (void)showNetTipView:(BOOL)show animated:(BOOL)animated{
    if([self isContanerVC]){
        return;
    }
    
    CGSize size = self.view.bounds.size;
    CGFloat yOffset = 0;
    CGSize tipSize = _netTipView.bounds.size;
    if(self.wxNavigationController && !self.cstNavigationView.isHidden){
        yOffset = self.cstNavigationView.bounds.size.height;
    }else{
        if(isIOS7){
            tipSize.height = kNetWorkTipHeight+IPHONE_STATUS_BAR_HEIGHT;
        }
    }
    CGFloat dur = kAnimatedDur;
    if(!animated){
        dur = 0.0;
    }
    //避免重复
    CGAffineTransform transform = _baseView.transform;
    [_baseView setTransform:CGAffineTransformIdentity];
    CGRect baseRect = _baseView.frame;
    if(show && [_netTipView isHidden]){
        [_netTipView setHidden:NO];
        [_netTipView setFrame:CGRectMake(0, yOffset, tipSize.width, tipSize.height)];
        yOffset += tipSize.height;
        baseRect = CGRectMake(0, yOffset, size.width, size.height - yOffset);
    }else if(!show && ![_netTipView isHidden]){
        [_netTipView setHidden:YES];
        baseRect = CGRectMake(0, yOffset, size.width, size.height - yOffset);
    }
    [_baseView setFrame:baseRect];
    [_baseView setTransform:transform];
}

- (void)serviceDisconnected:(NSNotification*)notification{
    [self detectAndShowServiceConnectTipIfNotInDelay];
}

- (void)serviceConnected:(NSNotification*)notification{
    [self showNetTipView:NO animated:YES];
}

- (void)removeServiceOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:D_Notification_Name_ServiceDisconnect object:nil];
    [notificationCenter removeObserver:self name:D_Notification_Name_ServiceConnectedOK object:nil];
}

- (void)setBackgroundColor:(UIColor*)color{
    [_baseView setBackgroundColor:color];
}

- (void)setBackgroundImage:(UIImage*)image{
    [_bgImageView setImage:image];
}

- (void)addNavigationController{
    if(_cstNavigationView){
        return;
    }
    _cstNavigationView = [[CSTWXNavigationView cstWXNavigationView] retain];
    [self.view addSubview:_cstNavigationView];
    
    CGRect navRect = _cstNavigationView.frame;
    CGFloat yOffset = navRect.origin.y + navRect.size.height;
    CGRect rect = [_baseView frame];
    rect.origin.y = yOffset;
    rect.size.height -= yOffset;
    [_baseView setFrame:rect];
}

- (void)setBackNavigationBarItem{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imagePathed:@"CommonArrowLeft.png"] forState:UIControlStateNormal];
    [leftBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:WXFont(15.0)];
//    [leftBtn setImage:[UIImage imagePathed:@"T_AllBackSel.png"] forState:UIControlStateSelected];
//    [leftBtn setTitle:@"<返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat yOffset = 0.0;
    if(isIOS7){
        yOffset = 20.0;
    }
    [leftBtn setFrame:CGRectMake(0, yOffset, kDefaultNavigationBarButtonSize.width+40, kDefaultNavigationBarButtonSize.height)];
    [self setLeftNavigationItem:leftBtn];
}

- (void)back{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)setLeftNavigationItem:(UIView*)btn{
    [_cstNavigationView setLeftNavigationItem:btn];
}
- (void)setRightNavigationItem:(UIView*)btn{
    [_cstNavigationView setRightNavigationItem:btn];
}

- (void)setCSTTitle:(NSString*)title{
    [_cstNavigationView setTitle:title];
}
- (void)setCSTTitleFont:(UIFont*)font{
    [_cstNavigationView setTitleFont:font];
}
- (void)setCSTTitleColor:(UIColor*)color{
    [_cstNavigationView setTitleColor:color];
}

- (WXUINavigationController *)wxNavigationController{
    UIViewController *parentVC = [self parentViewController];
    if([parentVC isKindOfClass:[WXUINavigationController class]]){
        return (WXUINavigationController*)self.parentViewController;
    }else if([parentVC isKindOfClass:[WXUITabBarVC class]] || [parentVC isKindOfClass:[YRSideViewController class]]){
        WXUIViewController *wxVC = (WXUIViewController*)parentVC;
        return wxVC.wxNavigationController;
    }
    return nil;
}

- (void)setCSTNavigationViewHidden:(BOOL)hidden animated:(BOOL)animated{
    //如果当前没有navigationController则此代码无效
    if(!self.wxNavigationController){
        return;
    }
    BOOL isHiddenPre = _cstNavigationView.isHidden;
    [_cstNavigationView setHidden:hidden];
    //重复调用~
    if(isHiddenPre == hidden){
        return;
    }
    CGRect rect = self.baseView.frame;
    CGFloat navigationViewHeight = _cstNavigationView.frame.size.height;
    if(hidden){
        rect.origin.y -= navigationViewHeight;
        rect.size.height += navigationViewHeight;
    }else{
        rect.origin.y += navigationViewHeight;
        rect.size.height -= navigationViewHeight;
    }
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_baseView setFrame:rect];
        }];
    }else{
        [_baseView setFrame:rect];
    }
}

- (void)showWaitViewMode:(E_WaiteView_Mode)mode tip:(NSString*)tip{
    switch (mode) {
        case E_WaiteView_Mode_Unblock:
            [_waitingView startAnimating];
            [_waitingView setHidden:NO];
            break;
        case E_WaiteView_Mode_BaseViewBlock:
            [_hud setHidden:NO];
            [_hud setText:tip];
            [_hud startAnimate];
            break;
        case E_WaiteView_Mode_FullScreenBlock:
            [self showFullScreenHud:YES withTip:tip];
            break;
        default:
            break;
    }
}

- (void)showWaitViewMode:(E_WaiteView_Mode)mode title:(NSString*)title{
    switch (mode) {
        case E_WaiteView_Mode_Unblock:
            [_waitingView startAnimating];
            [_waitingView setHidden:NO];
            break;
        case E_WaiteView_Mode_BaseViewBlock:
            [_hud setHidden:NO];
            [_hud setText:nil];
            [_hud startAnimate];
            break;
        case E_WaiteView_Mode_FullScreenBlock:
            [self showFullScreenHud:YES withTip:nil];
            break;
        default:
            break;
    }
}

- (void)unShowWaitView{
    [_waitingView stopAnimating];
    [_waitingView setHidden:YES];
    [_hud stopAniamte];
    [_hud setHidden:YES];
    [self showFullScreenHud:NO withTip:nil];
}

- (void)addSubview:(UIView*)subView{
    [_baseView addSubview:subView];
    [subView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
}

- (void)addSubview:(UIView*)subView autoresizingMask:(UIViewAutoresizing)mask{
    [_baseView addSubview:subView];
    [subView setAutoresizingMask:mask];
}

- (CGRect)bounds{
    return _baseView.bounds;
}

- (CGFloat)currentLimitXVelocity{
    CGFloat velocity = 0;
    switch (_dexterity) {
        case E_Slide_Dexterity_High:
            velocity = 100;
            break;
        case E_Slide_Dexterity_Normal:
            velocity = 800;
            break;
        case E_Slide_Dexterity_Low:
            velocity = 1000000;
            break;
        case E_Slide_Dexterity_None:
            velocity = CGFLOAT_MAX;
            break;
        default:
            break;
    }
    return velocity;
}

#pragma mark UIKeyboardWillShowNotification UIKeyboardWillHideNotification

- (void)detectAndShowServiceConnectTipIfNotInDelay{
    if(![NetTipDelay sharedNetTipDelay].isInDelay){
//        [self detectAndShowServiceConnectTip];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_openKeyboardNotification){
        [self addKeyboardNotification];
    }
    //    [self detectAndShowServiceConnectTipIfNotInDelay];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(_openKeyboardNotification){
        [self removeKeyboardNotification];
    }
}

- (void)addKeyboardNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    [self hideKeyBoardDur:duration];
}

-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    [self showKeyBoardDur:duration height:kbSize.height];
}

- (void)showKeyBoardDur:(CGFloat)dur height:(CGFloat)height{
    
}

- (void)hideKeyBoardDur:(CGFloat)dur{
    
}
@end
