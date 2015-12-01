//
//  NSDate+Time.m
//  RKWXT
//
//  Created by app on 15/12/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)
+ (BOOL)timeJetLagWithEndTime:(NSDate*)endTime{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit  unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSDateComponents *com = [calendar components:unit fromDate:nowDate toDate:endTime options:0];
    
    if (com.year == 0 && com.month == 0 && com.day ==0) {
        return YES;
    }
    
    return (com.year == 0 && com.month == 0 && com.day ==0);
}

+ (NSDateComponents*)compareTime:(NSDate*)compareDate{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit  unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSDateComponents *com = [calendar components:unit fromDate:nowDate toDate:compareDate options:0];
    return  com;
    
}




@end
