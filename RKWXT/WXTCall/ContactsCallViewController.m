//
//  IncomingCallViewController.m
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "ContactsCallViewController.h"
#import "CallViewController.h"
#import "WXContacterVC.h"
#import "CallModel.h"
#import "CallBackVC.h"

@interface ContactsCallViewController ()<CallViewVCInputDelegate,MakeCallDelegate>{
    CallViewController * _recentCall;
    WXContacterVC * _contacterVC;
    UILabel *numberLabel;
    NSString *numberStr;
    
    CallModel *_callModel;
}

@end

@implementation ContactsCallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _recentCall = [[CallViewController alloc]init];
    [_recentCall.view setFrame:CGRectMake(0, 72, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT-72-50)];
    [_recentCall setInputDelegate:self];
    _contacterVC = [[WXContacterVC alloc] init];
    [_contacterVC.view setFrame:CGRectMake(0, 72, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT-72-50)];
    
    [self.view addSubview:_recentCall.view];
    [self loadSegmentControl];
    [self loadInputTextField];
    [self addNotification];
    
    numberStr = [[NSString alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _callModel = [[CallModel alloc] init];
    [_callModel setCallDelegate:self];
}

-(void)loadInputTextField{
    numberLabel = [[UILabel alloc] init];
    numberLabel.frame = CGRectMake(15, 35, 150, 28);
    [numberLabel setBackgroundColor:[UIColor clearColor]];
    [numberLabel setTextColor:NSTextAlignmentLeft];
    [numberLabel setTextAlignment:NSTextAlignmentLeft];
    [numberLabel setTextColor:[UIColor whiteColor]];
    [numberLabel setHidden:YES];
    [self.view addSubview:numberLabel];
}

-(void)loadSegmentControl{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 66);
    [imgView setImage:[UIImage imageNamed:@"TopBgImg.png"]];
    [self.view addSubview:imgView];
    
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    NSArray *nameArr = @[@"通话",@"通讯录"];
    _segmentControl
    = [[UISegmentedControl alloc] initWithItems:nameArr];
    [_segmentControl setBackgroundColor:[UIColor whiteColor]];
    _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT + 12, segWidth, segHeight);
    if(isIOS6){
        _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    }
    [_segmentControl setSelectedSegmentIndex:kCallSegmentIndex];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
#endif
    [_segmentControl setBorderRadian:1.0 width:0.2 color:[UIColor grayColor]];
    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
//    [self.navigationController.navigationBar addSubview:_segmentControl];
    [self.view addSubview:_segmentControl];
}

-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case kCallSegmentIndex:
            [self.view addSubview:_recentCall.view];
            break;
        case kContactsSegmentIndex:
            [self.view addSubview:_contacterVC.view];
            break;
        default:
            break;
    }
}

-(void)addNotification{
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(inputChange) name:kInputChange object:nil];
    [defaultCenter addObserver:self selector:@selector(callPhoneNumber) name:CallPhone object:nil];
    [defaultCenter addObserver:self selector:@selector(delBtnClick) name:DelNumber object:nil];
}

-(void)inputChange{
    
}

-(void)inputNumber:(id)sender{
    [_segmentControl setHidden:YES];
    [numberLabel setHidden:NO];
    WXUIButton *btn = sender;
    NSInteger number = (btn.tag+1==11?0:btn.tag+1);
    if(number <= 9 && number >= 0){
        NSString *str = [NSString stringWithFormat:@"%ld",(long)number];
        numberStr = [numberStr stringByAppendingString:str];
        [numberLabel setText:numberStr];
    }
    
    if(numberStr.length > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:InputNumber object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownKeyBoard object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kInputChange object:nil];
    }
}

-(void)delBtnClick{
    NSString *callStrString = numberLabel.text;
    if(callStrString.length > 0){
        NSRange rang = NSMakeRange(0, callStrString.length-1);
        NSString *strRang = [callStrString substringWithRange:rang];
        numberLabel.text = strRang;
        numberStr = numberLabel.text;
    }
    if(numberStr.length == 0){
        [numberLabel setHidden:YES];
        [_segmentControl setHidden:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DelNumberToEnd object:nil];
    }
}

-(void)callPhoneNumber{
    if(numberStr.length < 7){
        [UtilTool showAlertView:@"您所拨打的电话格式不正确"];
        return;
    }
    [_callModel makeCallPhone:numberStr];
}

#pragma callDelegate
-(void)makeCallPhoneFailed:(NSString *)failedMsg{
    if(!failedMsg){
        failedMsg = @"呼叫失败";
    }
    [UtilTool showAlertView:failedMsg];
}

-(void)makeCallPhoneSucceed{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    CallBackVC *callBackVC = [[CallBackVC alloc] init];
    [callBackVC setPhoneName:numberStr];
    [callBackVC setUserPhone:userObj.user];
    [self.navigationController pushViewController:callBackVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_callModel setCallDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
}

@end


