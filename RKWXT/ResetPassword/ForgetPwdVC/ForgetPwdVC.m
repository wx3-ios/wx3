//
//  ForgetPwdVC.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ForgetPwdVC.h"
#import "WXTUITextField.h"
#import "UIView+Render.h"
#import "ResetNewPwdModel.h"
#import "ForgetModel.h"
#import "WXTUITabbarVC.h"
#import "WXTDatabase.h"
#import "NewWXTLiDB.h"

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

@interface ForgetPwdVC()<ForgetResetPwdDelegate,ResetNewPwdDelegate>{
    WXTUITextField *_userTextField;  //手机号
    WXTUITextField *_fetchPwd;       //验证码
    WXTUITextField *_pwdTextfield;   //重置密码
    WXTUITextField *_otherPhone;     //确认密码
    
    WXTUIButton *_gainBtn;
    NSTimer *_fetchPWDTimer;
    NSInteger _fetchPasswordTime;
    
    ForgetModel *_model;
    ResetNewPwdModel *_resetModel;
    
    NSArray *_baseNameArr;
}
@end

@implementation ForgetPwdVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[ForgetModel alloc] init];
        [_model setDelegate:self];
        
        _baseNameArr = @[@"手机号", @"验证码", @"重置密码", @"确认密码"];
        
        _resetModel = [[ResetNewPwdModel alloc] init];
        [_resetModel setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"重置密码"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self createUI];
}

-(void)createUI{
    CGFloat yGap = 44;
    CGRect tableRect = CGRectMake(0, 0, Size.width, yGap);
    [self createUserAndPwdTable:tableRect];
    
    CGFloat yOffset = tableRect.size.height+65+120;
    CGFloat btnHeight1 = 41.0;
    CGFloat xgap = 20;
    CGFloat btnWidth1 = Size.width-2*xgap;
    CGFloat radian = 5.0;
    CGFloat titleSize = 18.0;
    WXTUIButton *_submitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(xgap, yOffset, btnWidth1, btnHeight1)];
    [_submitBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:WXTFont(titleSize)];
    [_submitBtn setBackgroundImageOfColor:[UIColor clearColor] controlState:UIControlStateNormal];
    [_submitBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [_submitBtn setBorderRadian:radian width:0.5 color:WXColorWithInteger(0xdd2726)];
    [_submitBtn addTarget:self action:@selector(resetNewPwd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitBtn];
}

-(void)createUserAndPwdTable:(CGRect)rect{
    CGSize size = rect.size;
    CGFloat xGap = 30.0;
    CGFloat yGap = 12.0;
    CGFloat height = 35.0;
    CGFloat width = size.width - xGap*2.0;
    CGFloat yOffset = yGap;
    
    CGFloat fontSize = 15.0;
    CGFloat labelWidth = 93;
    CGFloat labelHeight = 18;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(xGap-10, yOffset+8, labelWidth, labelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setText:[_baseNameArr objectAtIndex:WXT_Regist_UserPhone]];
    [phoneLabel setTextColor:WXColorWithInteger(0x000000)];
    [phoneLabel setFont:WXFont(15.0)];
    [self addSubview:phoneLabel];
    
    _userTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, width, height)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
    [_userTextField addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_userTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userTextField setTintColor:WXColorWithInteger(0xdd2726)];
    [_userTextField setPlaceHolder:@"请输入手机号" color:WXColorWithInteger(0xd0d0d0)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(fontSize)];
    if(_userPhone){
        [_userTextField setText:_userPhone];
    }
    [self addSubview:_userTextField];
    
    yOffset += height+5;
    CGFloat xGap1 = xGap-10;
    CGFloat lineHeight = 10;
    UILabel *leftLine = [[UILabel alloc] init];
    leftLine.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine];
    
    UILabel *downLine = [[UILabel alloc] init];
    downLine.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:downLine];
    
    UILabel *leftLine1 = [[UILabel alloc] init];
    leftLine1.frame = CGRectMake(xGap1+labelWidth, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine1];
    
    UILabel *rightLine = [[UILabel alloc] init];
    rightLine.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:rightLine];
    
    
    yOffset += 10;
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.frame = CGRectMake(xGap-10, yOffset+8, labelWidth, labelHeight);
    [codeLabel setBackgroundColor:[UIColor clearColor]];
    [codeLabel setTextAlignment:NSTextAlignmentCenter];
    [codeLabel setText:[_baseNameArr objectAtIndex:WXT_Regist_FetchPwd]];
    [codeLabel setTextColor:WXColorWithInteger(0x000000)];
    [codeLabel setFont:WXFont(15.0)];
    [self addSubview:codeLabel];
    
    _fetchPwd = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, width-75, height)];
    [_fetchPwd setReturnKeyType:UIReturnKeyDone];
