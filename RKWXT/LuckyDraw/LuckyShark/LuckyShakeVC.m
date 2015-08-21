//
//  LuckyShakeVC.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyShakeVC.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LuckySharkModel.h"
#import "LuckyGoodsInfoVC.h"
#import "LuckySharkEntity.h"

#import "LuckyGoodsOrderList.h"

#define kDuration 0.3
#define yGap 60
#define CenterImgYGap 215

@interface LuckyShakeVC ()<LuckySharkModelDelegate>{
    WXUIImageView *centerImgView;
    UILabel *label;
    UILabel *_numberLabel;
    UIActivityIndicatorView *activityView;
    NSTimer *_timer;
    NSTimer *_resultTimer;
    
    BOOL waitting;
    
    LuckySharkModel *_model;
}

@end

@implementation LuckyShakeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)addAnimations{
    CGFloat centerYGap = CenterImgYGap+120/2+36;
    if((int)self.view.bounds.size.height == 480){
        centerYGap -= 47;
    }
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerImgView.frame.origin.x+80, centerYGap)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerImgView.frame.origin.x+30, centerYGap)];
    translation.duration = kDuration;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    
    [centerImgView.layer addAnimation:translation forKey:@"translation"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"摇一摇"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [imgView setImage:[UIImage imageNamed:@"SharkBigImg.png"]];
    [self addSubview:imgView];
    
    CGFloat imgWidth = 100;
    CGFloat imgHeight = 120;
    centerImgView = [[WXUIImageView alloc] init];
    centerImgView.frame = CGRectMake((self.bounds.size.width-imgWidth)/2, CenterImgYGap, imgWidth, imgHeight);
    [centerImgView setImage:[UIImage imageNamed:@"SharkCenterImg.png"]];
    [self addSubview:centerImgView];
    if((int)self.view.bounds.size.height == 480){
        centerImgView.frame = CGRectMake((self.bounds.size.width-imgWidth)/2, CenterImgYGap-47, imgWidth, imgHeight);
    }
    
    CGFloat labelWidth = 100;
    CGFloat activityViewWidth = 30;
    CGFloat xOffset = (self.bounds.size.width-labelWidth-activityViewWidth)/2;
    CGFloat yOffset = self.bounds.size.height/2;
    activityView = [[UIActivityIndicatorView alloc] init];
    activityView.frame = CGRectMake(xOffset, yOffset, activityViewWidth, activityViewWidth);
    [activityView setHidesWhenStopped:YES];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityView];
    
    xOffset += 30+5;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(xOffset, yOffset, labelWidth, activityViewWidth);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"抽奖中..."];
    [label setHidden:YES];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    [self addSubview:label];
    
    [self createTextAndbtnView];
    
    _model = [[LuckySharkModel alloc] init];
    [_model setDelegate:self];
}

-(void)createTextAndbtnView{
    CGFloat yOffset = 100;
    CGFloat numberWidth = 16;
    CGFloat textheight = 18;
    CGFloat text1Width = self.bounds.size.width/2-numberWidth-5;
    UILabel *text1Label = [[UILabel alloc] init];
    text1Label.frame = CGRectMake(0, self.bounds.size.height-yOffset, text1Width, textheight);
    [text1Label setBackgroundColor:[UIColor clearColor]];
    [text1Label setText:@"您还有"];
    [text1Label setTextAlignment:NSTextAlignmentRight];
    [text1Label setTextColor:WXColorWithInteger(0xffffff)];
    [text1Label setFont:WXFont(15.0)];
    [self addSubview:text1Label];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.frame = CGRectMake(text1Width, self.bounds.size.height-yOffset, numberWidth, textheight);
    [_numberLabel setBackgroundColor:[UIColor clearColor]];
    [_numberLabel setText:@"1"];
    [_numberLabel setTextAlignment:NSTextAlignmentCenter];
    [_numberLabel setTextColor:WXColorWithInteger(0xffec14)];
    [_numberLabel setFont:WXFont(15.0)];
    [self addSubview:_numberLabel];
    
    UILabel *text2Label = [[UILabel alloc] init];
    text2Label.frame = CGRectMake(text1Width+numberWidth, self.bounds.size.height-yOffset, self.bounds.size.width-text1Width-numberWidth, textheight);
    [text2Label setBackgroundColor:[UIColor clearColor]];
    [text2Label setText:@"次抽奖机会"];
    [text2Label setTextAlignment:NSTextAlignmentLeft];
    [text2Label setTextColor:WXColorWithInteger(0xffffff)];
    [text2Label setFont:WXFont(15.0)];
    [self addSubview:text2Label];
    
    yOffset -= textheight;
    CGFloat btnWidth = 125;
    CGFloat btnHeight = 23;
    WXUIButton *ruleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake((self.bounds.size.width-btnWidth)/2, self.bounds.size.height-yOffset+6, btnWidth, btnHeight);
    [ruleBtn setBackgroundImage:[UIImage imageNamed:@"SharkRuleImg.png"] forState:UIControlStateNormal];
    [ruleBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [ruleBtn.titleLabel setTextColor:WXColorWithInteger(0xffffff)];
    [ruleBtn addTarget:self action:@selector(gotoSharkRuleVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ruleBtn];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(waitting){
        NSLog(@"上一个请求还没有结束");
        return;
    }
    if(motion == UIEventSubtypeMotionShake){
        waitting = YES;
        [self startPlayMusic];
        [self addAnimations];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startActivityView) userInfo:nil repeats:NO];
        _resultTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(startLucky) userInfo:nil repeats:NO];
    }
}

-(void)startPlayMusic{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake.wav" withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(waitting){
        NSLog(@"上一个请求还没有结束");
        return;
    }
    if(motion == UIEventSubtypeMotionShake){
        waitting = YES;
    }
}

-(void)startActivityView{
    [activityView startAnimating];
    [label setHidden:NO];
}

-(void)startLucky{
    [_model loadUserShark];
}

-(void)stopPlayMusic{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake_match.m4r" withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark sharkDelegate
-(void)luckySharkSucceed{
    waitting = NO;
    [activityView stopAnimating];
    [label setHidden:YES];
    [self stopPlayMusic];
    
    [UtilTool showAlertView:@"恭喜您中奖!"];
    if([_model.luckyGoodsArr count] > 0){
        LuckySharkEntity *entity = [_model.luckyGoodsArr objectAtIndex:0];
        LuckyGoodsInfoVC *vc = [[LuckyGoodsInfoVC alloc] init];
        vc.luckyEnt = entity;
        [self.wxNavigationController pushViewController:vc];
    }
}

-(void)luckySharkFailed:(NSString *)errorMsg{
    waitting = NO;
    [activityView stopAnimating];
    [label setHidden:YES];
    if(!errorMsg){
        errorMsg = @"抽奖失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)gotoSharkRuleVC{
    LuckyGoodsOrderList *vc = [[LuckyGoodsOrderList alloc] init];
    [self.wxNavigationController pushViewController:vc];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
    [self resignFirstResponder];
    [activityView stopAnimating];
    [label setHidden:YES];
    waitting = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
