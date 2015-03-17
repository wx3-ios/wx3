//
//  NetWorkMonitor.h
//  Woxin2.0
//
//  Created by Elty on 11/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	E_NetWorkStatus_Init = -1,
	E_NetWorkStatus_Disconnected = 0, //没有连接
	E_NetWorkStatus_WWAN,//数据
	E_NetWorkStatus_WIFI,//wifi
}E_NetWorkStatus;

@interface NetWorkMonitor : NSObject
@property (nonatomic,assign)E_NetWorkStatus currentWorkStatus;

+ (NetWorkMonitor*)sharedNetWorkMonitor;
- (BOOL)isConnected;
@end