//    [_fetchPwd setSecureTextEntry:YES];
    [_fetchPwd addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_fetchPwd addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_fetchPwd setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_fetchPwd setTextColor:WXColorWithInteger(0xda7c7b)];
    [_fetchPwd setTintColor:WXColorWithInteger(0xdd2726)];
    [_fetchPwd setLeftViewMode:UITextFieldViewModeAlways];
    [_fetchPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    [_fetchPwd setPlaceHolder:@"请输入验证码" color:WXColorWithInteger(0xd0d0d0)];
    [_fetchPwd setFont:WXTFont(fontSize)];
    [self addSubview:_fetchPwd];
    
    _gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _gainBtn.frame = CGRectMake(Size.width-xGap1-75+8, yOffset+4, 80, 28);
    [_gainBtn setBorderRadian:10.0 width:0.1 color:WXColorWithInteger(0x000000)];
    [_gainBtn.titleLabel setFont:WXTFont(14.0)];
    [_gainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_gainBtn addTarget:self action:@selector(gainAFecthPwd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gainBtn];
    
    
    yOffset += height+5;
    UILabel *leftLine2 = [[UILabel alloc] init];
    leftLine2.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine2 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine2];
    
    UILabel *downLine1 = [[UILabel alloc] init];
    downLine1.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1-75, 0.5);
    [downLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:downLine1];
    
    UILabel *leftLine3 = [[UILabel alloc] init];
    leftLine3.frame = CGRectMake(xGap1+labelWidth, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine3];
    
    UILabel *rightLine1 = [[UILabel alloc] init];
    rightLine1.frame = CGRectMake(Size.width-xGap1-75, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:rightLine1];
    
    yOffset += 10;
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.frame = CGRectMake(xGap-10, yOffset+8, labelWidth, labelHeight);
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextAlignment:NSTextAlignmentCenter];
    [pwdLabel setText:[_baseNameArr objectAtIndex:WXT_Regist_Pwd]];
    [pwdLabel setTextColor:WXColorWithInteger(0x000000)];
    [pwdLabel setFont:WXFont(15.0)];
    [self addSubview:pwdLabel];
    
    _pwdTextfield = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, width, height)];
    [_pwdTextfield setReturnKeyType:UIReturnKeyDone];
//    [_pwdTextfield setSecureTextEntry:YES];
    [_pwdTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextfield addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextfield setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_pwdTextfield setTextColor:WXColorWithInteger(0xda7c7b)];
    [_pwdTextfield setTintColor:WXColorWithInteger(0xdd2726)];
    [_pwdTextfield setLeftViewMode:UITextFieldViewModeAlways];
    [_pwdTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [_pwdTextfield setPlaceHolder:@"请输入密码" color:WXColorWithInteger(0xd0d0d0)];
    [_pwdTextfield setFont:WXTFont(fontSize)];
    [self addSubview:_pwdTextfield];
    
    yOffset += height+5;
    UILabel *leftLine5 = [[UILabel alloc] init];
    leftLine5.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine5 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine5];
    
    UILabel *downLine5 = [[UILabel alloc] init];
    downLine5.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine5 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:downLine5];
    
    UILabel *leftLine6 = [[UILabel alloc] init];
    leftLine6.frame = CGRectMake(xGap1+labelWidth, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine6 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine6];
    
    UILabel *rightLine4 = [[UILabel alloc] init];
    rightLine4.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine4 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:rightLine4];
    
    yOffset += 10;
    UILabel *againLabel = [[UILabel alloc] init];
    againLabel.frame = CGRectMake(xGap-10, yOffset+8, labelWidth, labelHeight);
    [againLabel setBackgroundColor:[UIColor clearColor]];
    [againLabel setTextAlignment:NSTextAlignmentCenter];
    [againLabel setText:[_baseNameArr objectAtIndex:WXT_Regist_OtherPhone]];
    [againLabel setTextColor:WXColorWithInteger(0x000000)];
    [againLabel setFont:WXFont(15.0)];
    [self addSubview:againLabel];
    
    _otherPhone = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, width, height)];
    [_otherPhone setReturnKeyType:UIReturnKeyDone];
