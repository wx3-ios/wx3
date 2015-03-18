//
//  NetWorkMonitor.m
//  Woxin2.0
//
//  Created by Elty on 11/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "NetWorkMonitor.h"
#import "Reachability.h"
#import "it_lib.h"

@interface NetWorkMonitor()
{
	Reachability  *_hostReach;
}
@end

@implementation NetWorkMonitor

- (void)dealloc{
	[self removeOBS];
//	[super dealloc];
}

+ (NetWorkMonitor*)sharedNetWorkMonitor{
	static dispatch_once_t onceToken;
	static NetWorkMonitor *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[NetWorkMonitor alloc] init];
	});
	return sharedInstance;
}

- (id)init{
	if (self = [super init]){
		_currentWorkStatus = E_NetWorkStatus_Init;
		_hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
		[_hostReach startNotifier];
		//		[self updateInterfaceWithReachability:_hostReach];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(reachabilityChanged:)
													 name: kReachabilityChangedNotification
												   object: nil];
	}
	return self;
}

- (void)reachabilityChanged:(NSNotification *)notification {
	Reachability* curReach = [notification object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	E_NetWorkStatus lastStatus = _currentWorkStatus;
	[self updateInterfaceWithReachability:curReach];
	if (lastStatus == E_NetWorkStatus_Init){
		return;
	}
	IT_NetworkModeChange(1);
	//	if (_currentWorkStatus == NotReachable){
	//		IT_NetworkModeChange(0);
	//	}else{
	//		IT_NetworkModeChange(1);
	//	}
}

- (void)updateInterfaceWithReachability:(Reachability*)curReach{
	NetworkStatus status = [curReach currentReachabilityStatus];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	switch (status) {
		case NotReachable:
			KFLog_Normal(YES, @"NotReachable");
			_currentWorkStatus = E_NetWorkStatus_Disconnected;
			[notificationCenter postNotificationName:D_Notification_Name_NetWorkDisconnected object:nil];
			break;
		case ReachableViaWWAN:
			KFLog_Normal(YES, @"ReachableViaWWAN");
			_currentWorkStatus = E_NetWorkStatus_WWAN;
			[notificationCenter postNotificationName:D_Notification_Name_NetWorkWWAN object:nil];
			break;
		case ReachableViaWiFi:
			KFLog_Normal(YES, @"ReachableViaWiFi");
			_currentWorkStatus = E_NetWorkStatus_WIFI;
			[notificationCenter postNotificationName:D_Notification_Name_NetWorkWifi object:nil];
			break;
	}
}

- (BOOL)isConnected{
	return self.currentWorkStatus != E_NetWorkStatus_Disconnected;
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
