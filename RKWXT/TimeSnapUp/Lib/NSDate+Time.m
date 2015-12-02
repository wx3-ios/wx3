//
//  NSDate+Time.m
//  RKWXT
//
//  Created by app on 15/12/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)
//判断现在和未来时间差是否小于24
+ (BOOL)timeJetLagWithEndTime:(NSDate*)endTime{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit  unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSDateComponents *com = [calendar components:unit fromDate:nowDate toDate:endTime options:0];
    
    
    
    if (com.year == 0 && com.month == 0 && com.day == 0 ) {
        
        return YES;
        
    }
    
    return NO;
}

//判断是不是同一天
+ (BOOL)isCurrentDay:(NSDate *)aDate
{
    if (aDate==nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate]){
        return YES;
    }
    
    return NO;
}

+ (NSDateComponents*)compareTime:(NSDate*)compareDate{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit  unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSDateComponents *com = [calendar components:unit fromDate:nowDate toDate:compareDate options:0];
    return  com;
    
}




@end
