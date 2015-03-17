//
//  ServiceMonitor.h
//  Woxin2.0
//
//  Created by le ting on 7/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMonitor : NSObject
@property (nonatomic,assign)BOOL isConnected;//是否和服务器连接着~
@property (nonatomic,assign)BOOL hasLogin; //是否已经登陆了~ （断开了也无所谓~)
@property (nonatomic,assign)BOOL isLogin; //是否在登陆状态~
@property (nonatomic,assign)BOOL isInLogin; //是否在登陆的过程中
@property (nonatomic,assign)BOOL isInLogOut; //是否在下线的过程中

@property (nonatomic,assign)BOOL isInUnregister; //是否在注销过程中~

+ (ServiceMonitor*)sharedServiceMonitor;

- (BOOL)canLoginNow;
- (BOOL)canLogOutNow;
- (BOOL)canUnregister;
@end