//    [_otherPhone setSecureTextEntry:YES];
    [_otherPhone addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_otherPhone addTarget:self action:@selector(showKeyBoard)  forControlEvents:UIControlEventEditingDidBegin];
    [_otherPhone setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_otherPhone setTextColor:WXColorWithInteger(0xda7c7b)];
    [_otherPhone setTintColor:WXColorWithInteger(0xdd2726)];
    [_otherPhone setLeftViewMode:UITextFieldViewModeAlways];
    [_otherPhone setKeyboardType:UIKeyboardTypeASCIICapable];
    [_otherPhone setPlaceHolder:@"再次输入密码" color:WXColorWithInteger(0xd0d0d0)];
    [_otherPhone setFont:WXTFont(fontSize)];
    [self addSubview:_otherPhone];
    
    yOffset += height+5;
    UILabel *leftLine4 = [[UILabel alloc] init];
    leftLine4.frame = CGRectMake(xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine4 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine4];
    
    UILabel *downLine3 = [[UILabel alloc] init];
    downLine3.frame = CGRectMake(xGap1, yOffset, Size.width-2*xGap1, 0.5);
    [downLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:downLine3];
    
    UILabel *leftLine9 = [[UILabel alloc] init];
    leftLine9.frame = CGRectMake(xGap1+labelWidth, yOffset-lineHeight, 0.5, lineHeight);
    [leftLine9 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:leftLine9];
    
    UILabel *rightLine3 = [[UILabel alloc] init];
    rightLine3.frame = CGRectMake(Size.width-xGap1, yOffset-lineHeight, 0.5, lineHeight);
    [rightLine3 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:rightLine3];
}

#pragma mark keyboard
-(void)showKeyBoard{
}

- (void)hideKeyBoardDur{
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
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model forgetPwdWithUserPhone:_userTextField.text];
    [self startFetchPwdTiming];
    [_gainBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
}

-(void)forgetPwdSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:[NSString stringWithFormat:@"验证码已经发送到你的号码为%@的手机上，请注意查收",_userTextField.text]];
}

-(void)forgetPwdFailed:(NSString *)errorMsg{
    [self unShowWaitView];
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
    if([_pwdTextfield.text isEqualToString:_otherPhone.text]){
        [UtilTool showAlertView:@"两次密码不相同"];
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
-(void)resetNewPwd{
    [self textFieldResighFirstResponder];
    if(![self checkRegistInfo]){
        return;
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_resetModel resetNewPwdWithUserPhone:_userTextField.text withCode:[_fetchPwd.text integerValue] withNewPwd:_pwdTextfield.text];
}

-(void)resetNewPwdSucceed{
    [self unShowWaitView];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    [userDefault setUser:_userTextField.text];
    [userDefault setPwd:_pwdTextfield.text];
    
    WXTUITabbarVC *tabbar = [[WXTUITabbarVC alloc] init];
    WXUINavigationController *nav = [[WXUINavigationController alloc] initWithRootViewController:tabbar];
    [self presentViewController:nav animated:YES completion:^{
        WXTDatabase * database = [WXTDatabase shareDatabase];
        [database createDatabase:userDefault.wxtID];
        [[NewWXTLiDB sharedWXLibDB] loadData];
    }];
}

-(void)resetNewPwdFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
