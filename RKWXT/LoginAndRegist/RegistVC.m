//
//  RegistVC.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RegistVC.h"
#import "WXTUITextField.h"
#import "UIView+Render.h"
#import "RegistModel.h"
#import "GainModel.h"

#define kLoginBigImgViewheight (220)
#define UserPhoneLength (11)
#define EveryCellHeight (40)
#define kFetchPasswordDur (60)
#define Size self.bounds.size

enum{
    WXT_Regist_UserPhone = 0,
    WXT_Regist_FetchPwd,
    WXT_Regist_Pwd,
    WXT_Regist_OtherPhone,
    
    WXT_Regist_Invalid,
}WXT_Regist_Type;

@interface RegistVC()<RegistDelegate,GainNumDelegate>{
    WXTUITextField *_userTextField;
    WXTUITextField *_fetchPwd;
    WXTUITextField *_pwdTextfield;
    WXTUITextField *_otherPhone;
    
    WXTUIButton *_gainBtn;
    NSTimer *_fetchPWDTimer;
    NSInteger _fetchPasswordTime;
    
    RegistModel *_model;
    UIView *_iconShell;
    UIView *_optShell;
    GainModel *_gainModel;
}
@end

@implementation RegistVC

-(id)init{
    self = [super init];
    if(self){
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard) name:UIKeyboardDidShowNotification object:nil];
        
        _model = [[RegistModel alloc] init];
        [_model setDelegate:self];
        
        _gainModel = [[GainModel alloc] init];
        [_gainModel setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self createUI];
    [self createLeftBackBtn];
}

-(void)createLeftBackBtn{
    CGFloat xOffset = 10;
    CGFloat yOffset = 30;
    CGFloat btnWidth = 50;
    CGFloat btnHeight = 25;
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHeight);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTitle:@"<返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}

-(void)createUI{
    _iconShell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Size.width, kLoginBigImgViewheight)];
    [_iconShell setClipsToBounds:YES];
    [self addSubview:_iconShell];
    
    UIImage *bigImg = [UIImage imageNamed:@"LoginUpBgImg.png"];
    UIImageView *loginBigImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Size.width, kLoginBigImgViewheight)];
    [loginBigImgView setImage:bigImg];
    [_iconShell addSubview:loginBigImgView];
    
    _optShell = [[UIView alloc] initWithFrame:CGRectMake(0, kLoginBigImgViewheight, Size.width, Size.height - kLoginBigImgViewheight)];
    [_optShell setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_optShell];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_optShell addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown];
    [_optShell addGestureRecognizer:swip];
    
    
    CGFloat yGap = 112+38;
    CGRect tableRect = CGRectMake(0, 0, Size.width, yGap);
    [self createUserAndPwdTable:tableRect];
    
    CGFloat yOffset = tableRect.size.height+65;
    CGFloat btnHeight1 = 41.0;
    CGFloat xgap = 20;
    CGFloat btnWidth1 = Size.width-2*xgap;
    CGFloat radian = 5.0;
    CGFloat titleSize = 18.0;
    WXTUIButton *_submitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(xgap, yOffset, btnWidth1, btnHeight1)];
    [_submitBtn setTitle:@"注册领免费话费" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:WXTFont(titleSize)];
    [_submitBtn setBackgroundImageOfColor:[UIColor clearColor] controlState:UIControlStateNormal];
    [_submitBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [_submitBtn setBorderRadian:radian width:0.5 color:WXColorWithInteger(0xdd2726)];
    [_submitBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_submitBtn];
}

