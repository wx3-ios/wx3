//
//  IncomingCallViewController.m
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//



#import "IncomingCallViewController.h"
#import "ContactUitl.h"
#import "PhoneData.h"
#import "RecentData.h"
//#import "NetRequest.h"
#import "NSString+Helper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AddressBook/AddressBook.h>
//#import "AreaHelper.h"
//#import "RecentHelper.h"
#import "ARLabel.h"
//#import "FTAnimation.h"
//#import "DTMFView.h"
//#import "AUIAnimatableLabel.h"
//#import "Gossip.h"

@interface IncomingCallViewController () <DTMFDelegate>
{
    BOOL _handup;
    NSInteger _headHeight;
}

@property (nonatomic, strong) PhoneData *phoneData;
@property (nonatomic, strong) NSDate *callDate;
@property (nonatomic, strong) NSDate *beginTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) GSCall *call;
@property (assign) int handupCount;

@property (nonatomic, strong) DTMFView *dtmfView;
@property (nonatomic, strong) NSMutableString *dtmfString;

@end

@implementation IncomingCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"DTMFView" owner:self options:nil];
    if (viewArray.count > 0) {
        self.dtmfView = viewArray[0];
        self.dtmfView.delegate = self;
    }
    
    [self setSpeakerPhoneEnabled:NO];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if (sysVersion >= 7.0)
    {
        _headView.frame = CGRectMake(0, 0, CGRectGetWidth(_headView.frame), CGRectGetHeight(_headView.frame) + 20);
    }
    
    self.callDate = [NSDate date];    
    
    ContactData *cd = [[ContactUitl shareInstance] queryContactFromPhone:_callPhone];
    _phoneData = [PhoneData dataWithPhone:_callPhone];
    if (cd.name) {
        _titleLabel.text = cd.name;
    }
    else{
        _titleLabel.text = [_phoneData displayNumber];
    }
    _callTimeLabel.text = @"";
    if (_phoneData.area)
    {
        _subtitleLable.text = _phoneData.area;
    }
    else
    {
//        _subtitleLable.text = [[AreaHelper sharedAreaHelper] queryByPhone:_callPhone];
    }
    _miniSubtitleLabel.text = _subtitleLable.text;
    _miniTitleLabel.text = _titleLabel.text;
    
    _miniSubtitleLabel.hidden = YES;
    _miniTitleLabel.hidden = YES;
    
    _headHeight = _headHeightLayoutConstraint.constant;
    
    [self voipCall:_callPhone];
    
//    _handupButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _handupButton.frame = CGRectMake(15, self.view.bounds.origin.y-60, self.view.bounds.size.width-2*15, 40);
//    [_handupButton setBackgroundColor:[UIColor redColor]];
//    [_handupButton setTitle:@"挂  断" forState:UIControlStateNormal];
//    [_handupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.dtmfView addSubview:_handupButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)addCallLog
{
    RecentData *recent = [[RecentData alloc]init];
    recent.phone = [NSString stringWithString:_callPhone];
    recent.date = _callDate;
    recent.area = _phoneData.area;
    [[RecentHelper sharedRecentHelper] insert:recent];
}*/


-(void)setCallTime
{
    NSTimeInterval  time  = [[NSDate dateWithTimeIntervalSinceNow:1]   timeIntervalSinceDate:_beginTime]  ;
    
    //    NSDate*  allDate = [NSDate  dateWithTimeIntervalSinceReferenceDate:myInterVal]   ;
    //    NSDateFormatter*   myTimeFormatter = [[NSDateFormatter  alloc] init]  ;
    //    [myTimeFormatter  setDateFormat:@"mm : ss"] ;
    NSString *string = [NSString stringWithFormat:@"%02li:%02li:%02li",
                        lround(floor(time / 3600.)) % 100,
                        lround(floor(time / 60.)) % 60,
                        lround(floor(time)) % 60];
    
    self.callTimeLabel.text  = string  ;
    //self.networkLabel.text = @"网络好";
}


