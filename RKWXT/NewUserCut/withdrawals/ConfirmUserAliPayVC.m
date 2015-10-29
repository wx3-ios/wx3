//
//  ConfirmUserAliPayVC.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ConfirmUserAliPayVC.h"
#import "ConfirmUserAliModel.h"
#import "AliSendMsgModel.h"
#import "NewUserCutVC.h"

#define size self.bounds.size
#define bgViewHeight (186)
#define kFetchPasswordDur (60)

@interface ConfirmUserAliPayVC ()<ConfirmUserAliModelDelegate,AliSendMsgModelDelegate>{
    UITextField *_userTextField;
    UITextField *_nameField;
    UITextField *_userPhoneField;
    UITextField *_codeField;
    
    WXTUIButton *_gainBtn;
    NSTimer *_fetchPWDTimer;
    NSInteger _fetchPasswordTime;
    
    ConfirmUserAliModel *_model;
    AliSendMsgModel *codeModel;
}

@end

@implementation ConfirmUserAliPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:_titleString];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    [self createBgView];
    [self createUserInfo];
    [self createConfirmBtn];
    
    _model = [[ConfirmUserAliModel alloc] init];
    [_model setDelegate:self];
    
    codeModel = [[AliSendMsgModel alloc] init];
    [codeModel setDelegate:self];
}

-(void)createBgView{
    WXUIView *bgView = [[WXUIView alloc] init];
    bgView.frame = CGRectMake(0, 0, size.width, bgViewHeight);
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
}

-(void)createUserInfo{
    CGFloat xGap = 12.0;
    CGFloat yGap = 14.0;
    
    CGFloat labelWidth = 78;
    CGFloat labelHeight = 18;
    WXUILabel *numLabel = [[WXUILabel alloc] init];
    numLabel.frame = CGRectMake(xGap, yGap, labelWidth, labelHeight);
    [numLabel setBackgroundColor:[UIColor clearColor]];
    [numLabel setText:@"支付宝账号"];
    [numLabel setTextAlignment:NSTextAlignmentLeft];
    [numLabel setTextColor:WXColorWithInteger(0x000000)];
    [numLabel setFont:WXFont(15.0)];
    [self addSubview:numLabel];
    
    CGFloat fontSize = 15.0;
    CGFloat filedWidth = 180;
    CGFloat filedHeight = labelHeight;
    _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yGap, filedWidth+10, filedHeight)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userTextField setTintColor:WXColorWithInteger(0xdd2726)];
    [_userTextField setPlaceholder:@"邮箱/手机号码"];
    [_userTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(fontSize)];
    [self addSubview:_userTextField];
    if(_aliAcount){
        [_userTextField setText:_aliAcount];
    }
    
    CGFloat yOffset = yGap+filedHeight+yGap;
    WXUILabel *lineLabel1 = [[WXUILabel alloc] init];
    lineLabel1.frame = CGRectMake(0, yOffset, size.width, 0.5);
    [lineLabel1 setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineLabel1];
    
    yOffset += yGap+0.5;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake(xGap, yOffset, labelWidth, labelHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:@"姓名"];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:WXColorWithInteger(0x000000)];
    [nameLabel setFont:WXFont(15.0)];
    [self addSubview:nameLabel];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, filedWidth+20, filedHeight)];
    [_nameField setReturnKeyType:UIReturnKeyDone];
    [_nameField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_nameField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_nameField setTintColor:WXColorWithInteger(0xdd2726)];
    [_nameField setLeftViewMode:UITextFieldViewModeAlways];
    [_nameField setPlaceholder:@"请输入支付宝账号绑定的姓名"];
    [_nameField setFont:WXTFont(fontSize)];
    [self addSubview:_nameField];
    if(_userName){
        [_nameField setText:_userName];
    }
    
    yOffset += yGap+filedHeight;
    WXUILabel *lineLabel2 = [[WXUILabel alloc] init];
    lineLabel2.frame = CGRectMake(0, yOffset, size.width, 0.5);
    [lineLabel2 setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineLabel2];
    
    yOffset += yGap+0.5;
    WXUILabel *phoneLabel = [[WXUILabel alloc] init];
    phoneLabel.frame = CGRectMake(xGap, yOffset, labelWidth, labelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setText:@"手机号"];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setTextColor:WXColorWithInteger(0x000000)];
    [phoneLabel setFont:WXFont(15.0)];
    [self addSubview:phoneLabel];
    
    
    _userPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, filedWidth, filedHeight)];
    [_userPhoneField setReturnKeyType:UIReturnKeyDone];
    [_userPhoneField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userPhoneField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userPhoneField setTintColor:WXColorWithInteger(0xdd2726)];
    [_userPhoneField setLeftViewMode:UITextFieldViewModeAlways];
    [_userPhoneField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_userPhoneField setEnabled:NO];
    [self addSubview:_userPhoneField];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    [_userPhoneField setText:userObj.user];
    
    yOffset += yGap+filedHeight;
    WXUILabel *lineLabel3 = [[WXUILabel alloc] init];
    lineLabel3.frame = CGRectMake(0, yOffset, size.width, 0.5);
    [lineLabel3 setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineLabel3];
    
    yOffset += yGap+0.5;
    WXUILabel *codeLabel = [[WXUILabel alloc] init];
    codeLabel.frame = CGRectMake(xGap, yOffset, labelWidth, labelHeight);
    [codeLabel setBackgroundColor:[UIColor clearColor]];
    [codeLabel setText:@"验证码"];
    [codeLabel setTextAlignment:NSTextAlignmentLeft];
    [codeLabel setTextColor:WXColorWithInteger(0x000000)];
    [codeLabel setFont:WXFont(15.0)];
    [self addSubview:codeLabel];
    
    CGFloat phoneWidth = 110;
    _codeField = [[UITextField alloc] initWithFrame:CGRectMake(xGap+labelWidth, yOffset, phoneWidth, filedHeight)];
    [_codeField setReturnKeyType:UIReturnKeyDone];
    [_codeField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_codeField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_codeField setTintColor:WXColorWithInteger(0xdd2726)];
    [_codeField setLeftViewMode:UITextFieldViewModeAlways];
    [_codeField setKeyboardType:UIKeyboardTypePhonePad];
    [_codeField setPlaceholder:@"请输入验证码"];
    [self addSubview:_codeField];
    
    CGFloat xOffset = _codeField.frame.origin.x+phoneWidth+5;
    WXUILabel *line = [[WXUILabel alloc] init];
    line.frame = CGRectMake(xOffset, yOffset-yGap, 0.5, 46);
    [line setBackgroundColor:[UIColor grayColor]];
    [self addSubview:line];
    
    xOffset += 5+0.5;
    CGFloat btnWidth = 90;
    _gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _gainBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, filedHeight);
    [_gainBtn setBackgroundColor:[UIColor clearColor]];
    [_gainBtn.titleLabel setFont:WXTFont(14.0)];
    [_gainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_gainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_gainBtn addTarget:self action:@selector(fecthCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gainBtn];
}