-(void)createUserAndPwdTable:(CGRect)rect{
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
    [_userTextField addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_userTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userTextField setTintColor:WXColorWithInteger(0xdd2726)];
    [_userTextField setPlaceHolder:@"请输入你的手机号" color:WXColorWithInteger(0xda7c7b)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(fontSize)];
    UIImage *leftImg = [UIImage imageNamed:@"RegistUserImg.png"];
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
    leftLine1.frame = CGRectMake(xGap1+50, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine1];
    
    UILabel *rightLine = [[UILabel alloc] init];
    rightLine.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:rightLine];
    
    yOffset += 10;
    _fetchPwd = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width-75, height)];
    [_fetchPwd setReturnKeyType:UIReturnKeyDone];
    [_fetchPwd setSecureTextEntry:YES];
    [_fetchPwd addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_fetchPwd addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_fetchPwd setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_fetchPwd setTextColor:WXColorWithInteger(0xda7c7b)];
    [_fetchPwd setTintColor:WXColorWithInteger(0xdd2726)];
    [_fetchPwd setLeftViewMode:UITextFieldViewModeAlways];
    [_fetchPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    [_fetchPwd setPlaceHolder:@"请输入验证码" color:WXColorWithInteger(0xda7c7b)];
    [_fetchPwd setFont:WXTFont(fontSize)];
    UIImage *leftImg0 = [UIImage imageNamed:@"RegistUserCodeImg.png"];
    UIImageView *leftView0 = [[UIImageView alloc] initWithImage:leftImg0];
    [_fetchPwd setLeftView:leftView0 leftGap:leftViewGap rightGap:textGap];
    [_optShell addSubview:_fetchPwd];
    
    _gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _gainBtn.frame = CGRectMake(Size.width-xGap1-90+8, yOffset+4, 82, 28);
    [_gainBtn setBorderRadian:1.0 width:0.4 color:WXColorWithInteger(0xdd2726)];
    [_gainBtn.titleLabel setFont:WXTFont(14.0)];
    [_gainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_gainBtn addTarget:self action:@selector(fecthCode) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_gainBtn];
    
    
    yOffset += height+5;
    UILabel *leftLine2 = [[UILabel alloc] init];
    leftLine2.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine2 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine2];
    
    UILabel *downLine1 = [[UILabel alloc] init];
    downLine1.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1-90, 0.5);
    [downLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:downLine1];
    
    UILabel *leftLine3 = [[UILabel alloc] init];
    leftLine3.frame = CGRectMake(xGap1+50, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine3];
    
    UILabel *rightLine1 = [[UILabel alloc] init];
    rightLine1.frame = CGRectMake(Size.width-xGap1-90, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:rightLine1];
    
    yOffset += 10;
    _pwdTextfield = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_pwdTextfield setReturnKeyType:UIReturnKeyDone];
    [_pwdTextfield setSecureTextEntry:YES];
    [_pwdTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextfield addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextfield setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_pwdTextfield setTextColor:WXColorWithInteger(0xda7c7b)];
    [_pwdTextfield setTintColor:WXColorWithInteger(0xdd2726)];
    [_pwdTextfield setLeftViewMode:UITextFieldViewModeAlways];
    [_pwdTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [_pwdTextfield setPlaceHolder:@" 请输入密码" color:WXColorWithInteger(0xda7c7b)];
    UIImage *passwordIcon = [UIImage imageNamed:@"RegistUserPwdImg.png"];
    UIImageView *leftView1 = [[UIImageView alloc] initWithImage:passwordIcon];
    [_pwdTextfield setLeftView:leftView1 leftGap:leftViewGap rightGap:textGap];
    [_pwdTextfield setFont:WXTFont(fontSize)];
    [_optShell addSubview:_pwdTextfield];
    
    yOffset += height+5;
    UILabel *leftLine0 = [[UILabel alloc] init];
    leftLine0.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine0 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine0];
    
    UILabel *downLine0 = [[UILabel alloc] init];
    downLine0.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine0 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:downLine0];
    
    UILabel *leftLine9 = [[UILabel alloc] init];
    leftLine9.frame = CGRectMake(xGap1+50, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine9 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine9];
    
    UILabel *rightLine0 = [[UILabel alloc] init];
    rightLine0.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine0 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:rightLine0];
    
    yOffset += 10;
    _otherPhone = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset, width, height)];
    [_otherPhone setReturnKeyType:UIReturnKeyDone];
    [_otherPhone setSecureTextEntry:YES];
    [_otherPhone addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_otherPhone addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_otherPhone setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_otherPhone setTextColor:WXColorWithInteger(0xda7c7b)];
    [_otherPhone setTintColor:WXColorWithInteger(0xdd2726)];
    [_otherPhone setLeftViewMode:UITextFieldViewModeAlways];
    [_otherPhone setKeyboardType:UIKeyboardTypeASCIICapable];
    [_otherPhone setPlaceHolder:@"输入介绍人(选填)" color:WXColorWithInteger(0xda7c7b)];
    UIImage *otherIcon = [UIImage imageNamed:@"RegistOtherUser.png"];
    UIImageView *leftView2 = [[UIImageView alloc] initWithImage:otherIcon];
    [_otherPhone setLeftView:leftView2 leftGap:leftViewGap-3 rightGap:textGap];
    [_otherPhone setFont:WXTFont(fontSize)];
    [_optShell addSubview:_otherPhone];
    
    yOffset += height+5;
    UILabel *leftLine4 = [[UILabel alloc] init];
    leftLine4.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine4 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine4];
    
    UILabel *downLine3 = [[UILabel alloc] init];
    downLine3.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:downLine3];
    
    UILabel *leftLine5 = [[UILabel alloc] init];
    leftLine5.frame = CGRectMake(xGap1+50, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine5 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:leftLine5];
    
    UILabel *rightLine3 = [[UILabel alloc] init];
    rightLine3.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_optShell addSubview:rightLine3];
}

