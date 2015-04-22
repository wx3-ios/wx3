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
#import "ContactUitl.h"
#import "CallRecord.h"
#import "HangupModel.h"

#define Size self.view.bounds.size
#define NormalTimer (15.0)

@interface CallBackVC()<MakeCallDelegate,HangupDelegate>{
    NSTimer *_timer;
    //    NSTimer *_chengeTimer;
    
    UIImageView *_lightImg;
    UILabel *callStatus;
    
    NSInteger count;
    NSInteger time;
    
    CallModel *_model;
    
    UILabel *phoneAreaLabel;
    NSString *phoneArea;
    
    HangupModel *_hangupModel;
    WXTUIButton *_hangupBtn;
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
    [notification addObserver:self selector:@selector(back) name:D_Notification_Name_SystemCallIncomming object:nil];
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
    
    yOffset += nameHeight;
    phoneAreaLabel = [[UILabel alloc] init];
    phoneAreaLabel.frame = CGRectMake((Size.width-nameWidth)/2, yOffset, nameWidth, nameHeight);
    [phoneAreaLabel setBackgroundColor:[UIColor clearColor]];
    [phoneAreaLabel setFont:WXTFont(16.0)];
    [phoneAreaLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [phoneAreaLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:phoneAreaLabel];
    if([phoneArea isEqualToString:@""]){
        [phoneAreaLabel setHidden:YES];
    }else{
        [phoneAreaLabel setText:phoneArea];
    }
    
    CGFloat xOffset = 40;
    if(Size.width == 375){
        xOffset = 76;
    }
    if(Size.width == 414){
        xOffset = 92;
    }
    CGFloat xGap = 9;
    yOffset += 60;
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
    [callStatus setText:@"(呼叫请求中...)"];
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
    
    yOffset += textHeight+30;
    textWidth += 10;
    _hangupBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _hangupBtn.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, 2*textHeight);
    [_hangupBtn setBorderRadian:10.0 width:0.5 color:[UIColor redColor]];
    [_hangupBtn setBackgroundColor:[UIColor redColor]];
    [_hangupBtn setEnabled:NO];
    [_hangupBtn setImage:[UIImage imageNamed:@"HangupCall.png"] forState:UIControlStateNormal];
    [_hangupBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hangupBtn];
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
    if([Tools currentNetWorkStatus] == NetworkStatusNone){
        [UtilTool showAlertView:@"本机网络不畅，请检查网络再试"];
        return NO;
    }
    
    _model = [[CallModel alloc] init];
    [_model setCallDelegate:self];
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:phone];
//    if(![UtilTool determineNumberTrue:phoneStr]){
//        [UtilTool showAlertView:@"您要拨打的号码格式不正确"];
//        return NO;
//    }
    if(!phoneStr){
        return NO;
    }
    [_model makeCallPhone:phoneStr];
    _model.callstatus_type = CallStatus_Type_starting;
    phoneArea = [self phoneAreaWithNumber:phone];

    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString * dateStr = [formatter stringFromDate:date];
    CallHistoryEntity *entity = [[CallHistoryEntity alloc] initWithName:@"我信" telephone:phoneStr startTime:dateStr duration:5 type:E_CallHistoryType_MakingReaded];
    [[CallRecord sharedCallRecord] addSingleCallRecord:entity];
    return YES;
}

//显示号码归属地
-(NSString *)phoneAreaWithNumber:(NSString*)number{
    NSString *areaStr = nil;
    areaStr = [[ContactUitl shareInstance] queryByPhone:number];
    if(!areaStr){
        areaStr = @"";
    }
    return areaStr;
}

-(void)makeCallPhoneFailed:(NSString *)failedMsg{
//    if(!failedMsg){
//        failedMsg = @"本机网络不畅，请设置网络连接";
//    }
//    [UtilTool showAlertView:failedMsg];
    [self back];
}

-(void)makeCallPhoneSucceed{
    [_hangupBtn setEnabled:YES];
    [callStatus setText:@"(呼叫成功)"];
    //    _chengeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideChangeStatus) userInfo:nil repeats:NO];
    _model.callstatus_type = CallStatus_Type_Ending;
}

-(void)hideChangeStatus{
    //    [_chengeTimer invalidate];
    [callStatus setHidden:YES];
}

#pragma mark hangupDelegate
-(void)hangup{
    if(!_model.callID){
        return;
    }
    _hangupModel = [[HangupModel alloc] init];
    [_hangupModel setHangupDelegate:self];
    [_hangupModel hangupWithCallID:_model.callID];
}

-(void)hangupFailed:(NSString *)failedMsg{
    
}

-(void)hangupSucceed{
    [self back];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)back{
    _model.callstatus_type = CallStatus_Type_Ending;
    [_timer invalidate];
    [_model setCallDelegate:nil];
    [_hangupModel setHangupDelegate:nil];
    [self removeNotification];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
