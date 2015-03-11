//
//  CallViewController.m
//  AiCall
//
//  Created by jjyo.kwan on 13-11-26.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import "CallViewController.h"
#import "ContactUitl.h"
#import "PhoneData.h"
#import "RecentData.h"
//#import "RecentHelper.h"
//#import "AreaHelper.h"

#define CALLBACK_TIMEOUT 15

@interface CallViewController ()

@property (nonatomic, strong) PhoneData *phoneData;
@property (nonatomic, strong) NSDate *callDate;
@property (assign) int countdown;
@property (assign) BOOL callSuccess;//请求成功

@end

@implementation CallViewController

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
    _loadingView.hidden = YES;
    _tipsLabel.hidden = YES;
    _phoneLabel.hidden = YES;
    _phoneLabel.text = [USER_DEFAULT stringForKey:kUserAgentPhone];
    
    self.callDate = [NSDate date];
    _countdown = CALLBACK_TIMEOUT;
    
    ContactData *cd = [[ContactUitl shareInstance] queryContactFromPhone:_callPhone];
    _phoneData = [PhoneData dataWithPhone:_callPhone];
    
    _titleLabel.text = cd.name ? cd.name : [_phoneData displayNumber];
    if (_phoneData.area)
    {
        _subtitleLable.text = _phoneData.area;
    }
    else
    {
//        _subtitleLable.text = [[AreaHelper sharedAreaHelper] queryByPhone:_callPhone];
    }
    [NOTIFY_CENTER addObserver:self selector:@selector(handleBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self calloutAction];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [NOTIFY_CENTER removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)handleBecomeActive:(NSNotification *)notify
{
    [self handup:NO];
    if (_callSuccess) {
        [USER_AGENT updateBalance:nil];
    }
}


- (void)addCallLog
{
    RecentData *recent = [[RecentData alloc]init];
    recent.phone = [NSString stringWithString:_callPhone];
    recent.date = _callDate;
    recent.area = _phoneData.area;
//    [[RecentHelper sharedRecentHelper] insert:recent];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)callTimer
{
    --_countdown;
    if (_countdown < 0) {
        [self handup:YES];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:(_callSuccess ? @"请注意接听系统来电。[%d]" : @"正在呼叫...[%d]"), MAX(0, _countdown)];
    //    [_handupButton setTitle:title forState:UIControlStateNormal];
    _stateLabel.text = title;
    [self performSelector:@selector(callTimer) withObject:nil afterDelay:1.];
}


- (void)backgroundNotifiication:(NSNotification *)notify
{
    [self handup:NO];
}

- (void)handup:(BOOL)animated
{
    if (_callSuccess){
        [self addCallLog];
        [NOTIFY_CENTER postNotificationName:NOTIFY_CALL_SUCCSSFUL object:nil];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callTimer) object:nil];
    
    if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissViewControllerAnimated:animated completion:^{
            //[self callFinish];
        }];
    }
    
}


- (IBAction)handupAction:(id)sender
{
    [self handup:YES];
}

#pragma mark - http action
- (void)calloutAction
{
    [UIView animateWithDuration:0.5 animations:^{
        _loadingView.hidden = NO;
    }];
    
    //倒计时
    [self callTimer];
    //请求
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        BOOL fast = [USER_DEFAULT boolForKey:kUserAgentFast];
        BOOL display = [USER_DEFAULT boolForKey:kUserAgentDisplay];
        NSString *phone = [[self class] pheoneChangeWith:_callPhone];
        NSDictionary *attr = @{@"callee":phone, @"fast":@(fast), @"display":@(display)};
        NSDictionary *json = [NET_REQUEST httpAction:@"app_cb.php" attribute:attr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (RESULT_SUCCESS(json)) {
                _stateLabel.text = @"呼叫成功, 请等待接听来电!";
                _callSuccess = YES;
                _tipsLabel.hidden = NO;
                _phoneLabel.hidden = NO;
            }
            else
            {
                [self makeToast:RESULT_MESSAGE(json)];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"呼叫失败" message:RESULT_MESSAGE(json) delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [self handup:YES];
            }
        });
        
    });*/
}

+(NSString*)pheoneChangeWith:(NSString*)oldPhone{
    NSString *newPhone = nil;
    NSString *str = [NSString stringWithFormat:@"%c2B",'%'];
    if([oldPhone hasPrefix:@"86"]){
        newPhone = [NSString stringWithFormat:@"%c2B%@",'%',oldPhone];
        return newPhone;
    }
    if([oldPhone hasPrefix:@"+86"]){
        NSString *str = [oldPhone substringFromIndex:1];
        oldPhone = [NSString stringWithFormat:@"%c2B%@",'%',str];
        return oldPhone;
    }
    if([oldPhone hasPrefix:str]){
        return oldPhone;
    }
    newPhone = [NSString stringWithFormat:@"%c2B86%@",'%',oldPhone];
    return newPhone;
}


@end
