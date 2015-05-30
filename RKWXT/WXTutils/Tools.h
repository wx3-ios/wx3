//
//  Tools.h
//  Okboo
//
//  Created by jjyo.kwan on 12-8-15.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NetworkStatusNone = 0,
    NetworkStatusWifi,
    NetworkStatus2G,
    NetworkStatus3G,
    NetworkStatus4G,
}NetworkStatus1;

@interface Tools : NSObject




+ (NSString*)hexRC4String:(NSString*)str key:(NSString*)key;

+ (NSString *)prettyFormatDate:(NSDate *)date;

+ (NSString *)stringFormDate:(NSDate *)date dateFormat:(NSString *)format;

+ (NSDate *)dateFormString:(NSString *)string dateFormat:(NSString *)format;

+ (NetworkStatus1)currentNetWorkStatus;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+(NSString*)pheoneChangeWith:(NSString*)oldPhone;

+(NSString*)newPhoneWithString:(NSString*)oldPhone;

@end