#pragma mark keyboard
-(void)showKeyBoard{
    CGFloat yOffset = 0.0;
    if(isIOS7){
        yOffset = IPHONE_STATUS_BAR_HEIGHT;
    }
    yOffset += 50;
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:CGRectMake(0, yOffset, Size.width, Size.height-kLoginBigImgViewheight)];
    }];
}

- (void)hideKeyBoardDur{
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:CGRectMake(0, kLoginBigImgViewheight, Size.width, Size.height-kLoginBigImgViewheight)];
    }];
}

#pragma mark 数据是否有效~
- (BOOL)checkUserValide{
    NSString *user = _userTextField.text;
    NSInteger len = user.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
    if(user.length != 11){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}

#pragma mark textField resignFirstResponder
- (void)swip{
    [self textFieldResighFirstResponder];
}

- (void)tap{
    [self textFieldResighFirstResponder];
}

#pragma mark delegate
-(void)fecthCode{
    if(![self checkUserValide]){
        return;
    }
    [_gainModel gainNumber:_userTextField.text];
    [self startFetchPwdTiming];
    [_gainBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
}

-(void)gainNumSucceed{
    [UtilTool showAlertView:[NSString stringWithFormat:@"验证码已经发送到你的号码为%@的手机上，请注意查收",_userTextField.text]];
}

-(void)gainNumFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取验证码失败";
    }
    [self stopFetchPwdTiming];
    [self setFetchPasswordButtonTitle];
    [UtilTool showAlertView:errorMsg];
}

#pragma mark textfield
-(void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

- (void)textFieldResighFirstResponder{
    [_userTextField resignFirstResponder];
    [_fetchPwd resignFirstResponder];
    [_pwdTextfield resignFirstResponder];
    [_otherPhone resignFirstResponder];
    [self hideKeyBoardDur];
}

#pragma mark 验证码
- (void)setFetchPasswordButtonTitle{
    [_gainBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"获取验证码";
    if(_fetchPasswordTime > 0){
        title = [NSString stringWithFormat:@"(%d)",kFetchPasswordDur - (int)_fetchPasswordTime];
    }
    [_gainBtn setTitle:title forState:UIControlStateNormal];
    [_gainBtn setTitle:title forState:UIControlStateHighlighted];
    [_gainBtn setTitle:title forState:UIControlStateDisabled];
}

- (void)startFetchPwdTiming{
    _fetchPWDTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countFetchPassword) userInfo:nil repeats:YES];
}

- (void)countFetchPassword{
    _fetchPasswordTime ++;
    if(_fetchPasswordTime == kFetchPasswordDur){
        _fetchPasswordTime = 0;
        [self stopFetchPwdTiming];
    }
    [self setFetchPasswordButtonTitle];
}

- (void)stopFetchPwdTiming{
    if(_fetchPWDTimer){
        if([_fetchPWDTimer isValid]){
            [_fetchPWDTimer invalidate];
        }
    }
    _fetchPasswordTime = 0;
}

-(BOOL)checkRegistInfo{
    if(![self checkUserValide]){
        return NO;
    }
    if(_pwdTextfield.text.length < 6){
        [UtilTool showAlertView:@"密码不能小于6位"];
        return NO;
    }
    if(_fetchPwd.text.length < 1){
        [UtilTool showAlertView:@"验证码不能为空"];
        return NO;
    }
    //    if(_otherPhone.text.length == 0){
    //        [UtilTool showAlertView:@"请输入推荐人手机号"];
    //        return NO;
    //    }
    //    if(_otherPhone.text.length != 11){
    //        [UtilTool showAlertView:@"请输入正确的推荐人手机号码"];
    //        return NO;
    //    }
    return YES;
}

#pragma mark registerDelegate
-(void)regist{
    [self textFieldResighFirstResponder];
    if(![self checkRegistInfo]){
        return;
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    //    [_model registWithUserPhone:_userTextField.text andPwd:_pwdTextfield.text andSmsID:userDefault.smsID andCode:[_fetchPwd.text integerValue] andRecommondUser:@"18888888888"];  //暂时无需填写推荐人手机号
    [_model registWithUserPhone:_userTextField.text andPwd:_pwdTextfield.text andSmsID:userDefault.smsID andCode:[_fetchPwd.text integerValue] andRecommondUser:@"18888888888"];  //暂时无需填写推荐人手机号
}

-(void)registSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"注册成功"];
    [self backLogin];
}

-(void)registFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

#pragma mark back
-(void)backLogin{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
