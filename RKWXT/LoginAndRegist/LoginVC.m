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
#import "WXTUITabbarVC.h"
#import "NewWXTLiDB.h"
#import "ForgetPwdVC.h"
#import "APService.h"

#define Size self.bounds.size
#define kLoginBigImgViewheight (220)
#define kLoginDownViewHeight (40)
#define kUserExactLength (11)
#define kFetchPasswordDur (60)

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
    [self setCSTNavigationViewHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _iconShell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Size.width, kLoginBigImgViewheight)];
    [_iconShell setClipsToBounds:YES];
    [self addSubview:_iconShell];
    
    UIImage *bigImg = [UIImage imageNamed:@"LoginUpBgImg.png"];
    UIImageView *loginBigImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Size.width, kLoginBigImgViewheight)];
    [loginBigImgView setImage:bigImg];
    [_iconShell addSubview:loginBigImgView];
    
    CGFloat yOffset = 36.0;
    CGFloat xOffset = 12.0;
    UIImage *icon = [UIImage imageNamed:@"LoginUpSmallImg.png"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, icon.size.width, icon.size.height)];
    [iconImageView setImage:icon];
    [_iconShell addSubview:iconImageView];
    
    CGFloat btnWidth = 51;
    CGFloat btnHeight = 23;
    WXUIButton *registBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(Size.width-xOffset-btnWidth, yOffset, btnWidth, btnHeight);
    [registBtn setBackgroundColor:[UIColor clearColor]];
    [registBtn setBorderRadian:1.0 width:1.0 color:[UIColor whiteColor]];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [registBtn.titleLabel setFont:WXFont(12.0)];
    [registBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [_iconShell addSubview:registBtn];
    
    _optShell = [[UIView alloc] initWithFrame:CGRectMake(0, kLoginBigImgViewheight, Size.width, Size.height - kLoginBigImgViewheight-kLoginDownViewHeight)];
    [_optShell setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_optShell];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_optShell addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown];
    [_optShell addGestureRecognizer:swip];
    
    
    CGFloat yGap = 112;
    CGRect tableRect = CGRectMake(0, 0, Size.width, yGap);
    [self createUserAndPwdTable:tableRect];
    

    yOffset = tableRect.size.height+22;
    CGFloat btnHeight1 = 41.0;
    CGFloat xgap = 20;
    CGFloat btnWidth1 = Size.width-2*xgap;
    CGFloat radian = 5.0;
    CGFloat titleSize = 18.0;
    _submitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(xgap, yOffset, btnWidth1, btnHeight1)];
    [_submitBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:WXTFont(titleSize)];
    [_submitBtn setBackgroundImageOfColor:[UIColor clearColor] controlState:UIControlStateNormal];
    [_submitBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [_submitBtn setBorderRadian:radian width:0.5 color:WXColorWithInteger(0xdd2726)];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_submitBtn];
    
    yOffset += btnHeight1;
    CGFloat fetchPwdBtnWidth = 100;
    CGFloat xGap1 = Size.width - fetchPwdBtnWidth - xgap;
    _fetchPwdBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _fetchPwdBtn.frame = CGRectMake(xGap1, yOffset, fetchPwdBtnWidth, 30);
    [_fetchPwdBtn.titleLabel setFont:WXTFont(14.0)];
    [_fetchPwdBtn setTitle:@"登录遇到问题?" forState:UIControlStateNormal];
    [_fetchPwdBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [_fetchPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_fetchPwdBtn addTarget:self action:@selector(fetchPassWord) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_fetchPwdBtn];
    
    CGRect downViewRect = CGRectMake(0, 0, Size.width, kLoginDownViewHeight);
    [self createDownView:downViewRect];
    
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
    CGFloat xGap = 30.0;
    CGFloat yGap = 12.0;
    CGFloat height = 35.0;
    CGFloat width = size.width - xGap*2.0;
    CGFloat yOffset = yGap;
    
    CGFloat fontSize = 15.0;
    CGFloat leftViewGap = 10.0;
    CGFloat textGap = 30.0;
    _userTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
//    [_userTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField addTarget:self action:@selector(showKeyBoardDur:)  forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_userTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userTextField setTintColor:WXColorWithInteger(0xdd2726)];
    [_userTextField setPlaceHolder:@"请输入手机号" color:WXColorWithInteger(0xda7c7b)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(fontSize)];
    UIImage *leftImg = [UIImage imageNamed:@"LoginUserImg.png"];
    UIImageView *leftView = [[UIImageView alloc] initWithImage:leftImg];
    [_userTextField setLeftView:leftView leftGap:leftViewGap rightGap:textGap];
    [_optShell addSubview:_userTextField];
    
    yOffset += height+5;
    CGFloat xGap1 = xGap-10;
    CGFloat lineHeight = 10;
    UILabel *leftLine = [[UILabel alloc] init];
    leftLine.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine];
    
    UILabel *downLine = [[UILabel alloc] init];
    downLine.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:downLine];
    
    UILabel *leftLine1 = [[UILabel alloc] init];
    leftLine1.frame = CGRectMake(xGap1+60, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine1];
    
    UILabel *rightLine = [[UILabel alloc] init];
    rightLine.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:rightLine];
    
    
    yOffset += 10;
    _pwdTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_pwdTextField setReturnKeyType:UIReturnKeyDone];
    [_pwdTextField setSecureTextEntry:YES];
    [_pwdTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextField addTarget:self action:@selector(showKeyBoardDur:)  forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_pwdTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_pwdTextField setTintColor:WXColorWithInteger(0xdd2726)];
    [_pwdTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_pwdTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_pwdTextField setPlaceHolder:@" 请输入密码" color:WXColorWithInteger(0xda7c7b)];
    UIImage *passwordIcon = [UIImage imageNamed:@"LoginUserPwd.png"];
    UIImageView *leftView1 = [[UIImageView alloc] initWithImage:passwordIcon];
    [_pwdTextField setLeftView:leftView1 leftGap:leftViewGap rightGap:textGap];
    [_pwdTextField setFont:WXTFont(fontSize)];
    [_optShell addSubview:_pwdTextField];
    
    yOffset += height+5;
    UILabel *leftLine2 = [[UILabel alloc] init];
    leftLine2.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine2 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine2];
    
    UILabel *downLine1 = [[UILabel alloc] init];
    downLine1.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:downLine1];
    
    UILabel *leftLine3 = [[UILabel alloc] init];
    leftLine3.frame = CGRectMake(xGap1+60, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine3];
    
    UILabel *rightLine1 = [[UILabel alloc] init];
    rightLine1.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:rightLine1];
}

