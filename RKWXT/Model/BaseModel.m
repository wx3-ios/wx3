//
//  BaseModel.m
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "BaseModel.h"
#import "ServiceCommon.h"
#import "WXService.h"

@implementation BaseModel

- (void)dealloc{
	[self removeServiceConnectedDetector];
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		_status = E_ModelDataStatus_Init;
		[self detecteServiceConnectedOK];
	}
	return self;
}

- (void)detecteServiceConnectedOK{
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceConnectedDetected:) name:D_Notification_Name_ServiceConnectedOK object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceConnectedDetected:) name:D_Notification_Name_AutoLoginHasCalled object:nil];
}

- (void)removeServiceConnectedDetector{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:D_Notification_Name_ServiceConnectedOK object:nil];
}

- (void)toInit{
	_status = E_ModelDataStatus_Init;
}

- (E_LoadDataReturnValue)checkReturnValueInAdvance{
	E_LoadDataReturnValue ret = E_LoadDataReturnValue_UnDetermined;
	switch (_status) {
	case E_ModelDataStatus_Loading:
		ret = E_LoadDataReturnValue_ISLoading;
		break;
	case E_ModelDataStatus_LoadSucceed:
		ret = E_LoadDataReturnValue_ISLoaded;
		break;
	default:
		break;
	}
	return ret;
}

//- (void)serviceConnectedDetected:(NSNotification*)notification{
//	AppDelegate *app = [UIApplication sharedApplication].delegate;
//	//DB库发生了变化~ 但是又没有调用自动登录~ 则这个消息延后处理~
//	if (app.dbHasChanged){
//		if (![WXService sharedService].hasCalledLogin){
//			return;
//		}
//	}
//	if ([self respondsToSelector:@selector(serviceConnectedOK)]){
//		[self serviceConnectedOK];
//	}
//}

@end
