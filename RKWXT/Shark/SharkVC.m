//
//  SharkVC.m
//  RKWXT
//
//  Created by SHB on 15/8/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SharkVC.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#define kDuration 0.5
#define yGap 60

@interface SharkVC (){
    UIImageView *upImgView;
    UIImageView *downImgView;
    
    UILabel *label;
    UIActivityIndicatorView *activityView;
    NSTimer *_timer;
    
    BOOL waitting;
}

@end

@implementation SharkVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)addAnimations{
    //让imgup上下移动
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY-140)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY-200)];
    translation.duration = kDuration;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    
    CABasicAnimation *translation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY+140)];
    translation1.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY+200)];
    translation1.duration = kDuration;
    translation1.repeatCount = 1;
    translation1.autoreverses = YES;
    
    [upImgView.layer addAnimation:translation forKey:@"translation"];
    [downImgView.layer addAnimation:translation1 forKey:@"translation1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, self.bounds.size.height/2-yGap, self.bounds.size.width, 2*yGap);
    [imgView setImage:[UIImage imageNamed:@"SharkBlackImg.png"]];
    [self addSubview:imgView];
    
    upImgView = [[UIImageView alloc] init];
    upImgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2);
    [upImgView setImage:[UIImage imageNamed:@"Shake_01.png"]];
    [self addSubview:upImgView];
    
    downImgView = [[UIImageView alloc] init];
    downImgView.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
    [downImgView setImage:[UIImage imageNamed:@"Shake_02.png"]];
    [self addSubview:downImgView];
    
    
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
    }
}

-(void)startPlayMusic{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake.wav" withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    //不需要异步
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    });
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

-(void)stopPlayMusic{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake_match.m4r" withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    [activityView stopAnimating];
    [label setHidden:YES];
    waitting = NO;
    [self stopPlayMusic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
