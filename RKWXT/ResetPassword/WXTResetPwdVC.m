//
//  WXTResetPwdVC.m
//  RKWXT
//
//  Created by SHB on 15/3/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTResetPwdVC.h"
#import "WXTUITextField.h"
#import "ResetPwdModel.h"

#define Size self.view.bounds.size

@interface WXTResetPwdVC ()<UIScrollViewDelegate,ResetPwdDelegate>{
    UIScrollView *_scrollerView;
    
    WXTUITextField *_oldPwdField;
    WXTUITextField *_newPwdField;
    WXTUITextField *_confirmPwd;
    
    ResetPwdModel *_model;
}

@end

@implementation WXTResetPwdVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"修改密码";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height-66);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height-66+10)];
    [self.view addSubview:_scrollerView];
   
    [self createBaseView];
    [self createCompleteBtn];
    
    _model = [[ResetPwdModel alloc] init];
    [_model setDelegate:self];
}

-(void)createBaseView{
    CGFloat xOffset = 15;
    CGFloat yOffset = 15;
    CGFloat textFieldHeight = 41;
    _oldPwdField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, Size.width-2*xOffset, textFieldHeight)];
    [_oldPwdField setReturnKeyType:UIReturnKeyDone];
    [_oldPwdField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_oldPwdField setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_oldPwdField setTextColor:[UIColor grayColor]];
    [_oldPwdField setTintColor:[UIColor blackColor]];
    [_oldPwdField setBackgroundColor:[UIColor whiteColor]];
    [_oldPwdField setPlaceHolder:@"请输入旧密码" color:[UIColor grayColor]];
    [_oldPwdField setTextAlignment:NSTextAlignmentCenter];
    [_scrollerView addSubview:_oldPwdField];
    
    
    yOffset += textFieldHeight+10;
    _newPwdField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, Size.width-2*xOffset, textFieldHeight)];
    [_newPwdField setReturnKeyType:UIReturnKeyDone];
    [_newPwdField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_newPwdField setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_newPwdField setTextColor:[UIColor grayColor]];
    [_newPwdField setTintColor:[UIColor blackColor]];
    [_newPwdField setBackgroundColor:[UIColor whiteColor]];
    [_newPwdField setTextAlignment:NSTextAlignmentCenter];
    [_newPwdField setPlaceHolder:@"请输入新密码" color:[UIColor grayColor]];
    [_scrollerView addSubview:_newPwdField];
    
    yOffset += textFieldHeight+10;
    _confirmPwd = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, Size.width-2*xOffset, textFieldHeight)];
    [_confirmPwd setReturnKeyType:UIReturnKeyDone];
    [_confirmPwd addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_confirmPwd setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_confirmPwd setTextColor:[UIColor grayColor]];
    [_confirmPwd setBackgroundColor:[UIColor whiteColor]];
    [_confirmPwd setTintColor:[UIColor blackColor]];
    [_confirmPwd setTextAlignment:NSTextAlignmentCenter];
    [_confirmPwd setPlaceHolder:@"再次输入新密码" color:[UIColor grayColor]];
    [_scrollerView addSubview:_confirmPwd];
}

-(void)createCompleteBtn{
    CGFloat yOffset = 170;
    CGFloat xOffset = 10;
    CGFloat btnHeight = 44;
    WXTUIButton *completeBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, btnHeight);
    [completeBtn setBackgroundColor:WXColorWithInteger(0x0c8bdf)];
    [completeBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(complieteResetPwd) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:completeBtn];
}

-(void)complieteResetPwd{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    if(!_oldPwdField.text){
        [UtilTool showAlertView:@"请输入旧密码"];
        return;
    }
    if(![_oldPwdField.text isEqualToString:userObj.pwd]){
        [UtilTool showAlertView:@"您输入的旧密码错误，如果您已经忘记，请在登录页面点击忘记密码找回"];
        return;
    }
    if(!_newPwdField.text || !_confirmPwd.text){
        [UtilTool showAlertView:@"请输入您要设置的新密码"];
        return;
    }
    if(_newPwdField.text.length < 6){
        [UtilTool showAlertView:@"新密码长度不能小于6位"];
        return;
    }
    
    if(![_newPwdField.text isEqualToString:_confirmPwd.text]){
        [UtilTool showAlertView:@"两次输入的新密码不相同"];
        return;
    }
    if([_newPwdField.text isEqualToString:_oldPwdField.text]){
        [UtilTool showAlertView:@"新密码不能设置与旧密码相同，请重新设置"];
        return;
    }
    
    [self showWaitView:self.view];
    [self resignAllFirstResponder];
    [_model resetPwdWithNewPwd:_newPwdField.text];
}

-(void)resetPwdSucceed{
    [self unShowWaitView];
    [self clearTextField];
    [UtilTool showAlertView:@"密码修改成功"];
}

-(void)resetPwdFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"密码重置失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self resignAllFirstResponder];
}

-(void)clearTextField{
    _oldPwdField.text = @"";
    _newPwdField.text = @"";
    _confirmPwd.text = @"";
}

-(void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

-(void)resignAllFirstResponder{
    [_oldPwdField resignFirstResponder];
    [_newPwdField resignFirstResponder];
    [_confirmPwd resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignAllFirstResponder];
    [_model setDelegate:nil];
}

@end
