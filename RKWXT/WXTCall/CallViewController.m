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
#import "CallModel.h"

#define Size self.view.bounds.size
#define NumberBtnHeight (56)
#define InputTextHeight (35)

@interface CallViewController (){
    UIView *_keybView;
    UILabel *_textLabel;
    NSString *textString;
    NSArray *_numSelArr;
    NSArray *_numNorArr;
    
    CallModel *_callModel;
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
    self.keyPad_type = E_KeyPad_Noraml; //键盘
    
//    _callModel = [[CallModel alloc] init];
//    [_callModel setCallDelegate:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _downview_type = DownView_Init;        //底部呼叫按钮
    textString = [[NSString alloc] init];
    
    [self createKeyboardView];
    [self addNotification];
//    [self createTextLabel];
}

-(void)addNotification{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(show) name:ShowKeyBoard object:nil];
//    [defaultCenter addObserver:self selector:@selector(callPhoneNumber) name:CallPhone object:nil];
//    [defaultCenter addObserver:self selector:@selector(delBtnClick) name:DelNumber object:nil];
}

-(void)createTextLabel{
    CGFloat btnWidth = 150;
    _textLabel = [[UILabel alloc] init];
    _textLabel.frame = CGRectMake((ScreenWidth-btnWidth)/2, 100, Size.width-btnWidth, InputTextHeight);
    [_textLabel setBackgroundColor:[UIColor grayColor]];
    [_textLabel setBorderRadian:4.0 width:0.5 color:[UIColor whiteColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setTextColor:[UIColor redColor]];
    [self.view addSubview:_textLabel];
}

-(void)createKeyboardView{
    _keybView = [[UIView alloc] init];
    _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50-4*NumberBtnHeight, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight);
    [_keybView setBackgroundColor:WXColorWithInteger(0xe6e6e6)];
    [self.view addSubview:_keybView];
    
    
    CGFloat numBtnWidth = IPHONE_SCREEN_WIDTH/3;
    NSInteger line = -1;
    for(int j = 0;j < 4; j++){
        for(int i = 0;i < 3; i++){
            line ++;
            WXUIButton *numBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            numBtn.frame = CGRectMake(i*numBtnWidth, j*NumberBtnHeight, numBtnWidth-(i<2?0.5:-2), NumberBtnHeight-(j<3?0.5:0));
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
//    NSInteger number = (btn.tag+1==11?0:btn.tag+1);
//    if(number <= 9 && number >= 0){
//        NSString *str = [NSString stringWithFormat:@"%ld",(long)number];
//        textString = [textString stringByAppendingString:str];
//        [_textLabel setText:textString];
//    }
//    
//    if(textString.length > 0){
//        [[NSNotificationCenter defaultCenter] postNotificationName:InputNumber object:nil];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:DownKeyBoard object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kInputChange object:nil];
//    }
    if(_inputDelegate && [_inputDelegate respondsToSelector:@selector(inputNumber:)]){
        [_inputDelegate inputNumber:btn];
    }
}

-(void)show{
    if(self.keyPad_type == E_KeyPad_Show){
        self.keyPad_type = E_KeyPad_Down;
        _downview_type = DownView_Del;
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight);
        }];
        return;
    }
    if(self.keyPad_type == E_KeyPad_Down){
        self.keyPad_type = E_KeyPad_Show;
        if(textString.length > 0){
            _downview_type = DownView_show;
        }else{
            _downview_type = DownView_Del;
        }
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50-4*NumberBtnHeight, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight);
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
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50-4*NumberBtnHeight, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight);
        }];
    }
}

-(void)delBtnClick{
//    NSString *callStrString = _textLabel.text;
//    if(callStrString.length > 0){
//        NSRange rang = NSMakeRange(0, callStrString.length-1);
//        NSString *strRang = [callStrString substringWithRange:rang];
//        _textLabel.text = strRang;
//        textString = _textLabel.text;
//    }
//    if(textString.length == 0){
//        _downview_type = DownView_Del;
//        [[NSNotificationCenter defaultCenter] postNotificationName:DelNumberToEnd object:nil];
//    }
}

//-(void)callPhoneNumber{
//    if(textString.length < 7){
//        [UtilTool showAlertView:@"您所拨打的电话格式不正确"];
//        return;
//    }
//    [_callModel makeCallPhone:textString];
//}
//
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
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [_callModel setCallDelegate:nil];
//}


@end