-(void)createDownView:(CGRect)rect{
    CGFloat xOffset = 22;
    CGFloat label1Width = Size.width/2-xOffset;
    CGFloat label1Height = 14;
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(xOffset, Size.height-20, label1Width, label1Height);
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setText:@"微信公众号: woxin1000"];
    [label1 setFont:WXFont(10.0)];
    [label1 setTextColor:WXColorWithInteger(0xda7c7b)];
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(Size.width/2, Size.height-20, Size.width/2-xOffset, label1Height);
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:NSTextAlignmentRight];
    [label2 setText:@"客服电话:61335655"];
    [label2 setFont:WXFont(10.0)];
    [label2 setTextColor:WXColorWithInteger(0xda7c7b)];
    [self addSubview:label2];
}

#pragma mark KeyBoard
- (void)showKeyBoardDur:(CGFloat)dur{
    CGFloat yOffset = 0.0;
    if(isIOS7){
        yOffset = IPHONE_STATUS_BAR_HEIGHT;
    }
    CGRect optShellRect = [_optShell bounds];
    optShellRect.origin.y = yOffset+45;
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:optShellRect];
    }];
}

- (void)hideKeyBoardDur:(CGFloat)dur{
    CGRect optShellRect = [_optShell bounds];
    optShellRect.origin.y = kLoginBigImgViewheight;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:optShellRect];
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

#pragma mark
-(void)fetchPassWord{
    if(![self checkUserValide]){
        return;
    }
    ForgetPwdVC *forgetPwd = [[ForgetPwdVC alloc] init];
    forgetPwd.userPhone = _userTextField.text;
    [self.wxNavigationController pushViewController:forgetPwd];
}

#pragma mark 获取密码
- (void)setFetchPasswordButtonTitle{
    [_fetchPwdBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"登录遇到问题?";
    if(_fetchPasswordTime > 0){
        title = [NSString stringWithFormat:@"(%d)密码获取中",kFetchPasswordDur - (int)_fetchPasswordTime];
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

//- (void)fetchPassWord{
//    if(![self checkUserValide]){
//        return;
//    }
//    [_pwdModel fetchPwdWithUserPhone:_userTextField.text];
//    [self startFetchPwdTiming];
//    [_fetchPwdBtn setEnabled:NO];
//    [self textFieldResighFirstResponder];
//}

#pragma mark delegate
- (void)loginSucceed{
    [self unShowWaitView];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    WXTUITabbarVC *tabbar = [[WXTUITabbarVC alloc] init];
    WXUINavigationController *nav = [[WXUINavigationController alloc] initWithRootViewController:tabbar];
    [self presentViewController:nav animated:YES completion:^{
        WXTDatabase * database = [WXTDatabase shareDatabase];
        [database createDatabase:userDefault.wxtID];
        [[NewWXTLiDB sharedWXLibDB] loadData];
        [APService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"%@",userDefault.user]] alias:nil callbackSelector:nil object:nil];
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
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [_model loginWithUser:_userTextField.text andPwd:_pwdTextField.text];
    }
    [self textFieldResighFirstResponder];
}

- (void)toRegister{
    RegistVC *registVC = [[RegistVC alloc] init];
    [self.wxNavigationController pushViewController:registVC];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end