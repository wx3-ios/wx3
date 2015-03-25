//
//  RechargeView.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeView.h"
#import "RechargeModel.h"

#define EveryCellHeight (44)
#define Size self.bounds.size

@interface RechargeView()<RechargeDelegate>{
    UITextField *_numTextfield;
    UITextField *_pwdTextfield;
    RechargeModel *_model;
}
@end

@implementation RechargeView

-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyBoardWillHiden) name: UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setFrame:CGRectMake(0, ViewBigDistance, Size.width, RechargeViewHeight)];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _model = [[RechargeModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGFloat xOffset = 19;
    CGFloat numWidth = 36;
    CGFloat numHeight = 17;
    UILabel *upLine1 = [[UILabel alloc] init];
    upLine1.frame = CGRectMake(0, 0, Size.width, 0.5);
    [upLine1 setBackgroundColor:WXColorWithInteger(0x969696)];
    [self addSubview:upLine1];
    
    UILabel *cartLabel = [[UILabel alloc] init];
    cartLabel.frame = CGRectMake(xOffset, (EveryCellHeight-numHeight)/2+0.6, numWidth, numHeight);
    [cartLabel setBackgroundColor:[UIColor clearColor]];
    [cartLabel setTextAlignment:NSTextAlignmentCenter];
    [cartLabel setFont:WXTFont(14.0)];
    [cartLabel setText:@"卡号:"];
    [cartLabel setTextColor:WXColorWithInteger(0x323232)];
    [self addSubview:cartLabel];
    
    xOffset += numWidth+10;
    CGFloat textfieldWidth = 200;
    CGFloat textfieldHeight = numHeight;
    _numTextfield = [[UITextField alloc] init];
    _numTextfield.frame = CGRectMake(xOffset, (EveryCellHeight-numHeight)/2, textfieldWidth, textfieldHeight);
    [_numTextfield setKeyboardType:UIKeyboardTypePhonePad];
    [_numTextfield setPlaceholder:@"请输入卡号"];
    [_numTextfield setTextColor:WXColorWithInteger(0x323232)];
    [_numTextfield setFont:WXTFont(14.0)];
    [_numTextfield addTarget:self action:@selector(startInput) forControlEvents:UIControlEventEditingDidBegin];
    [_numTextfield addTarget:self action:@selector(textfieldReturn:) forControlEvents:UIControlEventTouchDragExit];
    [self addSubview:_numTextfield];
    
    xOffset -= numWidth;
    CGFloat yOffset = EveryCellHeight;
    UILabel *upLine = [[UILabel alloc] init];
    upLine.frame = CGRectMake(xOffset, yOffset, Size.width-xOffset, 0.5);
    [upLine setBackgroundColor:WXColorWithInteger(0x969696)];
    [self addSubview:upLine];
    
    yOffset += (EveryCellHeight-numHeight)/2;
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.frame = CGRectMake(xOffset-10, yOffset, numWidth, numHeight);
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextAlignment:NSTextAlignmentCenter];
    [pwdLabel setFont:WXTFont(14.0)];
    [pwdLabel setText:@"密码:"];
    [cartLabel setTextColor:WXColorWithInteger(0x323232)];
    [self addSubview:pwdLabel];
    
    xOffset += numWidth;
    _pwdTextfield = [[UITextField alloc] init];
    _pwdTextfield.frame = CGRectMake(xOffset, yOffset, textfieldWidth, textfieldHeight);
    [_pwdTextfield setKeyboardType:UIKeyboardTypePhonePad];
    [_pwdTextfield setPlaceholder:@"请输入密码"];
    [_pwdTextfield setTextColor:WXColorWithInteger(0x323232)];
    [_pwdTextfield setFont:WXTFont(14.0)];
    [_pwdTextfield addTarget:self action:@selector(startInput) forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextfield addTarget:self action:@selector(textfieldReturn:) forControlEvents:UIControlEventTouchDragExit];
    [self addSubview:_pwdTextfield];
    
    yOffset = 2*EveryCellHeight;
    UILabel *downLine = [[UILabel alloc] init];
    downLine.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0x969696)];
    [self addSubview:downLine];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, yOffset, Size.width/2-0.5, EveryCellHeight);
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WXColorWithInteger(0x969696) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WXColorWithInteger(0x969696) forState:UIControlStateSelected];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(Size.width/2-0.5, yOffset, 0.5, EveryCellHeight);
    [line setBackgroundColor:WXColorWithInteger(0x969696)];
    [self addSubview:line];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(Size.width/2, yOffset, Size.width/2, EveryCellHeight-1);
    [okBtn setBackgroundColor:[UIColor clearColor]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateSelected];
    [okBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    yOffset += EveryCellHeight;
    UILabel *downLine1 = [[UILabel alloc] init];
    downLine1.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [downLine1 setBackgroundColor:WXColorWithInteger(0x969696)];
    [self addSubview:downLine1];
}

-(void)textfieldReturn:(id)sender{
    UITextField *textfield = sender;
    [textfield resignFirstResponder];
}

-(void)keyBoardWillHiden{
    [self setFrame:CGRectMake(0, ViewNormalDistance, Size.width, RechargeViewHeight)];
}

-(void)startInput{
    [self setFrame:CGRectMake(0, ViewUpDistance-50, Size.width, RechargeViewHeight)];
}

-(void)cancel{
    [_numTextfield setText:nil];
    [_pwdTextfield setText:nil];
    if(_delegate && [_delegate respondsToSelector:@selector(rechargeCancel)]){
        [_delegate rechargeCancel];
    }
}

-(void)submit{
//    if(_numTextfield.text.length < 6 || _pwdTextfield.text.length < 6){
//        [UtilTool showAlertView:@"帐号或密码格式错误"];
//        return;
//    }
    NSString *numberStr = _numTextfield.text;
    NSString *pwdStr = _pwdTextfield.text;
    [_model rechargeWithCardNum:numberStr andPwd:pwdStr];
}

-(void)rechargeSucceed{
    [_numTextfield setText:nil];
    [_pwdTextfield setText:nil];
    [UtilTool showAlertView:@"充值成功"];
}

-(void)rechargeFailed:(NSString *)errorMsg{
    if(!errorMsg){
        [UtilTool showAlertView:@"充值失败"];
        return;
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