-(void)createConfirmBtn{
    CGFloat xOffset = 11;
    CGFloat yOffset = 26;
    CGFloat btnHeight = 45;
    WXUIButton *confirmBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(xOffset, bgViewHeight+yOffset, size.width-2*xOffset, btnHeight);
    [confirmBtn setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [confirmBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [confirmBtn setTitle:@"验证" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}

#pragma mark textfield
-(void)textFieldDone:(id)sender{
    UITextField *textField = sender;
    [textField resignFirstResponder];
}

- (void)textFieldResighFirstResponder{
    [_userTextField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_userPhoneField resignFirstResponder];
    [_codeField resignFirstResponder];
}

#pragma mark 数据是否有效~
- (BOOL)checkUserValide{
    if(_userTextField.text.length == 0){
        [UtilTool showAlertView:@"请输入支付宝账号"];
        return NO;
    }
    if(_nameField.text.length == 0){
        [UtilTool showAlertView:@"请输入姓名"];
        return NO;
    }
    if(_userPhoneField.text.length == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:_userPhoneField.text];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    if(_codeField.text.length == 0){
        [UtilTool showAlertView:@"请输入验证码"];
        return NO;
    }
    return YES;
}

-(BOOL)checkUserPhone{
    if(_userPhoneField.text.length == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:_userPhoneField.text];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}

#pragma mark delegate
-(void)fecthCode{
    if(![self checkUserPhone]){
        return;
    }
    if([_userTextField.text isEqualToString:_aliAcount] && [_nameField.text isEqualToString:_userName]){
        [UtilTool showAlertView:@"您的账户信息未修改"];
        return;
    }
    [codeModel sendALiMsg:_userPhoneField.text];
    [self startFetchPwdTiming];
    [_gainBtn setEnabled:NO];
    [self textFieldResighFirstResponder];
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

#pragma mark gainCode
-(void)sendALiMsgSucceed{
    [UtilTool showAlertView:[NSString stringWithFormat:@"验证码已经发送到你的号码为%@的手机上，请注意查收",_userPhoneField.text]];
}

-(void)sendALiMsgFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取验证码失败";
    }
    [self stopFetchPwdTiming];
    [self setFetchPasswordButtonTitle];
    [UtilTool showAlertView:errorMsg];
}

-(void)confirmUserInfo{
    [self textFieldResighFirstResponder];
    if(![self checkUserValide]){
        return;
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    if(_aliAcount.length != 0 && _userName.length != 0){
        if([_userTextField.text isEqualToString:_aliAcount] && [_nameField.text isEqualToString:_userName]){
            [self unShowWaitView];
            [UtilTool showAlertView:@"您的账户信息未修改"];
            return;
        }
        [_model confirmUserAliAcountWith:_userTextField.text with:_nameField.text with:UserAli_Change with:[_codeField.text integerValue] with:_userPhoneField.text];
    }else{
        if(_confirmType == Confirm_Type_Change){
            [_model confirmUserAliAcountWith:_userTextField.text with:_nameField.text with:UserAli_Change with:[_codeField.text integerValue] with:_userPhoneField.text];
        }else{
            [_model confirmUserAliAcountWith:_userTextField.text with:_nameField.text with:UserAli_Confirm with:[_codeField.text integerValue] with:_userPhoneField.text];
        }
    }
}

-(void)confirmUserAliAcountSucceed{
    [self unShowWaitView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:ConfirmSign];
    
    if(_aliAcount.length != 0 && _userName.length != 0){
        [UtilTool showAlertView:@"提现账号修改成功，请等待审核"];
        WXUINavigationController *navigationController = [CoordinateController sharedNavigationController];
        UIViewController *userCutVC = [navigationController lastViewControllerOfClass:NSClassFromString(@"NewUserCutVC")];
        [self.wxNavigationController popToViewController:userCutVC animated:YES Completion:^{
        }];
    }else{
        [UtilTool showAlertView:@"提现账号添加成功，请等待审核"];
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_ChangeUserWithdrawalsSucceed object:nil];
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)confirmUserAliAcountFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(_aliAcount.length != 0 && _userName.length != 0){
        if(!errorMsg){
            errorMsg = @"提现账号修改失败";
        }
        [UtilTool showAlertView:errorMsg];
    }else{
        if(!errorMsg){
            errorMsg = @"提现账号添加失败";
        }
        [UtilTool showAlertView:errorMsg];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
