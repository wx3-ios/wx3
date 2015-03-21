//
//  WXTMallVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallVC.h"
#import "WXTUITabBarController.h"
#import "CallBackVC.h"

#define Size self.view.bounds.size
#define NumberBtnHeight (70)
#define InputTextHeight (35)

@interface WXTMallVC(){
    UIView *_keybView;
    UILabel *_textLabel;

    NSString *textString;
    
    NSArray *_numArr;
}
@end

@implementation WXTMallVC

-(id)init{
    self = [super init];
    if(self){
        _numArr = @[@"1Sel.png",@"2Sel.png",@"3Sel.png",@"4Sel.png",@"5Sel.png",@"6Sel.png",@"7Sel.png",@"8Sel.png",@"9Sel.png",@"*Sel.png",@"0Sel.png",@"#Sel.png"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.keyPad_type = E_KeyPad_Noraml; //键盘
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _downview_type = DownView_Init;        //底部呼叫按钮
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
    _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50-4*NumberBtnHeight-InputTextHeight, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight+InputTextHeight);
    [_keybView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_keybView];
    
    CGFloat btnWidth = 50;
    _textLabel = [[UILabel alloc] init];
    _textLabel.frame = CGRectMake(0, 0, Size.width-btnWidth, InputTextHeight);
    [_textLabel setBackgroundColor:[UIColor grayColor]];
    [_textLabel setBorderRadian:4.0 width:0.5 color:[UIColor whiteColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setTextColor:[UIColor redColor]];
    [_keybView addSubview:_textLabel];
    
    UIImage *delImg = [UIImage imageNamed:@"delSel.png"];
    WXTUIButton *delBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(Size.width-btnWidth+10, 9, delImg.size.width, delImg.size.height);
    [delBtn setBackgroundColor:[UIColor clearColor]];
    [delBtn setImage:delImg forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_keybView addSubview:delBtn];
    
    CGFloat numBtnWidth = IPHONE_SCREEN_WIDTH/3;
    NSInteger line = -1;
    for(int j = 0;j < 4; j++){
        for(int i = 0;i < 3; i++){
            line ++;
            WXUIButton *numBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            numBtn.frame = CGRectMake(i*numBtnWidth, InputTextHeight+j*NumberBtnHeight, numBtnWidth, NumberBtnHeight);
            [numBtn setBackgroundColor:[UIColor clearColor]];
            [numBtn setImage:[UIImage imageNamed:_numArr[line]] forState:UIControlStateNormal];
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
    }
}

-(void)show{
    if(self.keyPad_type == E_KeyPad_Show){
        self.keyPad_type = E_KeyPad_Down;
        _downview_type = DownView_Del;
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight+InputTextHeight);
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
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-50-4*NumberBtnHeight-InputTextHeight, IPHONE_SCREEN_WIDTH, 4*NumberBtnHeight+InputTextHeight);
        }];
        return;
    }
    if(self.keyPad_type == E_KeyPad_Noraml){
        self.keyPad_type = E_KeyPad_Show;
    }
}

-(void)delBtnClicked{
    NSString *callStrString = _textLabel.text;
    if(callStrString.length > 0){
        NSRange rang = NSMakeRange(0, callStrString.length-1);
        NSString *strRang = [callStrString substringWithRange:rang];
        _textLabel.text = strRang;
        textString = _textLabel.text;
    }
    if(textString.length == 0){
        _downview_type = DownView_Del;
        [[NSNotificationCenter defaultCenter] postNotificationName:DelNumber object:nil];
    }
}

-(void)callPhoneNumber{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    CallBackVC *callBackVC = [[CallBackVC alloc] init];
    [callBackVC setPhoneName:textString];
    [callBackVC setUserPhone:userObj.user];
    [self.navigationController pushViewController:callBackVC animated:YES];
}

@end
