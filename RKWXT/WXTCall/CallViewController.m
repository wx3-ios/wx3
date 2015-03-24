//
//  CallViewController.m
//  AiCall
//
//  Created by jjyo.kwan on 13-11-26.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//
#import "CallViewController.h"
#import "WXTMallVC.h"
#import "WXTUITabBarController.h"
#import "CallBackVC.h"

#define Size self.view.bounds.size

@interface CallViewController (){
    UIView *_keybView;
    UILabel *_textLabel;
    NSString *textString;
    NSArray *_numSelArr;
    NSArray *_numNorArr;
}


@end

@implementation CallViewController

-(id)init{
    self = [super init];
    if(self){
        _numSelArr = @[@"1S.png",@"2S.png",@"3S.png",@"4S.png",@"5S.png",@"6S.png",@"7S.png",@"8S.png",@"9S.png",@"*S.png",@"0S.png",@"#S.png"];
        _numNorArr = @[@"1N.png",@"2N.png",@"3N.png",@"4N.png",@"5N.png",@"6N.png",@"7N.png",@"8N.png",@"9N.png",@"*N.png",@"0N.png",@"#N.png"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.keyPad_type = E_KeyPad_Show; //键盘
    self.downview_type = DownView_show;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    textString = [[NSString alloc] init];
    
    [self createKeyboardView];
    [self addNotification];
}

-(void)addNotification{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(show) name:ShowKeyBoard object:nil];
    [defaultCenter addObserver:self selector:@selector(callPhoneNumber) name:CallPhone object:nil];
}

-(void)createKeyboardView{
    _keybView = [[UIView alloc] init];
    _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-InputTextHeight-72-50-4*NumberBtnHeight, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight+InputTextHeight);
    [_keybView setBackgroundColor:WXColorWithInteger(0xe6e6e6)];
    [self.view addSubview:_keybView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, InputTextHeight);
    [_textLabel setBackgroundColor:WXColorWithInteger(0xe6e6e6)];
    [_textLabel setText:@"请输入电话号码"];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setFont:WXTFont(16.0)];
    [_textLabel setTextColor:[UIColor grayColor]];
    [_keybView addSubview:_textLabel];
    
    UIImage *eyeImg = [UIImage imageNamed:@"keyboardEye.png"];
    WXTUIButton *eyeBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(15, (InputTextHeight-eyeImg.size.height)/2, eyeImg.size.width, eyeImg.size.height);
    [eyeBtn setBackgroundColor:[UIColor clearColor]];
    [eyeBtn setImage:eyeImg forState:UIControlStateNormal];
    [_keybView addSubview:eyeBtn];
    
    UIImage *img = [UIImage imageNamed:@"delNumber.png"];
    WXTUIButton *delBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(Size.width-img.size.width-15, (InputTextHeight-img.size.height)/2, img.size.width, img.size.height);
    [delBtn setBackgroundColor:[UIColor clearColor]];
    [delBtn setImage:img forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_keybView addSubview:delBtn];
    
    CGFloat numBtnWidth = Size.width/3;
    NSInteger line = -1;
    for(int j = 0;j < 4; j++){
        for(int i = 0;i < 3; i++){
            line ++;
            WXUIButton *numBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            numBtn.frame = CGRectMake(i*numBtnWidth, j*NumberBtnHeight+InputTextHeight, numBtnWidth-(i<2?0.5:-2), NumberBtnHeight-(j<3?0.5:0));
            [numBtn setImage:[UIImage imageNamed:_numNorArr[line]] forState:UIControlStateNormal];
            [numBtn setImage:[UIImage imageNamed:_numSelArr[line]] forState:UIControlStateSelected];
            [numBtn setBackgroundImageOfColor:WXColorWithInteger(0xFAFAFA) controlState:UIControlStateNormal];
            [numBtn setBackgroundImageOfColor:WXColorWithInteger(0x2b9be5) controlState:UIControlStateSelected];
            [numBtn setTag:line];
            [numBtn addTarget:self action:@selector(numberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_keybView addSubview:numBtn];
        }
    }
}

-(void)numberBtnClicked:(id)sender{
    WXUIButton *btn = sender;
    NSInteger number = (btn.tag+1==11?0:btn.tag+1);
    if(number <= 9 && number >= 0){
        NSString *str = [NSString stringWithFormat:@"%ld",(long)number];
        textString = [textString stringByAppendingString:str];
        [_textLabel setText:textString];
    }
    
    if(textString.length > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:InputNumber object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownKeyBoard object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kInputChange object:nil];
    }
}

-(void)show{
    if(self.keyPad_type == E_KeyPad_Show){
        self.keyPad_type = E_KeyPad_Down;
        _downview_type = DownView_Del;
        if(textString.length > 0){
            _downview_type = DownView_show;
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowDownView object:nil];
        }
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-72-50, Size.width, 4*NumberBtnHeight);
        }];
        return;
    }
    if(self.keyPad_type == E_KeyPad_Down){
        self.keyPad_type = E_KeyPad_Show;
        if(textString.length > 0){
            _downview_type = DownView_show;
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowDownView object:nil];
        }else{
            _downview_type = DownView_Del;
            [[NSNotificationCenter defaultCenter] postNotificationName:HideDownView object:nil];
        }
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-72-50-4*NumberBtnHeight-InputTextHeight, Size.width, 4*NumberBtnHeight+InputTextHeight);
//            if(Size.width>320){ //简单判断一下是苹果6及以上
//                _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50-4*NumberBtnHeight, Size.width, 4*NumberBtnHeight);
//            }
        }];
        return;
    }
    if(self.keyPad_type == E_KeyPad_Noraml){
        self.keyPad_type = E_KeyPad_Show;
    }
}

-(void)down{
    if (self.keyPad_type == E_KeyPad_Down) {
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-72-50-4*NumberBtnHeight, Size.width, 4*NumberBtnHeight);
        }];
    }
}

-(void)delBtnClick{
    NSString *callStrString = _textLabel.text;
    if(callStrString.length > 0){
        NSRange rang = NSMakeRange(0, callStrString.length-1);
        NSString *strRang = [callStrString substringWithRange:rang];
        _textLabel.text = strRang;
        textString = _textLabel.text;
    }
    if(textString.length == 0){
        _downview_type = DownView_Del;
//        [_textLabel setText:@"输入号码搜索"];
        [[NSNotificationCenter defaultCenter] postNotificationName:DelNumberToEnd object:nil];
    }
}

-(void)callPhoneNumber{
    if(textString.length < 7){
        [UtilTool showAlertView:@"您所拨打的电话格式不正确"];
        return;
    }
//    [_callModel makeCallPhone:textString];
    if(_callDelegate && [_callDelegate respondsToSelector:@selector(callPhoneWith:)]){
        [_callDelegate callPhoneWith:textString];
    }
}

//#pragma callDelegate
//-(void)makeCallPhoneFailed:(NSString *)failedMsg{
//    if(!failedMsg){
//        failedMsg = @"呼叫失败";
//    }
//    [UtilTool showAlertView:failedMsg];
//}
//
//-(void)makeCallPhoneSucceed{
//    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
//    CallBackVC *callBackVC = [[CallBackVC alloc] init];
//    [callBackVC setPhoneName:textString];
//    [callBackVC setUserPhone:userObj.user];
//    [self.navigationController pushViewController:callBackVC animated:YES];
//}

-(void)viewWillDisappear:(BOOL)animated{
//    [_callModel setCallDelegate:nil];
    self.keyPad_type = E_KeyPad_Down;
}

@end
