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

#define UserPhoneLength (11)
#define Size self.view.bounds.size

@interface RegistVC()<RegistDelegate>{
    WXTUITextField *_userTextField;
    WXTUIButton *gainBtn;
    RegistModel *_model;
}
@end

@implementation RegistVC

-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard) name:UIKeyboardDidShowNotification object:nil];
        _model = [[RegistModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0x0c8bdf)];
    
    [self createLoginBtn];
    [self createUI];
}

-(void)createLoginBtn{
    CGFloat yOffset = 60;
    CGFloat xOffset = 20;
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 20;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(Size.width-xOffset-btnWidth, yOffset, btnWidth, btnHeight);
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn setTitle:@"我信通登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [loginBtn addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

-(void)createUI{
    CGFloat yOffset = 120;
    CGFloat xOffset = 10;
    CGFloat textHeight = 40;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, textHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"新用户注册，即可立即领取话费，用于语音通话！注册快速安全，绝不扣取任何费用"];
    [textLabel setFont:WXTFont(14.0)];
    [textLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [textLabel setNumberOfLines:0];
    [self.view addSubview:textLabel];
    
    
    yOffset += textHeight+40;
    CGFloat numHeight = 40;
    _userTextField = [[WXTUITextField alloc] init];
    _userTextField.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, numHeight);
    [_userTextField setBackgroundColor:WXColorWithInteger(0xd3f0fb)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
    [_userTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField setBorderRadian:5.0 width:1.0 color:WXColorWithInteger(0xFFFFFF)];
    [_userTextField setTextColor:WXColorWithInteger(0x323232)];
    [_userTextField setPlaceHolder:@"请输入您的手机号码" color:WXColorWithInteger(0x9d9d9d)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(16.0)];
    [self.view addSubview:_userTextField];
    
    yOffset += numHeight+30;
    CGFloat btnHeight = 40;
    gainBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    gainBtn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, btnHeight);
    [gainBtn setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0xacd1df)];
    [gainBtn setBackgroundColor:[UIColor clearColor]];
    [gainBtn setEnabled:NO];
    [gainBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    [gainBtn setTitleColor:WXColorWithInteger(0xacd1df) forState:UIControlStateNormal];
    [gainBtn addTarget:self action:@selector(gainMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gainBtn];
}

-(void)showKeyBoard{
    [gainBtn setEnabled:YES];
    [gainBtn setBackgroundColor:WXColorWithInteger(0xFFFFFF)];
    [gainBtn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [gainBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateNormal];
    [gainBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateSelected];
}

-(void)gotoLogin{
    
}

-(void)gainMoney{
    if(_userTextField.text.length != UserPhoneLength){
        [UtilTool showAlertView:@"注册的手机格式不正确"];
        return;
    }
    [self showWaitView];
    [_model registWithUserPhone:_userTextField.text];
}

#pragma mark registerDelegate
-(void)registSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"注册成功"];
}

-(void)registFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

-(void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

@end
