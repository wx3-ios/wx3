//
//  UserAgent.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-8.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GSAccount.h"

#define USER_AGENT [UserAgent sharedUserAgent]

#define kUserAgentUid @"agent.uid"
#define kUserAgentPwd @"agent.pwd"
#define kUserAgentPhone @"agent.phone"
#define kUserAgentMsgDate @"agent.msg.date"
#define kUserAgentVersion @"agent.version" //最新版本号
#define kUserAgentUpdataVer @"agent.updataVer"//点击升级
#define kUserAgentVerUrlAddress @"agent.verAddress" //更新下载地址
#define kUserAgentThemeSeleced @"agent.theme.selected"
#define kUserAgentDisplay @"agent.display"//去显
#define kUserAgentFast @"agent.fast"
#define kUserAgentToken     @"agent.token"
#define kUserAgentFirstInit @"agent.first"//第一次登录
#define kUserAgentVibration @"agent.vibration"//震动
#define kUserAgentLocation @"agent.location"
#define kUserAgentSipCall      @"agent.sip.call" //直拨


#define NOTIFY_LOGIN         @"NotifyLogin"
#define NOTIFY_LOGOUT        @"NotifyLogout"
#define NOTIFY_CALL_SUCCSSFUL @"NotifyCallSuccssful" //呼叫成功

//#define THEME_COLOR UIColorFromRGB(0x00a762)
#define THEME_COLOR [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]   //后加的

@class EGODatabase;

@interface UserAgent : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(UserAgent);

//配置参数
@property (nonatomic, strong) NSDictionary *config;
@property (nonatomic, strong) NSDictionary *balance;
@property (nonatomic, strong) EGODatabase *database;

- (BOOL)hasLogin;

- (void)initData;

- (void)updateBalance:(void(^)(NSDictionary *balance))complete;

#pragma mark - sip

//@property (nonatomic, strong) GSAccount *sipAccount;


@end
