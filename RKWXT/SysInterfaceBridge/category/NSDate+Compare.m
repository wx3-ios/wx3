//
//  NSDate+Compare.m
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

+ (NSInteger)todayTimeIntervalSince1970{
	NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
    return timeInterval;
}

- (NSDateComponents*)dateComponents{
    NSCalendar *dateCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [dateCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
    return dateComponents;
}

- (NSInteger)daysBeforeToday{
    NSInteger cSeconds = [self timeIntervalSince1970];
    NSInteger todaySeconds = [[NSDate date] timeIntervalSince1970];
    
    NSTimeZone * tz = [NSTimeZone localTimeZone];
    NSInteger zoneseconds = [tz secondsFromGMT];
    
    NSInteger secondsPerDay = 3600*24;
    NSInteger cDays = (cSeconds + zoneseconds)/secondsPerDay;
    NSInteger todayDays = (todaySeconds + zoneseconds)/secondsPerDay;
    NSInteger count = todayDays - cDays;
    return count;
}

- (BOOL)isToday{
    return [self daysBeforeToday] == 0;
}

- (BOOL)isYesterday{
    return [self daysBeforeToday] == 1;
}

- (BOOL)isTheDayBeforeYesterday{
    return [self daysBeforeToday] == 2;
}

- (BOOL)isTomorrow{
    return [self daysBeforeToday] == -1;
}

- (BOOL)isTheDayAfterTomorrow{
    return [self daysBeforeToday] == -2;
}

- (NSString*)YMRSFMString{
	return [self YMDHMString:E_YMDHM];
}

- (NSString*)YMRStringWithYear:(BOOL)bYear{
	NSString *ymrsfmString = nil;
	if([self isToday]){
		ymrsfmString = @"今天";
	}else if ([self isYesterday]){
		ymrsfmString = @"昨天";
	}else if([self isTheDayBeforeYesterday]){
		ymrsfmString = @"前天";
	}else if([self isTomorrow]){
		ymrsfmString = @"明天";
	}else if([self isTheDayAfterTomorrow]){
		ymrsfmString = @"后天";
	}else{
		NSDateComponents *dateComponents = [self dateComponents];
		ymrsfmString = [NSString stringWithFormat:@"%02d-%02d",(int)dateComponents.month,(int)dateComponents.day];
		if (bYear){
			ymrsfmString = [NSString stringWithFormat:@"%d-%@",(int)dateComponents.year,ymrsfmString];
		}
	}
	return ymrsfmString;
}

- (NSString*)YMDHMString:(E_YMDHM_TYPE)type{
	NSString *ymdString = nil;
	NSDateComponents *dateComponents = [self dateComponents];
	NSString *hmString = [NSString stringWithFormat:@"%02d:%02d",(int)dateComponents.hour,(int)dateComponents.minute];
	switch (type){
			case E_YMD:
			ymdString = [self YMRStringWithYear:YES];
			hmString = nil;
			break;
			case E_MD:
			ymdString = [self YMRStringWithYear:NO];
			hmString = nil;
			break;
			case E_YMDHM:
			ymdString = [self YMRStringWithYear:YES];
			break;
			case E_MDHM:
			ymdString = [self YMRStringWithYear:NO];
			break;
			case E_HM:
			ymdString = nil;
			break;
	}
	NSString *timeStr = [NSMutableString string];
	if (ymdString){
		timeStr = [timeStr stringByAppendingString:ymdString];
	}
	
	if (hmString){
		if (ymdString){
			timeStr = [timeStr stringByAppendingString:@" "];
		}
		
		timeStr = [timeStr stringByAppendingString:hmString];
	}
	return timeStr;
}

- (NSString*)timestamp{
	NSDateComponents *cmps = [self dateComponents];
	NSInteger year = cmps.year;
	NSInteger month = cmps.month;
	NSInteger day = cmps.day;
	NSInteger hour = cmps.hour;
	NSInteger min = cmps.hour;
	NSInteger seconds = cmps.second;
	return [NSString stringWithFormat:@"%d%d%d%d%d%d",(int)year,(int)month,(int)day,(int)hour,(int)min,(int)seconds];
}

@end
