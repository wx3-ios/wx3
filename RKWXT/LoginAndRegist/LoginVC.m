//
//  LoginVC.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginVC.h"
#import "UIView+Render.h"
#import "WXTUITextField.h"
#import "LoginModel.h"
#import "WXTUITabBarController.h"
#import "FetchPwdModel.h"
#import "RegistVC.h"
#import "WXTDatabase.h"
#define Size self.view.bounds.size
#define kMinUserLength (8)
#define kUserExactLength (11)
#define kFetchPasswordDur (60)
#define kTableViewXGap (25.0)

@interface LoginVC ()<LoginDelegate,FetchPwdDelegate>{
    WXTUITextField *_userTextField;
    WXTUITextField *_pwdTextField;
    UIView *_iconShell;
    UIView *_optShell;
    
    WXTUIButton *_fetchPwdBtn;
    WXTUIButton *_submitBtn;
    WXTUIButton *_toRegisterBtn;
    
    
    NSInteger _fetchPasswordTime;
    NSTimer *_fetchPWDTimer;
    
//    LoginMaskView *_loginMaskView;
    LoginModel *_model;
    FetchPwdModel *_pwdModel;
}
@end

@implementation LoginVC

-(id)init{
    self = [super init];
    if(self){
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoardDur:height:) name:UIKeyboardDidShowNotification object:nil];
        _model = [[LoginModel alloc] init];
        [_model setDelegate:self];
        
        _pwdModel = [[FetchPwdModel alloc] init];
        [_pwdModel setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0x0c8bdf)];
    
    CGFloat yOffset = 45.0;
    UIImage *icon = [UIImage imageNamed:@"LoginLogo.png"];
    CGSize iconSize = icon.size;
    _iconShell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Size.width, iconSize.height+yOffset)];
    [_iconShell setClipsToBounds:YES];
    [self.view addSubview:_iconShell];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((Size.width-iconSize.width)*0.5, yOffset, iconSize.width, iconSize.height)];
    [iconImageView setImage:icon];
    [_iconShell addSubview:iconImageView];
    yOffset +=iconSize.height + 15.0;
    
    _optShell = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, Size.width, Size.height - yOffset)];
    [self.view addSubview:_optShell];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_optShell addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown];
    [_optShell addGestureRecognizer:swip];
    
    CGFloat gap = kTableViewXGap;
    CGRect tableRect = CGRectMake(gap, 0, Size.width-gap*2, 120.0);
    [self createUserAndPwdTable:tableRect];
    
    yOffset = tableRect.size.height;
    CGFloat fetchPwdBtnWidth = 100;
    CGFloat xOffset = Size.width - fetchPwdBtnWidth - gap;
    _fetchPwdBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _fetchPwdBtn.frame = CGRectMake(xOffset, yOffset, fetchPwdBtnWidth, 30);
    [_fetchPwdBtn.titleLabel setFont:WXTFont(14.0)];
    [_fetchPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_fetchPwdBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [_fetchPwdBtn setTitleColor:WXColorWithInteger(0xb7dcf5) forState:UIControlStateSelected];
    [_fetchPwdBtn addTarget:self action:@selector(fetchPassWord) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_fetchPwdBtn];
    
    UILabel *linLabel = [[UILabel alloc] init];
    linLabel.frame = CGRectMake(xOffset+16, yOffset+22, fetchPwdBtnWidth-34, 0.5);
    [linLabel setBackgroundColor:WXColorWithInteger(0xFFFFFF)];
    [_optShell addSubview:linLabel];
    yOffset += _fetchPwdBtn.bounds.size.height;
    
    yOffset += 10.0;
    CGFloat btnHeight = 33.0;
    CGFloat btnWidth = 100;
    gap = kTableViewXGap+ 10;
    CGFloat btnGap = Size.width - gap*2 - btnWidth*2;
    xOffset = gap;
    CGFloat radian = 5.0;
    CGFloat titleSize = 14.0;
    _submitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(xOffset, yOffset, btnWidth, btnHeight)];
    [_submitBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:WXTFont(titleSize)];
    [_submitBtn setBackgroundImageOfColor:WXColorWithInteger(0xFFFFFF) controlState:UIControlStateNormal];
    [_submitBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateNormal];
    [_submitBtn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateHighlighted];
    [_submitBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateHighlighted];
    [_submitBtn setBorderRadian:radian width:0 color:[UIColor clearColor]];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_submitBtn];
    xOffset += btnWidth+btnGap;
    _toRegisterBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_toRegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_toRegisterBtn.titleLabel setFont:WXTFont(titleSize)];
    [_toRegisterBtn setFrame:CGRectMake(xOffset, yOffset, btnWidth, btnHeight)];
    [_toRegisterBtn setBorderRadian:radian width:1 color:WXColorWithInteger(0xFFFFFF)];
    [_toRegisterBtn setBackgroundImageOfColor:[UIColor clearColor] controlState:UIControlStateNormal];
    [_toRegisterBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [_toRegisterBtn setBackgroundImageOfColor:WXColorWithInteger(0xFFFFFF) controlState:UIControlStateHighlighted];
    [_toRegisterBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateHighlighted];
    [_toRegisterBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_toRegisterBtn];
    
//    if (!_bWithOutGuide && kIsGuideEnabled){
//        [self.baseView setAlpha:0.3];
//        [self.baseView setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
//        _loginMaskView = [[LoginMaskView alloc] initWithFrame:self.bounds];
//        [_loginMaskView setDelegate:self];
//        [self.view addSubview:_loginMaskView];
//    }
}

