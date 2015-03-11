//
//  NSString+Helper.h
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-14.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)



- (NSString *)MD5;

- (BOOL)isPureInteger;


//是否是手机号码
- (BOOL)isMobileNumber;
//是否是固定电话
- (BOOL)isTelephoneNumber;


- (NSString *)mobileNumber;

- (NSString *)areaNumber;

- (NSString*)toHexRC4WithKey:(NSString*)key;

- (NSString *)toPhoneFormat;

- (BOOL)isEmpty;

@end
