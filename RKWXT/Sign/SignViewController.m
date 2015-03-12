//
//  T_SignViewController.m
//  Woxin3.0
//
//  Created by SHB on 15/1/21.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "SignViewController.h"
#import "CalendarView.h"
//#import "MaskView.h"
#import "T_SignGifView.h"
#import "SignModel.h"
#import "SignEntity.h"
#import "NSDate+Compare.h"

#define kAnimatedDur (0.3)
#define kMaskMaxAlpha (1.0)
#define Size self.view.bounds.size

@interface SignViewController()<CalendarDelegate,SignDelegate>{
    CalendarView *_sampleView;
    UIButton *_closeBtn;
//    MaskView *_maskView;
    UIButton *_signBtn;
    SignModel *_model;
    SignEntity *signEntity;
    UILabel *_textLabel;
}
@end

@implementation SignViewController

-(id)init{
    self = [super init];
    if(self){
        _model = [[SignModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setTitle:@"每日签到"];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [imgView setImage:[UIImage imageNamed:@"signBg.jpg"]];
    [self.view addSubview:imgView];
    
    [self createTextLabel];
//    [self createActivityRule];
//    [self createCalendar];
    [self createRewardLabel];
    [self createSignBtn];
//    [self createView];
}

//-(void)createView{
//    _maskView = [[MaskView alloc] initWithFrame:self.bounds];
//    [_maskView setBackgroundColor:[UIColor blackColor]];
//    [_maskView setAlpha:0.0];
//    [self addSubview:_maskView];
//}

-(void)createTextLabel{
    CGFloat yOffset = 60;
    UIImage *img = [UIImage imageNamed:@"signEveryDay.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((Size.width-img.size.width)/2, yOffset, img.size.width,
                               img.size.height);
    [imgView setImage:img];
    [self.view addSubview:imgView];
}

-(void)createActivityRule{
    CGFloat yOffset = 65;
    CGFloat width = 110;
    CGFloat height = 30;
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake((Size.width-width)/2, yOffset, width, height);
    [ruleBtn setImage:[UIImage imageNamed:@"activityRule.png"] forState:UIControlStateNormal];
    [self.view addSubview:ruleBtn];
}

-(void)createCalendar{
    CGFloat yOffset = 75;
    CGFloat xOffset = 10;
    UIImage *img = [UIImage imageNamed:@"kalendarIcon.png"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(Size.width-xOffset-img.size.width, yOffset, img.size.width, img.size.height);
    [btn setImage:img forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(showCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)createRewardLabel{
    CGSize size = self.view.bounds.size;
    CGFloat yOffset = 30;
    CGFloat height = 30;
    _textLabel = [[UILabel alloc] init];
    _textLabel.frame = CGRectMake(0, size.height-yOffset-30-30-30, Size.width, height);
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_textLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_textLabel];
}

-(void)createSignBtn{
    CGFloat xOffset = 30;
    CGFloat yOffset = 30;
    CGFloat height = 55;
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.frame = CGRectMake(xOffset, Size.height-yOffset-height, Size.width-2*xOffset, height);
    [_signBtn setImage:[UIImage imageNamed:@"SignNow.png"] forState:UIControlStateNormal];
    [_signBtn addTarget:self action:@selector(signBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signBtn];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *time = [userDefaults objectForKey:LastSignDate];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSString *timeString = [date YMDHMString:E_YMD];
    if([timeString isEqualToString:@"今天"]){
        [_signBtn setEnabled:NO];
    }
}

//-(void)showCalendar{
//    CGFloat yOffset = 40;
////    [self setDexterity:E_Slide_Dexterity_None];
//    [UIView animateWithDuration:kAnimatedDur animations:^{
//        _sampleView = [[CalendarView alloc] initWithFrame:CGRectMake(10, yOffset, Size.width-2*10, 350)];
//        [_sampleView setAlpha:0.9];
//        _sampleView.calendarDate = [NSDate date];
//        [self.view addSubview:_sampleView];
//        [_maskView setAlpha:0.6];
//    }completion:^(BOOL finished){
//    }];
//    
//    CGFloat closeBtnWidth = 25;
//    CGFloat closeBtnHeight = 25;
//    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _closeBtn.frame = CGRectMake(Size.width-closeBtnWidth, yOffset-10, closeBtnWidth, closeBtnHeight);
//    [_closeBtn setImage:[UIImage imageNamed:@"closeKalen.png"] forState:UIControlStateNormal];
//    [_closeBtn addTarget:self action:@selector(closeCalendarView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_closeBtn];
//}

//-(void)closeCalendarView{
//    [self setDexterity:E_Slide_Dexterity_Normal];
//    [UIView animateWithDuration:kAnimatedDur animations:^{
//        [_closeBtn removeFromSuperview];
//        [_sampleView removeFromSuperview];
//        [_maskView setAlpha:0.0];
//    }completion:^(BOOL finished) {
//    }];
//}

-(void)signBtnClicked{
    [_model signGainMoney];
    T_SignGifView *gifView = [[T_SignGifView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    [self.view addSubview:gifView];
    [_signBtn setEnabled:NO];
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:kAnimateDuration];
}

-(void)showAlert{
    [_signBtn setEnabled:YES];
}

-(void)signSucceed{
    [_signBtn setEnabled:NO];
    if([_model.signArr count] > 0){
        signEntity = [_model.signArr objectAtIndex:0];
        [UtilTool showAlertView:signEntity.message];
        [_textLabel setText:[NSString stringWithFormat:@"我的奖励:%f元",signEntity.money]];
    }
}

-(void)signFailed:(NSString *)errorMsg{
    [UtilTool showAlertView:errorMsg];
}

-(void)tappedOnDate:(NSDate *)selectedDate{
}

@end
