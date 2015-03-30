//
//  CallBackVC.m
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CallBackVC.h"
#import "CallModel.h"
#import "WXTDatabase.h"
#define Size self.view.bounds.size
#define NormalTimer (15.0)

@interface CallBackVC()<MakeCallDelegate>{
    NSTimer *_timer;
//    NSTimer *_chengeTimer;
    
    UIImageView *_lightImg;
    UILabel *callStatus;
    
    NSInteger count;
    NSInteger time;
    
    CallModel *_model;
}
@end

@implementation CallBackVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self addNotification];
}

-(void)viewDidLoad{
    [super viewDidLoad];
 
    UIImage *img = [UIImage imageNamed:@"CallBackBgImg.jpg"];
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [bgImgView setImage:img];
    [self.view addSubview:bgImgView];
    
    [self createBackBtn];
    [self createUserNameView];
    [self createBaseView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startActivityImg) userInfo:nil repeats:YES];
}

-(void)addNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(back) name:D_Notification_Name_SystemCallFinished object:nil];
}

-(void)createBackBtn{
    CGFloat yOffset = 50;
    CGFloat xOffset = 15;
    UIImage *backImg = [UIImage imageNamed:@"CallBackBtn.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, backImg.size.width, backImg.size.height);
    [backBtn setImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)createUserNameView{
    CGFloat yOffset = 90;
    CGFloat nameWidth = 180;
    CGFloat nameHeight = 30;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake((Size.width-nameWidth)/2, yOffset, nameWidth, nameHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:_phoneName];
    [nameLabel setFont:WXTFont(23.0)];
    [nameLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    
    CGFloat xOffset = 40;
    if(Size.width == 375){
        xOffset = 76;
    }
    if(Size.width == 414){
        xOffset = 92;
    }
    CGFloat xGap = 9;
    yOffset += 60+nameHeight;
    UIImage *smallIconImg = [UIImage imageNamed:@"CallBackIconImgNor.png"];
    for(int i = 0;i < 7; i++){
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.frame = CGRectMake(xOffset+i*(smallIconImg.size.width+xGap), yOffset, smallIconImg.size.width, smallIconImg.size.height);
        [iconImgView setImage:smallIconImg];
        [self.view addSubview:iconImgView];
    }
    
    _lightImg = [[UIImageView alloc] init];
    _lightImg.frame = CGRectMake(xOffset, yOffset, smallIconImg.size.width, smallIconImg.size.height);
    [_lightImg setImage:[UIImage imageNamed:@"CallBackIconImgSel.png"]];
    [self.view addSubview:_lightImg];
}

-(void)createBaseView{
    CGFloat yOffset = 330;
    CGFloat textWidth = 200;
    CGFloat textHeight = 20;
    callStatus = [[UILabel alloc] init];
    callStatus.frame = CGRectMake((Size.width-textWidth)/2, yOffset-50, textWidth, textHeight);
    [callStatus setBackgroundColor:[UIColor clearColor]];
    [callStatus setFont:WXTFont(16.0)];
    [callStatus setTextAlignment:NSTextAlignmentCenter];
    [callStatus setText:@"(呼叫成功)"];
    [callStatus setHidden:YES];
    [callStatus setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:callStatus];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, textHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:WXFont(16.0)];
    [textLabel setText:@"我信正在回拨到你的手机"];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:textLabel];
    
    yOffset += textHeight;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, textHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setFont:WXTFont(16.0)];
    [phoneLabel setText:userObj.user];
    [phoneLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:phoneLabel];
    
    yOffset += textHeight;
    UILabel *textLabel1 = [[UILabel alloc] init];
    textLabel1.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, textHeight);
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    [textLabel1 setFont:WXTFont(16.0)];
    [textLabel1 setTextAlignment:NSTextAlignmentCenter];
    [textLabel1 setText:@"请注意接听稍后来电"];
    [textLabel1 setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:textLabel1];
}

-(void)startActivityImg{
    UIImage *smallIconImg = [UIImage imageNamed:@"CallBackIconImgNor.png"];
    count ++;
    time ++;
    if(time > NormalTimer){
        [self back];
    }
    if(count>6){
        count = 0;
    }
    CGFloat xOffset = 40;
    if(Size.width == 375){
        xOffset = 76;
    }
    if(Size.width == 414){
        xOffset = 92;
    }
    _lightImg.frame = CGRectMake(xOffset+count*(smallIconImg.size.width+9), 180, smallIconImg.size.width, smallIconImg.size.height);
}

#pragma mark callDelegate
-(BOOL)callPhone:(NSString *)phone{
    _model = [[CallModel alloc] init];
    [_model setCallDelegate:self];
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:phone];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"您要拨打的号码格式不正确"];
        return NO;
    }
    [_model makeCallPhone:phoneStr];
    _model.callstatus_type = CallStatus_Type_starting;
    
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString * dateStr = [formatter stringFromDate:date];
    [[WXTDatabase shareDatabase] insertCallHistory:@"我信" telephone:phone date:dateStr type:1];
    
    return YES;
}

-(void)makeCallPhoneFailed:(NSString *)failedMsg{
    if(!failedMsg){
        failedMsg = @"本机网络不畅，请设置网络连接";
    }
    [UtilTool showAlertView:failedMsg];
    [self back];
}

-(void)makeCallPhoneSucceed{
    [callStatus setHidden:NO];
//    _chengeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideChangeStatus) userInfo:nil repeats:NO];
    _model.callstatus_type = CallStatus_Type_Ending;
}

-(void)hideChangeStatus{
//    [_chengeTimer invalidate];
    [callStatus setHidden:YES];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)back{
    _model.callstatus_type = CallStatus_Type_Ending;
    [_timer invalidate];
    [_model setCallDelegate:nil];
    [self removeNotification];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