- (void)createUserAndPwdTable:(CGRect)rect{
    CGSize size = rect.size;
    UIView *tbView = [[UIView alloc] initWithFrame:rect];
    [tbView setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:tbView.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [tbView addSubview:bgView];

    CGFloat xGap = 8.0;
    CGFloat yGap = 10.0;
    CGFloat height = 45.0;
    CGFloat width = size.width - xGap*2.0;
    CGFloat yOffset = yGap;
    
    CGFloat fontSize = 16.0;
    CGFloat leftViewGap = 10.0;
    CGFloat textGap = 20.0;
    _userTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
//    [_userTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField addTarget:self action:@selector(showKeyBoardDur:)  forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setBorderRadian:5.0 width:1.0 color:WXColorWithInteger(0xFFFFFF)];
    [_userTextField setTextColor:[UIColor whiteColor]];
    [_userTextField setTintColor:[UIColor whiteColor]];
    [_userTextField setPlaceHolder:@"请输入手机号" color:WXColorWithInteger(0xFFFFFF)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(fontSize)];
    UIImage *leftImg = [UIImage imageNamed:@"LoginUser.png"];
    UIImageView *leftView = [[UIImageView alloc] initWithImage:leftImg];
    [_userTextField setLeftView:leftView leftGap:leftViewGap rightGap:textGap];
    [tbView addSubview:_userTextField];
    
    _pwdTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, size.height-height-yGap, width, height)];
    [_pwdTextField setReturnKeyType:UIReturnKeyDone];
    [_pwdTextField setSecureTextEntry:YES];
    [_pwdTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextField addTarget:self action:@selector(showKeyBoardDur:)  forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextField setBorderRadian:5.0 width:1.0 color:WXColorWithInteger(0xFFFFFF)];
    [_pwdTextField setTextColor:WXColorWithInteger(0xFFFFFF)];
    [_pwdTextField setTintColor:[UIColor whiteColor]];
    [_pwdTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_pwdTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_pwdTextField setPlaceHolder:@"请输入密码" color:WXColorWithInteger(0xFFFFFF)];
    UIImage *passwordIcon = [UIImage imageNamed:@"LoginLock.png"];
    UIImageView *leftView1 = [[UIImageView alloc] initWithImage:passwordIcon];
    [_pwdTextField setLeftView:leftView1 leftGap:leftViewGap rightGap:textGap];
    [_pwdTextField setFont:WXTFont(fontSize)];
    [tbView addSubview:_pwdTextField];
    [_optShell addSubview:tbView];
}

#pragma mark KeyBoard
- (void)showKeyBoardDur:(CGFloat)dur{
    CGFloat yOffset = 0.0;
    if(isIOS7){
        yOffset = IPHONE_STATUS_BAR_HEIGHT;
    }
    CGRect optShellRect = [_optShell bounds];
    optShellRect.origin.y = yOffset;
    CGRect iconShellRect = _iconShell.bounds;
    iconShellRect.size.height = yOffset;
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:optShellRect];
        [_iconShell setFrame:iconShellRect];
    }];
}

