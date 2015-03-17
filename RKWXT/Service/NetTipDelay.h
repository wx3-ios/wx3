//
//  NetTipDelay.h
//  Woxin2.0
//
//  Created by Elty on 10/3/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTipDelay : NSObject
@property (nonatomic,readonly)BOOL isInDelay;

+ (NetTipDelay*)sharedNetTipDelay;
- (void)startDelay;
@end
