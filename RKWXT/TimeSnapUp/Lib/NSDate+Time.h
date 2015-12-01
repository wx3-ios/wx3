//
//  NSDate+Time.h
//  RKWXT
//
//  Created by app on 15/12/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)
+ (BOOL)timeJetLagWithEndTime:(NSDate*)endTime;
+ (NSDateComponents*)compareTime:(NSDate*)compareDate;
@end