- (void)hideKeyBoardDur:(CGFloat)dur{
    CGRect optShellRect = [_optShell bounds];
    optShellRect.origin.y = Size.height - optShellRect.size.height;
    
    CGRect iconShellRect = _iconShell.frame;
    iconShellRect.size.height = optShellRect.origin.y;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:optShellRect];
        [_iconShell setFrame:iconShellRect];
    }];
}

#pragma mark textField resignFirstResponder
- (void)swip{
    [self textFieldResighFirstResponder];
}

- (void)tap{
    [self textFieldResighFirstResponder];
}

- (void)textFieldResighFirstResponder{
    [_userTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}

- (void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

#pragma mark 数据是否有效~
- (BOOL)checkUserValide{
    NSString *user = _userTextField.text;
    NSInteger len = user.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
//    NSString *userWithCountryCode = [self userWithCountryCode];
    if(user.length != kUserExactLength){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}

- (BOOL)checkPasswordValide{
    NSString *password = _pwdTextField.text;
    NSInteger len = password.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入密码"];
        return NO;
    }
    if(len < 6){
        [UtilTool showAlertView:@"密码长度不能小于6位"];
        return NO;
    }
    return YES;
}

//- (NSString*)userWithCountryCode{
//    return [[TelNOOBJ sharedTelNOOBJ] addCountryCode:@"+86" toTelNumber:_userTextField.text];
//}

#pragma mark 逻辑

#pragma mark 获取密码
- (void)setFetchPasswordButtonTitle{
    [_fetchPwdBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"忘记密码?";
    if(_fetchPasswordTime > 0){
        title = [NSString stringWithFormat:@"(%d)%@",kFetchPasswordDur - (int)_fetchPasswordTime,title];
    }
    [_fetchPwdBtn setTitle:title forState:UIControlStateNormal];
    [_fetchPwdBtn setTitle:title forState:UIControlStateHighlighted];
    [_fetchPwdBtn setTitle:title forState:UIControlStateDisabled];
}

- (void)startFetchPwdTiming{
    _fetchPWDTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countFetchPassword) userInfo:nil repeats:YES];
}

- (void)stopFetchPwdTiming{
    if(_fetchPWDTimer){
        if([_fetchPWDTimer isValid]){
            [_fetchPWDTimer invalidate];
        }
    }
    _fetchPasswordTime = 0;
}

- (void)countFetchPassword{
    _fetchPasswordTime ++;
    if(_fetchPasswordTime == kFetchPasswordDur){
        _fetchPasswordTime = 0;
        [self stopFetchPwdTiming];
    }
    [self setFetchPasswordButtonTitle];
}

- (void)fetchPassWord{
    if(![self checkUserValide]){
        return;
    }
    [_pwdModel fetchPwdWithUserPhone:_userTextField.text];
    [self startFetchPwdTiming];
    [_fetchPwdBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
    
}

#pragma mark delegate
- (void)loginSucceed{
    [self unShowWaitView];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    [userDefault setUser:_userTextField.text];
    [userDefault setPwd:_pwdTextField.text];
    
    WXTUITabBarController *tabbar = [[WXTUITabBarController alloc] init];
    [tabbar createViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabbar];
    [self presentViewController:nav animated:YES completion:^{
        WXTDatabase * database = [WXTDatabase shareDatabase];
        [database createDatabase:userDefault.wxtID];
    }];
}

-(void)loginFailed:(NSString *)errrorMsg{
    [self unShowWaitView];
    if(!errrorMsg){
        errrorMsg = @"登录失败";
    }
    [UtilTool showAlertView:errrorMsg];
}

- (void)fetchPwdFailed:(NSString*)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"密码获取失败";
    }
    [UtilTool showAlertView:errorMsg];
    [self stopFetchPwdTiming];
    [self setFetchPasswordButtonTitle];
}

- (void)fetchPwdSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:[NSString stringWithFormat:@"密码已经发送到你的号码为%@的手机上，请注意查收",_userTextField.text]];
}

#pragma mark 登录
- (void)submit{
    if([self checkUserValide] && [self checkPasswordValide]){
        [self showWaitView:self.view];
        [_model loginWithUser:_userTextField.text andPwd:_pwdTextField.text];
    }
    [self textFieldResighFirstResponder];
}

- (void)toRegister{
    RegistVC *registVC = [[RegistVC alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end