/*
- (void)setCall:(GSCall *)call {
    [self willChangeValueForKey:@"call"];
    [_call removeObserver:self forKeyPath:@"status"];
    _call = call;
    [_call addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:nil];
    [self didChangeValueForKey:@"call"];
}*/

/*
- (void)closeAction
{
    //[USER_AGENT updateBalance:nil];
    if (_call) {
        [_call removeObserver:self forKeyPath:@"status"];
    }
    [self setSpeakerPhoneEnabled:NO];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}*/


- (void)dtmfViewShow:(BOOL)show
{
    if (show) {
        _titleLabel.hidden = YES;
        _subtitleLable.hidden = YES;
        
        //初始化键盘位置
        [self.view insertSubview:_dtmfView belowSubview:_keypadButton];
        _dtmfView.center = self.keypadButton.center;
        _dtmfView.transform = CGAffineTransformMakeScale(.2, .2);
        
        self.dtmfString = [NSMutableString string];
    }
    else{
        _miniSubtitleLabel.hidden = YES;
        _miniTitleLabel.hidden = YES;
//        _miniTitleLabel.text = _callPhone;
        
        //初始化键盘位置
        [self.view insertSubview:_dtmfView belowSubview:_keypadButton];
        _dtmfView.center = self.view.center;
        _dtmfView.transform = CGAffineTransformMakeScale(1, 1);
    }
    
    
    
    CGRect titleFrame = show ? _titleLabel.frame : _miniTitleLabel.frame;
    CGRect subtitleFrame = show ? _subtitleLable.frame : _miniSubtitleLabel.frame;
    CGRect titleEnlargedFrame = !show ? _titleLabel.frame : _miniTitleLabel.frame;
    CGRect subtitleEnlargedFrame = !show ? _subtitleLable.frame : _miniSubtitleLabel.frame;
    
    //title label
    ARLabel *arTitleLabel = [[ARLabel alloc] initWithFrame:titleFrame];
    arTitleLabel.text = _titleLabel.text;
    arTitleLabel.textColor = _titleLabel.textColor;
    arTitleLabel.textAlignment = NSTextAlignmentCenter;
    arTitleLabel.enlargedSize = titleEnlargedFrame.size;
    [self.view addSubview:arTitleLabel];
    //subtitle label
    ARLabel *arSubtitleLabel = [[ARLabel alloc]initWithFrame:subtitleFrame];
    arSubtitleLabel.text = _subtitleLable.text;
    arSubtitleLabel.textColor = _subtitleLable.textColor;
    arSubtitleLabel.textAlignment = NSTextAlignmentCenter;
    arSubtitleLabel.enlargedSize = subtitleEnlargedFrame.size;
    [self.view addSubview:arSubtitleLabel];
    
    _headHeightLayoutConstraint.constant = show ? CGRectGetHeight(_miniHeadView.bounds) : _headHeight;
    
    [UIView animateWithDuration:0.5 animations:^{
        arTitleLabel.frame = titleEnlargedFrame;
        arSubtitleLabel.frame = subtitleEnlargedFrame;
        
        //显示键盘
        CGFloat sxy = show ? 1 : 0.2;
        CGFloat offset = show ? (self.view.center.y - _keypadButton.center.y) : (_keypadButton.center.y - self.view.center.y);//计算移动的偏移位置
        CGAffineTransform show = CGAffineTransformMakeScale(sxy, sxy);
        CGAffineTransform postion = CGAffineTransformMakeTranslation(0, offset);
        _dtmfView.transform = CGAffineTransformConcat(show, postion);
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [arTitleLabel removeFromSuperview];
        [arSubtitleLabel removeFromSuperview];
        
        if (show) {
            _miniSubtitleLabel.hidden = NO;
            _miniTitleLabel.hidden = NO;
            
            //_dtmfView.center = self.view.center;
        }
        else{
            _titleLabel.hidden = NO;
            _subtitleLable.hidden = NO;
            
            [_dtmfView removeFromSuperview];
        }
    }];
}


- (IBAction)keypadAction:(id)sender
{
    NSLog(@"keypad show in rect = %@", NSStringFromCGRect(_keypadButton.frame));
    _keypadButton.selected = !_keypadButton.selected;
    [self dtmfViewShow:_keypadButton.selected];
}

