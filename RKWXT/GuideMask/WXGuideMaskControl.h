//
//  WXGuideMaskControl.h
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXGuideCommon.h"

@interface WXGuideMaskControl : NSObject


+ (WXGuideMaskControl*)shared;

- (void)showGuideMask:(E_GuideMaskPage)page atView:(UIView*)superView;
@end
