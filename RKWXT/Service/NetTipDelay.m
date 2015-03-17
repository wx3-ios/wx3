//
//  NetTipDelay.m
//  Woxin2.0
//
//  Created by Elty on 10/3/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "NetTipDelay.h"

#define kNetTipDelayTimeInterval (3.0)
@interface NetTipDelay()
{
    BOOL _isInDelay;
}
@end

@implementation NetTipDelay
@synthesize isInDelay = _isInDelay;

+ (NetTipDelay*)sharedNetTipDelay{
    static dispatch_once_t onceToken;
    static NetTipDelay *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetTipDelay alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        _isInDelay = YES;
    }
    return self;
}

- (void)startDelay{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _isInDelay = YES;
    [self performSelector:@selector(delayFinished) withObject:nil afterDelay:kNetTipDelayTimeInterval];
}

- (void)delayFinished{
    _isInDelay = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_NetTipDelayFinished object:nil];
}

@end
