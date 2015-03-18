//
//  ServiceMonitor.m
//  Woxin2.0
//
//  Created by le ting on 7/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ServiceMonitor.h"
#import "ServiceCommon.h"
#import "WXService.h"

@implementation ServiceMonitor

- (void)dealloc{
    [self removeServiceOBS];
//    [super dealloc];
}

+ (ServiceMonitor*)sharedServiceMonitor{
    static dispatch_once_t onceToken;
    static ServiceMonitor *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServiceMonitor alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        [self addServiceOBS];
    }
    return self;
}

- (void)addServiceOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loginBegin:) name:D_Notification_Name_LoginBegin object:nil];
    [notificationCenter addObserver:self selector:@selector(loginSucceed:) name:D_Notification_Name_LoginSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loginFailed:) name:D_Notification_Name_LoginFailed object:nil];
	[notificationCenter addObserver:self selector:@selector(loginFailed:) name:D_Notification_Name_LoginNoSuchAccount object:nil];
	[notificationCenter addObserver:self selector:@selector(loginFailed:) name:D_Notification_Name_LoginTimeOut object:nil];
    
    [notificationCenter addObserver:self selector:@selector(logoutBegin:) name:D_Notification_Name_LogoutBegin object:nil];
    [notificationCenter addObserver:self selector:@selector(logoutSucceed:) name:D_Notification_Name_LogoutSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(logoutFailed:) name:D_Notification_Name_LogoutFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(logoutSucceed:) name:D_Notification_Name_KickedOut object:nil];

    [notificationCenter addObserver:self selector:@selector(serviceConnected:) name:D_Notification_Name_ServiceConnectedOK object:nil];
    [notificationCenter addObserver:self selector:@selector(serviceDisconnected:) name:D_Notification_Name_ServiceDisconnect object:nil];
}

- (void)loginBegin:(NSNotification*)notification{
    KFLog_Normal(YES, @"开始上线");
    [self setIsInLogin:YES];
}

- (void)loginSucceed:(NSNotification*)notification{
    KFLog_Normal(YES, @"上线成功");
    [self setIsInLogin:NO];
    KFLog_Normal(YES, @"停止上线");
    [self setIsLogin:YES];
    KFLog_Normal(YES, @"已经上线")
    [self setHasLogin:YES];
}

- (void)loginFailed:(NSNotification*)notification{
    KFLog_Normal(YES, @"停止上线");
    [self setIsInLogin:NO];
    KFLog_Normal(YES, @"上线失败");
    [self setIsLogin:NO];
}

- (void)logoutBegin:(NSNotification*)notification{
    KFLog_Normal(YES, @"开始下线~");
    [self setIsInLogOut:YES];
}

- (void)logoutSucceed:(NSNotification*)notification{
    KFLog_Normal(YES, @"停止下线");
    [self setIsInLogOut:NO];
    KFLog_Normal(YES, @"下线成功");
    [self setIsLogin:NO];
    KFLog_Normal(YES, @"设置还没有上线~");
    [self setHasLogin:NO];
}

- (void)logoutFailed:(NSNotification*)notification{
    KFLog_Normal(YES, @"停止上线");
    [self setIsInLogOut:NO];
}

- (void)unregisterBegin:(NSNotification*)notification{
    KFLog_Normal(YES, @"开始注销");
    [self setIsInUnregister:YES];
}

- (void)unregisterSucceed:(NSNotification*)notifiction{
    KFLog_Normal(YES, @"注销成功");
    KFLog_Normal(YES, @"设置已经下线");
    [self setIsLogin:NO];
    KFLog_Normal(YES, @"设置还没有上线·");
    [self setHasLogin:NO];
    KFLog_Normal(YES, @"停止注销");
    [self setIsInUnregister:NO];
}

- (void)unregisterFailed:(NSNotification*)notification{
    KFLog_Normal(YES, @"注销失败");
    KFLog_Normal(YES, @"停止注销");
    [self setIsInUnregister:NO];
}

- (void)serviceDisconnected:(NSNotification*)notification{
    KFLog_Normal(YES, @"与服务器断开连接");
    [self setIsInLogOut:NO];
    [self setIsInLogin:NO];
    [self setIsLogin:NO];
    [self setIsConnected:NO];
    [self setIsInUnregister:NO];
}

- (void)serviceConnected:(NSNotification*)notification{
    KFLog_Normal(YES, @"成功连接服务器");
    [self setIsConnected:YES];
    
    //如果已经登陆了~ 则需要再次上线~
    if([self hasLogin]){
        WXError *error = nil;
#warning 上线失败怎么办？
        [[WXService sharedService] login:[WXUserOBJ sharedUserOBJ].user password:[WXUserOBJ sharedUserOBJ].pwd erorr:&error];
    }
}

- (void)removeServiceOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}


#pragma mark 判断是否可以做响应的操作~
- (BOOL)canLoginNow{
    if(_isInLogin){
        KFLog_Normal(YES, @"正在上线，不能重复操作上线~");
        return NO;
    }
    if(_isInLogOut){
        KFLog_Normal(YES, @"正在下线，不能操作上线");
        return NO;
    }
    
    if(_isInUnregister){
        KFLog_Normal(YES, @"正在注销,不能处理上线操作");
    }
    return YES;
}

- (BOOL)canLogOutNow{
    if(_isInLogOut){
        KFLog_Normal(YES, @"正在下线,不能重复操作下线操作");
        return NO;
    }
    return YES;
}

- (BOOL)canUnregister{
    if(_isInUnregister){
        KFLog_Normal(YES, @"正在注销，不能重复注销操作");
        return NO;
    }
    return YES;
}

@end
