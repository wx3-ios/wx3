//
//  NSDate+Compare.h
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define	kMinuteLen (60)
#define	kHourLen (60*60)
#define	kDayLen (60*60*24)

typedef enum {
	E_YMD = 0, //年月日
	E_MD,//月日
	E_YMDHM,//年月日时分
	E_MDHM,//月日时分
	E_HM,//时分
}E_YMDHM_TYPE;

@interface NSDate (Compare)

+ (NSInteger)todayTimeIntervalSince1970;//now到1970的秒数
- (NSDateComponents*)dateComponents;//获取当前的年月日
- (BOOL)isToday;//是否为今天
- (BOOL)isYesterday;//是否为明天
- (BOOL)isTheDayBeforeYesterday;//是否为前天
- (BOOL)isTomorrow;//是否为明天
- (BOOL)isTheDayAfterTomorrow;//是否为后天

//年月日时分秒
- (NSString*)YMRSFMString;
- (NSString*)YMDHMString:(E_YMDHM_TYPE)type;
- (NSString*)timestamp;
@end