- (IBAction)muteAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    //button.normalBackgroundColor = button.selected ? [THEME highlightedColor] : [THEME normalColor];
    [_call setMicVolume:button.selected ? 0 : 1.];
}

- (IBAction)speakerAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    //button.normalBackgroundColor = button.selected ? [THEME highlightedColor] : [THEME normalColor];
    [self setSpeakerPhoneEnabled:button.selected];
}


- (IBAction)handupAction:(id)sender
{
    _handup = YES;
    _handupCount++;
    if (_handupCount > 2) {
        DDLogWarn(@"1s后强制关闭....");
        [self performSelector:@selector(closeAction) withObject:Nil afterDelay:1.];
    }
    [_call end];
    if (_timer) {
        [_timer invalidate];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)callStatusDidChange {
    switch (_call.status) {
        case GSCallStatusReady: {
            [_stateLabel setText:@"正在连接..."];
        } break;
            
        case GSCallStatusConnecting: {
            [_stateLabel setText:@"呼叫中..."];
        } break;
            
        case GSCallStatusCalling: {
            [_stateLabel setText:@"Calling..."];
        } break;
            
        case GSCallStatusConnected: {
            [_stateLabel setText:@"正在通话中..."];
            self.beginTime = [NSDate date];
            [self setCallTime];
            _keypadButton.enabled = YES;
        
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(setCallTime) userInfo:nil repeats:YES];
        } break;
            
        case GSCallStatusDisconnected: {
            [_stateLabel setText:@"呼叫结束"];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeAction) object:nil];
            [self closeAction];
        } break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"])
    {
        [self callStatusDidChange];
    }
}


- (void)setSpeakerPhoneEnabled:(BOOL)enable
{
    UInt32 route;
    route = enable ? kAudioSessionOverrideAudioRoute_Speaker :
    kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof(route), &route);
}


//- (void)setMute:(BOOL)enable
//{
//    /* FIXME maybe I must look for conf_port */
//    if (enable)
//        pjsua_conf_adjust_rx_level(0 /* pjsua_conf_port_id slot*/, 0.0f);
//    else
//        pjsua_conf_adjust_rx_level(0 /* pjsua_conf_port_id slot*/, 1.0f);
//}

-(BOOL)silenced
{
#if TARGET_IPHONE_SIMULATOR
    // return NO in simulator. Code causes crashes for some reason.
    return NO;
#endif
    
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
        return NO;
    else
        return YES;
}

#define dtmf delegate

/*
- (void)DTMFView:(DTMFView *)view didPressDTMF:(NSString *)dtmf tone:(NSInteger)tone
{
    NSLog(@"didPressDTMF=%@ tone=%d", dtmf, tone);
    [_call sendDTMF:dtmf];
    
    [_dtmfString appendString:dtmf];
    _miniTitleLabel.text = _dtmfString;
    
    //播放按键音
    if (![self silenced]) {
        AudioServicesPlaySystemSound(tone);
    }
}*/


#pragma mark - WJT VOIP


- (void)voipCall:(NSString *)phone
{
    //登录
    NSDictionary *sipDict = [[USER_AGENT config] objectForKey:@"sip"];
    NSString *domain = [NSString stringWithFormat:@"%@:%@", sipDict[@"proxy"], sipDict[@"port"]];
    
    DDLogDebug(@"----------voipCall phone:%@ -------------", phone);
 
    GSAccount *account = [USER_AGENT sipAccount];
    NSString *prefix = [USER_DEFAULT boolForKey:kUserAgentDisplay] ? sipDict[@"disprefix"] : sipDict[@"prefix"];
    NSString *address = [NSString stringWithFormat:@"%@%@@%@", prefix, phone, domain];


    self.call = [GSCall outgoingCallToUri:address fromAccount:account];
    [_call begin];
    
    //通话成功, 添加一条通话记录
    [self addCallLog];
    [NOTIFY_CENTER postNotificationName:NOTIFY_CALL_SUCCSSFUL object:nil];

}




@end


