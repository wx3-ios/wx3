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
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"重置密码"];
//    self.backgroundColor = WXColorWithInteger(0xefeff4);
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height-66);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height-66+10)];
//    [self.view addSubview:_scrollerView];
   
    [self createBaseView];
    [self createCompleteBtn];
    
    _model = [[ResetPwdModel alloc] init];
    [_model setDelegate:self];
}

-(void)createBaseView{
    CGFloat lineHeight = 10;
    CGFloat xGap = 16;
    CGFloat yGap = 20;
    CGFloat xOffset = 31;
    CGFloat yOffset = 20;
    CGFloat textFieldHeight = 20;
    _oldPwdField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, Size.width-2*xOffset-66, textFieldHeight)];
    [_oldPwdField setReturnKeyType:UIReturnKeyDone];
    [_oldPwdField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_oldPwdField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_oldPwdField setTextColor:[UIColor grayColor]];
    [_oldPwdField setTintColor:[UIColor blackColor]];
    [_oldPwdField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_oldPwdField setBackgroundColor:[UIColor clearColor]];
    [_oldPwdField setPlaceHolder:@"请输入旧密码" color:WXColorWithInteger(0xb0b0b0)];
    [_oldPwdField setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_oldPwdField];
    
    yGap += textFieldHeight+15;
    UILabel *oldPwdLine1 = [[UILabel alloc] init];
    oldPwdLine1.frame = CGRectMake(xGap, yGap-lineHeight, 0.5, lineHeight);
    [oldPwdLine1 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:oldPwdLine1];
    
    UILabel *oldPwdLine2 = [[UILabel alloc] init];
    oldPwdLine2.frame = CGRectMake(xGap, yGap, Size.width-2*xGap, 0.5);
    [oldPwdLine2 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:oldPwdLine2];
    
    UILabel *oldPwdLine3 = [[UILabel alloc] init];
    oldPwdLine3.frame = CGRectMake(Size.width-xGap, yGap-lineHeight, 0.5, lineHeight);
    [oldPwdLine3 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:oldPwdLine3];
    
    UILabel *oldPwdLine4 = [[UILabel alloc] init];
    oldPwdLine4.frame = CGRectMake(Size.width-xGap-66, yGap-lineHeight, 0.5, lineHeight);
    [oldPwdLine4 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:oldPwdLine4];
    
    UIImage *img = [UIImage imageNamed:@"ResetPwdNorlImg.png"];
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.frame = CGRectMake(Size.width-xGap-66+(66-img.size.width)/2, yGap-20-img.size.height, img.size.width, img.size.height);
    [imgView1 setImage:img];
    [self addSubview:imgView1];
    
    
    yOffset = yGap+20;
    _newPwdField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, Size.width-2*xOffset-66, textFieldHeight)];
    [_newPwdField setReturnKeyType:UIReturnKeyDone];
    [_newPwdField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_newPwdField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_newPwdField setTextColor:[UIColor grayColor]];
    [_newPwdField setTintColor:[UIColor blackColor]];
    [_newPwdField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_newPwdField setBackgroundColor:[UIColor clearColor]];
    [_newPwdField setTextAlignment:NSTextAlignmentLeft];
    [_newPwdField setPlaceHolder:@"请输入新密码" color:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:_newPwdField];
    
    yGap += yGap;
    UILabel *newPwdLine1 = [[UILabel alloc] init];
    newPwdLine1.frame = CGRectMake(xGap, yGap-lineHeight, 0.5, lineHeight);
    [newPwdLine1 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newPwdLine1];
    
    UILabel *newPwdLine2 = [[UILabel alloc] init];
    newPwdLine2.frame = CGRectMake(xGap, yGap, Size.width-2*xGap, 0.5);
    [newPwdLine2 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newPwdLine2];
    
    UILabel *newPwdLine3 = [[UILabel alloc] init];
    newPwdLine3.frame = CGRectMake(Size.width-xGap, yGap-lineHeight, 0.5, lineHeight);
    [newPwdLine3 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newPwdLine3];
    
    UILabel *newPwdLine4 = [[UILabel alloc] init];
    newPwdLine4.frame = CGRectMake(Size.width-xGap-66, yGap-lineHeight, 0.5, lineHeight);
    [newPwdLine4 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newPwdLine4];
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.frame = CGRectMake(Size.width-xGap-66+(66-img.size.width)/2, yGap-20-img.size.height, img.size.width, img.size.height);
    [imgView2 setImage:img];
    [self addSubview:imgView2];
    
    
    yOffset = yGap+20;
    _confirmPwd = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, Size.width-2*xOffset-66, textFieldHeight)];
    [_confirmPwd setReturnKeyType:UIReturnKeyDone];
    [_confirmPwd addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_confirmPwd setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_confirmPwd setTextColor:[UIColor grayColor]];
    [_confirmPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    [_confirmPwd setBackgroundColor:[UIColor clearColor]];
    [_confirmPwd setTintColor:[UIColor blackColor]];
    [_confirmPwd setTextAlignment:NSTextAlignmentLeft];
    [_confirmPwd setPlaceHolder:@"再次输入新密码" color:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:_confirmPwd];
    
    yGap += 55;
    UILabel *newLine1 = [[UILabel alloc] init];
    newLine1.frame = CGRectMake(xGap, yGap-lineHeight, 0.5, lineHeight);
    [newLine1 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newLine1];
    
    UILabel *newLine2 = [[UILabel alloc] init];
    newLine2.frame = CGRectMake(xGap, yGap, Size.width-2*xGap, 0.5);
    [newLine2 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newLine2];
    
    UILabel *newLine3 = [[UILabel alloc] init];
    newLine3.frame = CGRectMake(Size.width-xGap, yGap-lineHeight, 0.5, lineHeight);
    [newLine3 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newLine3];
    
    UILabel *newLine4 = [[UILabel alloc] init];
    newLine4.frame = CGRectMake(Size.width-xGap-66, yGap-lineHeight, 0.5, lineHeight);
    [newLine4 setBackgroundColor:WXColorWithInteger(0xb0b0b0)];
    [self addSubview:newLine4];
    
    UIImageView *imgView3 = [[UIImageView alloc] init];
    imgView3.frame = CGRectMake(Size.width-xGap-66+(66-img.size.width)/2, yGap-20-img.size.height, img.size.width, img.size.height);
    [imgView3 setImage:[UIImage imageNamed:@"ResetPwdSelImg.png"]];
    [self addSubview:imgView3];
}

-(void)createCompleteBtn{
    CGFloat yOffset = 200;
    CGFloat xOffset = 10;
    CGFloat btnHeight = 44;
    WXTUIButton *completeBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, btnHeight);
    [completeBtn setBorderRadian:10.0 width:1.0 color:[UIColor clearColor]];
    [completeBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [completeBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [completeBtn.titleLabel setFont:WXFont(18.0)];
    [completeBtn setTitle:@"确定提交" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(complieteResetPwd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:completeBtn];
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
    
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
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
