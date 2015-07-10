//
//  WXService.m
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXService.h"
#import "WXServiceParse.h"
#import "ServiceMonitor.h"
//#import "OpenUDID.h"

#define D_ServiceLog_Open

@interface WXService()
{
    BOOL _bInLogOut;
}
@end

@implementation WXService

+ (WXService*)sharedService{
    static dispatch_once_t onceToken;
    static WXService *sharedService = nil;
    dispatch_once(&onceToken, ^{
        sharedService = [[WXService alloc] init];
    });
    return sharedService;
}

@end
