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
#import "WXCommonWebView.h"
#import "LuckySharkNumberModel.h"
#import "LuckyGoodsShowVC.h"

#import "WinningView.h"
#import "WXUIViewController+WinningPopView.h"
#import "WinningViewAnimationDrop.h"

#define kDuration 0.3
#define yGap 60
#define CenterImgYGap 215

@interface LuckyShakeVC ()<LuckySharkModelDelegate,LuckySharkNumberModelDelegate>{
    WXUIImageView *centerImgView;
    UILabel *label;
    UILabel *_numberLabel;
    UIActivityIndicatorView *activityView;
    NSTimer *_timer;
    NSTimer *_resultTimer;
    
    BOOL waitting;
    BOOL hasLucky;
    BOOL isLoading;
    
    LuckySharkModel *_model;
    LuckySharkNumberModel *_numModel;
}

@end

@implementation LuckyShakeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    
    _model = [[LuckySharkModel alloc] init];
    [_model setDelegate:self];
    
    isLoading = YES;
    _numModel = [[LuckySharkNumberModel alloc] init];
    [_numModel setDelegate:self];
    [_numModel loadLuckySharkNumber];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoWinningGoodsInfo) name:@"gotoWinningGoodsInfoVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWinningView1) name:@"closeWinningViewNoti" object:nil];
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
}

-(void)createTextAndbtnView{
    CGFloat yOffset = 100;
    CGFloat numberWidth = 20;
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
    _numberLabel.frame = CGRectMake(text1Width, self.bounds.size.height-yOffset, numberWidth+20, textheight);
    [_numberLabel setBackgroundColor:[UIColor clearColor]];
    [_numberLabel setText:@"0"];
    [_numberLabel setTextAlignment:NSTextAlignmentCenter];
    [_numberLabel setTextColor:WXColorWithInteger(0xffec14)];
    [_numberLabel setFont:WXFont(15.0)];
    [self addSubview:_numberLabel];
    
    UILabel *text2Label = [[UILabel alloc] init];
    text2Label.frame = CGRectMake(text1Width+numberWidth+20, self.bounds.size.height-yOffset, self.bounds.size.width-text1Width-numberWidth, textheight);
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
    [ruleBtn.titleLabel setFont:WXFont(13.0)];
    [ruleBtn addTarget:self action:@selector(gotoSharkRuleVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ruleBtn];
    
    WXUIButton *goodsBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    goodsBtn.frame = CGRectMake((self.bounds.size.width-btnWidth)/2, ruleBtn.frame.origin.y+ruleBtn.frame.size.height+5, btnWidth, btnHeight);
    [goodsBtn setBackgroundImage:[UIImage imageNamed:@"SharkRuleImg.png"] forState:UIControlStateNormal];
    [goodsBtn setTitle:@"查看奖品" forState:UIControlStateNormal];
    [goodsBtn.titleLabel setTextColor:WXColorWithInteger(0xffffff)];
    [goodsBtn.titleLabel setFont:WXFont(13.0)];
    [goodsBtn addTarget:self action:@selector(searchLuckyGoodsListVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goodsBtn];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(isLoading){
        return;
    }
    if(hasLucky){
        return;
    }
    if(waitting){
        NSLog(@"上一个请求还没有结束1");
        return;
    }
    if(motion == UIEventSubtypeMotionShake){
        if(_numModel.number <= 0){
            [UtilTool showTipView:@"抽奖机会用完了，获取更多抽奖机会的方法在活动规则里面哦"];
            return;
        }
        waitting = YES;
        [self startPlayMusic];
        [self addAnimations];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startActivityView) userInfo:nil repeats:NO];
        _resultTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startLucky) userInfo:nil repeats:NO];
    }
}

-(void)startPlayMusic{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake.wav" withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(isLoading){
        return;
    }
    if(waitting){
        NSLog(@"上一个请求还没有结束2");
        return;
    }
    if(motion == UIEventSubtypeMotionShake){
        waitting = NO;
    }
}

-(void)startActivityView{
    [activityView startAnimating];
    [label setHidden:NO];
}

-(void)startLucky{
    [_model loadUserShark];
}

-(void)closeWinningView1{
    waitting = NO;
}

-(void)stopPlayMusic{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shake_match.m4r" withExtension:nil];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark sharkNumDelegate
-(void)loadLuckySharkNumberSucceed{
    isLoading = NO;
    [self unShowWaitView];
    if(_numModel.number <= 0){
        [UtilTool showTipView:@"抽奖机会用完了，获取更多抽奖机会的方法在活动规则里面哦"];
    }
    [_numberLabel setText:[NSString stringWithFormat:@"%ld",(long)_numModel.number]];
}

-(void)loadLuckySharkNumberFailed:(NSString *)errormsg{
    isLoading = NO;
    [self unShowWaitView];
    if(!errormsg){
        errormsg = @"获取抽奖次数失败";
    }
    [UtilTool showAlertView:errormsg];
}

#pragma mark sharkDelegate
-(void)luckySharkSucceed{
    if(_numModel.number >= 1){
        _numModel.number -= 1;
        [_numberLabel setText:[NSString stringWithFormat:@"%ld",(long)_numModel.number]];
    }
    waitting = NO;
    [activityView stopAnimating];
    [label setHidden:YES];
//    [self stopPlayMusic];
    
    if([_model.luckyGoodsArr count] > 0){
        hasLucky = YES;
        LuckySharkEntity *entity = [_model.luckyGoodsArr objectAtIndex:0];
        
        WinningView *view = [WinningView defaultPopupView];
        view.parentVC = self;
        view.imgUrl = entity.imgUrl;
        view.name = entity.name;
        [view initial];
        
        [self presentPopupView:view animation:[WinningViewAnimationDrop new] dismissed:^{
            hasLucky = NO;
            NSLog(@"动画结束");
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoWinningGoodsInfo) name:@"gotoWinningGoodsInfoVC" object:nil];
        }];
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

-(void)gotoWinningGoodsInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeWinningViewNoti" object:nil];
    LuckySharkEntity *entity = [_model.luckyGoodsArr objectAtIndex:0];
    LuckyGoodsInfoVC *vc = [[LuckyGoodsInfoVC alloc] init];
    vc.luckyEnt = entity;
    [self.wxNavigationController pushViewController:vc];
}

-(void)gotoSharkRuleVC{
    WXCommonWebView *vc = [[WXCommonWebView alloc] init];
    vc.webUrlString = [NSString stringWithFormat:@"%@wx_html/index.php/Public/rule",WXTWebBaseUrl];
    vc.urlType = WebView_Type_SingleUrl;
    [self.wxNavigationController pushViewController:vc];
}

-(void)searchLuckyGoodsListVC{
    LuckyGoodsShowVC *showVC = [[LuckyGoodsShowVC alloc] init];
    [self.wxNavigationController pushViewController:showVC];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resignFirstResponder];
    [activityView stopAnimating];
    [label setHidden:YES];
    waitting = NO;
    hasLucky = NO;
    [_model setDelegate:nil];
    [_numModel setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
