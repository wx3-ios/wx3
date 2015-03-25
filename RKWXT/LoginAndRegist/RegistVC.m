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

#define UserPhoneLength (11)
#define EveryCellHeight (40)
#define kFetchPasswordDur (60)
#define Size self.view.bounds.size

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
    UILabel *textLabel;
    WXTUIButton *_gainBtn;
    NSTimer *_fetchPWDTimer;
    NSInteger _fetchPasswordTime;
    
    RegistModel *_model;
    UIView *_baseView;
    GainModel *_gainModel;
    
    NSArray *_baseNameArr;
}
@end

@implementation RegistVC

-(id)init{
    self = [super init];
    if(self){
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard) name:UIKeyboardDidShowNotification object:nil];
        
        _model = [[RegistModel alloc] init];
        [_model setDelegate:self];
        
        _baseNameArr = @[@"手机号:",@"验证码:",@"密   码:",@"推荐人:"];
        
        _gainModel = [[GainModel alloc] init];
        [_gainModel setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0x0c8bdf)];
    
    [self createLeftBackBtn];
    [self createUI];
    [self createRegistBtn];
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
    [self.view addSubview:backBtn];
}

-(void)createUI{
    CGFloat yOffset = 80;
    CGFloat xOffset = 10;
    CGFloat textHeight = 40;
    textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, textHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"新用户注册，即可立即领取话费，用于语音通话！注册快速安全，绝不扣取任何费用"];
    [textLabel setFont:WXTFont(12.0)];
    [textLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [textLabel setNumberOfLines:0];
    [self.view addSubview:textLabel];
    
    
    yOffset += textHeight;
    _baseView = [[UIView alloc] init];
    _baseView.frame = CGRectMake(0, yOffset, Size.width, EveryCellHeight*WXT_Regist_Invalid);
    [_baseView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_baseView];
    
    
    yOffset = 20;
    UILabel *line1 = [[UILabel alloc] init];
    line1.frame = CGRectMake(0, yOffset+20.5, Size.width, 0.5);
    [line1 setBackgroundColor:WXColorWithInteger(0xFFFFFF)];
    [_baseView addSubview:line1];
    
    xOffset = 20;
    CGFloat labelWidth = 50;
    CGFloat labelHeight = 18;
    
    
    for(int i = 0;i < WXT_Regist_Invalid; i++){
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.frame = CGRectMake(xOffset, yOffset*(i+1)+(i+2)*labelHeight, labelWidth, labelHeight);
        [phoneLabel setBackgroundColor:[UIColor clearColor]];
        [phoneLabel setText:_baseNameArr[i]];
        [phoneLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
        [phoneLabel setFont:WXTFont(14.0)];
        [_baseView addSubview:phoneLabel];
        
        UILabel *line2 = [[UILabel alloc] init];
        line2.frame = CGRectMake(xOffset, phoneLabel.frame.origin.y+26, Size.width-xOffset, 0.5);
        [line2 setBackgroundColor:WXColorWithInteger(0xFFFFFF)];
        [_baseView addSubview:line2];
        if(i == WXT_Regist_Invalid-1){
            line2.frame = CGRectMake(0, phoneLabel.frame.origin.y+26, Size.width, 0.5);
            [line2 setBackgroundColor:WXColorWithInteger(0xFFFFFF)];
        }
    }
    
    
    xOffset += labelWidth+10;
    yOffset = line1.frame.origin.y+13;
    CGFloat textWith = 114;
    _userTextField = [[WXTUITextField alloc] init];
    _userTextField.frame = CGRectMake(xOffset, yOffset+1, textWith, labelHeight+4);
    [_userTextField setBackgroundColor:[UIColor clearColor]];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
    [_userTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField addTarget:self action:@selector(showKeyBoard) forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setTextColor:WXColorWithInteger(0xFFFFFF)];
    [_userTextField setTintColor:[UIColor whiteColor]];
    [_userTextField setPlaceHolder:@"请输入手机号码" color:WXColorWithInteger(0xa5baca)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(14.0)];
    [_baseView addSubview:_userTextField];
    
    yOffset += 44;
    _fetchPwd = [[WXTUITextField alloc] init];
    _fetchPwd.frame = CGRectMake(xOffset, yOffset-4, textWith, labelHeight+4);
    [_fetchPwd setBackgroundColor:[UIColor clearColor]];
    [_fetchPwd setReturnKeyType:UIReturnKeyDone];
    [_fetchPwd setKeyboardType:UIKeyboardTypePhonePad];
    [_fetchPwd addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_fetchPwd addTarget:self action:@selector(showKeyBoard) forControlEvents:UIControlEventEditingDidBegin];
    [_fetchPwd setTextColor:WXColorWithInteger(0xFFFFFF)];
    [_fetchPwd setTintColor:[UIColor whiteColor]];
    [_fetchPwd setPlaceHolder:@"请输入验证码" color:WXColorWithInteger(0xa5baca)];
    [_fetchPwd setLeftViewMode:UITextFieldViewModeAlways];
    [_fetchPwd setFont:WXTFont(14.0)];
    [_baseView addSubview:_fetchPwd];
    
    
    xOffset += textWith;
    yOffset += 22;
    UILabel *line3 = [[UILabel alloc] init];
    line3.frame = CGRectMake(xOffset, yOffset-35, 0.5, EveryCellHeight-3);
    [line3 setBackgroundColor:WXColorWithInteger(0xa1c6e5)];
    [_baseView addSubview:line3];
    
    CGFloat gainBtnWidth = 80;
    _gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _gainBtn.frame = CGRectMake(xOffset+(Size.width-xOffset-gainBtnWidth)/2, yOffset-33, gainBtnWidth, 30);
    [_gainBtn setBackgroundColor:[UIColor clearColor]];
    [_gainBtn setTitle:@"获取" forState:UIControlStateNormal];
    [_gainBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [_gainBtn setTitleColor:WXColorWithInteger(0xa5baca) forState:UIControlStateSelected];
    [_gainBtn addTarget:self action:@selector(gainAFecthPwd) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_gainBtn];
    
    
    xOffset -= textWith;
    _pwdTextfield = [[WXTUITextField alloc] init];
    _pwdTextfield.frame = CGRectMake(xOffset, yOffset+10, textWith, labelHeight+4);
    [_pwdTextfield setBackgroundColor:[UIColor clearColor]];
    [_pwdTextfield setReturnKeyType:UIReturnKeyDone];
    [_pwdTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextfield addTarget:self action:@selector(showKeyBoard) forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextfield setTextColor:WXColorWithInteger(0xFFFFFF)];
    [_pwdTextfield setTintColor:[UIColor whiteColor]];
    [_pwdTextfield setPlaceHolder:@"请设置一个密码" color:WXColorWithInteger(0xa5baca)];
    [_pwdTextfield setLeftViewMode:UITextFieldViewModeAlways];
    [_pwdTextfield setFont:WXTFont(14.0)];
    [_baseView addSubview:_pwdTextfield];
    
    yOffset += 44;
    _otherPhone = [[WXTUITextField alloc] init];
    _otherPhone.frame = CGRectMake(xOffset, yOffset+5, textWith, labelHeight+4);
    [_otherPhone setBackgroundColor:[UIColor clearColor]];
    [_otherPhone setReturnKeyType:UIReturnKeyDone];
    [_otherPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_otherPhone addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_otherPhone addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_otherPhone setTextColor:WXColorWithInteger(0xFFFFFF)];
    [_otherPhone setTintColor:[UIColor whiteColor]];
    [_otherPhone setPlaceHolder:@"请填写推荐人" color:WXColorWithInteger(0xa5baca)];
    [_otherPhone setLeftViewMode:UITextFieldViewModeAlways];
    [_otherPhone setFont:WXTFont(14.0)];
    [_baseView addSubview:_otherPhone];
}

-(void)createRegistBtn{
    CGFloat xOffset = 80;
    CGFloat yOffset = 340;
    CGFloat btnHeight = 32;
    WXTUIButton *gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    gainBtn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, btnHeight);
    [gainBtn setBorderRadian:1.0 width:0.5 color:[UIColor clearColor]];
    [gainBtn setBorderRadian:10.0 width:0.5 color:[UIColor clearColor]];
    [gainBtn setBackgroundImageOfColor:WXColorWithInteger(0xFFFFFF) controlState:UIControlStateNormal];
    [gainBtn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [gainBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [gainBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateNormal];
    [gainBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateSelected];
    [gainBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gainBtn];
}

#pragma mark keyboard
-(void)showKeyBoard{
    CGFloat yOffset = 0.0;
    if(isIOS7){
        yOffset = IPHONE_STATUS_BAR_HEIGHT;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [textLabel setHidden:YES];
        [_baseView setFrame:CGRectMake(0, 30, Size.width, 200)];
    }];
}

- (void)hideKeyBoardDur{
    [UIView animateWithDuration:0.3 animations:^{
        [textLabel setHidden:NO];
        [_baseView setFrame:CGRectMake(0, 100, Size.width, 200)];
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

#pragma mark delegate
-(void)gainAFecthPwd{
    if(![self checkUserValide]){
        return;
    }
    [_gainModel gainNumber:_userTextField.text];
    [self startFetchPwdTiming];
    [_gainBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
}

-(void)gainNumSucceed{
    [UtilTool showAlertView:[NSString stringWithFormat:@"密码已经发送到你的号码为%@的手机上，请注意查收",_userTextField.text]];
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
    [_pwdTextfield resignFirstResponder];
    [_fetchPwd resignFirstResponder];
    [_pwdTextfield resignFirstResponder];
    [_otherPhone resignFirstResponder];
}

#pragma mark 验证码
- (void)setFetchPasswordButtonTitle{
    [_gainBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"获取";
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
    if(_otherPhone.text.length == 0){
        [UtilTool showAlertView:@"请输入推荐人手机号"];
        return NO;
    }
    if(_otherPhone.text.length != 11){
        [UtilTool showAlertView:@"请输入正确的推荐人手机号码"];
        return NO;
    }
    return YES;
}

#pragma mark registerDelegate
-(void)regist{
    if(![self checkRegistInfo]){
        return;
    }
    [self showWaitView:self.view];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    [_model registWithUserPhone:_userTextField.text andPwd:_pwdTextfield.text andSmsID:userDefault.smsID andCode:[_fetchPwd.text integerValue] andRecommondUser:_otherPhone.text];
}

-(void)registSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"注册成功"];
}

-(void)registFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

#pragma mark back
-(void)backLogin{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
