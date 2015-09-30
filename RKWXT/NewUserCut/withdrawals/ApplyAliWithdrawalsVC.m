//
//  ApplyAliWithdrawalsVC.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ApplyAliWithdrawalsVC.h"
#import "UserAliEntity.h"
#import "ApplyAliModel.h"
#import "ConfirmUserAliPayVC.h"

#define size self.bounds.size

@interface ApplyAliWithdrawalsVC ()<ApplyAliModelDelegate>{
    UserAliEntity *aliEntity;
    UITextField *_userTextField;
    
    ApplyAliModel *_model;
}

@end

@implementation ApplyAliWithdrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"提现"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    aliEntity = _entity;
    
    [self createNavRightBtn];
    [self createUserwithdrawalsInfoView];
    [self createSubmitBtn];
    
    _model = [[ApplyAliModel alloc] init];
    [_model setDelegate:self];
}

-(void)createNavRightBtn{
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"修改" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(14.0)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(gotoChangeUserWithdrawalsInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:rightBtn];
}

-(void)createUserwithdrawalsInfoView{
    WXUIView *bgView = [[WXUIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    CGFloat xGap = 14;
    CGFloat yGap = 17;
    
    CGFloat labelWidth = 72;
    CGFloat labelHeight = 19;
    
    CGFloat infoLabelWidth = 140;
    CGFloat infoLabelHeight = labelHeight;
    
    CGFloat xOffset = xGap;
    CGFloat yOffset = yGap;
    WXUILabel *accountLabel = [[WXUILabel alloc] init];
    accountLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [accountLabel setBackgroundColor:[UIColor clearColor]];
    [accountLabel setTextAlignment:NSTextAlignmentLeft];
    [accountLabel setText:@"支付宝"];
    [accountLabel setFont:WXFont(16.0)];
    [accountLabel setTextColor:WXColorWithInteger(0x000000)];
    [self addSubview:accountLabel];
    
    WXUILabel *accountInfo = [[WXUILabel alloc] init];
    accountInfo.frame = CGRectMake(xOffset+labelWidth, yOffset, infoLabelWidth+20, infoLabelHeight);
    [accountInfo setBackgroundColor:[UIColor clearColor]];
    [accountInfo setTextAlignment:NSTextAlignmentLeft];
    [accountInfo setText:aliEntity.aliCount];
    [accountInfo setFont:WXFont(15.0)];
    [accountInfo setTextColor:WXColorWithInteger(0x000000)];
    [self addSubview:accountInfo];
    
    yOffset += infoLabelHeight+yGap;
    WXUILabel *line1 = [[WXUILabel alloc] init];
    line1.frame = CGRectMake(0, yOffset, size.width, 0.5);
    [line1 setBackgroundColor:[UIColor grayColor]];
    [self addSubview:line1];
    
    yOffset += 0.5+yGap;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setText:@"姓名"];
    [nameLabel setFont:WXFont(16.0)];
    [nameLabel setTextColor:WXColorWithInteger(0x000000)];
    [self addSubview:nameLabel];
    
    WXUILabel *nameInfo = [[WXUILabel alloc] init];
    nameInfo.frame = CGRectMake(xOffset+labelWidth, yOffset, infoLabelWidth, infoLabelHeight);
    [nameInfo setBackgroundColor:[UIColor clearColor]];
    [nameInfo setTextAlignment:NSTextAlignmentLeft];
    [nameInfo setText:aliEntity.aliName];
    [nameInfo setFont:WXFont(15.0)];
    [nameInfo setTextColor:WXColorWithInteger(0x000000)];
    [self addSubview:nameInfo];
    
    yOffset += infoLabelHeight+yGap;
    WXUILabel *line2 = [[WXUILabel alloc] init];
    line2.frame = CGRectMake(0, yOffset, size.width, 0.5);
    [line2 setBackgroundColor:[UIColor grayColor]];
    [self addSubview:line2];
    
    yOffset += 0.5+yGap;
    WXUILabel *moneyLabel = [[WXUILabel alloc] init];
    moneyLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [moneyLabel setBackgroundColor:[UIColor clearColor]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [moneyLabel setText:@"金额(元)"];
    [moneyLabel setFont:WXFont(16.0)];
    [moneyLabel setTextColor:WXColorWithInteger(0x000000)];
    [self addSubview:moneyLabel];
    
    _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset+labelWidth, yOffset, infoLabelWidth, infoLabelHeight)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_userTextField setTintColor:WXColorWithInteger(0xdd2726)];
    [_userTextField setPlaceholder:@"请输入金额"];
    [_userTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(15.0)];
    [self addSubview:_userTextField];
    
    yOffset += yGap+infoLabelHeight;
    bgView.frame = CGRectMake(0, 0, size.width, yOffset);
}

-(void)createSubmitBtn{
    CGFloat xOffset = 14;
    CGFloat yOffset = 165;
    CGFloat labelWidth = 140;
    CGFloat labelHeight = 30;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"金额提现10元起"];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setFont:WXFont(15.0)];
    [self addSubview:textLabel];
    
    yOffset += 27+labelHeight;
    CGFloat xGap = 7;
    CGFloat btnHeight = 44;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(xGap, yOffset, size.width-2*xGap, btnHeight);
    [submitBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
    [submitBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [submitBtn setTitle:@"确定提现" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitUserWithdrawalsInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
}

#pragma mark textfield
-(void)textFieldDone:(id)sender{
    UITextField *textField = sender;
    [textField resignFirstResponder];
}

//提现
-(void)submitUserWithdrawalsInfo{
    if(_userTextField.text.length == 0){
        [UtilTool showAlertView:@"请输入提现金额"];
        return;
    }
    if([_userTextField.text floatValue] < 10){
        [UtilTool showAlertView:@"金额满10元才可以提现"];
        return;
    }
    if([_userTextField.text floatValue] > _money){
        [UtilTool showAlertView:@"对不起，账户余额不足"];
        return;
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model applyAliMoney:[_userTextField.text floatValue]];
}

-(void)applyAliMoneySucceed{
    [self unShowWaitView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:[_userTextField.text floatValue] forKey:ApplySucceed];
    
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)applyAliMoneyFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"申请提现失败";
    }
    [UtilTool showAlertView:errorMsg];
}

//修改提现信息
-(void)gotoChangeUserWithdrawalsInfoVC{
    ConfirmUserAliPayVC *confirmVC = [[ConfirmUserAliPayVC alloc] init];
    confirmVC.titleString = @"修改";
    confirmVC.aliAcount = aliEntity.aliCount;
    confirmVC.userName = aliEntity.aliName;
    [self.wxNavigationController pushViewController:confirmVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
