//
//  NSString+Helper.m
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-14.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import "NSString+Helper.h"
#import "RegexKitLite.h"
#import <commoncrypto/CommonDigest.h>
//匹配手机的正则
#define REGEX_MOBILE @"^1[34578]\\d{9}$"
//电话区号正则
#define REGEX_TELEPHONE @"^0[123456789]\\d{8,10}"

@implementation NSString (Helper)



- (NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    unsigned int cStrLen = (CC_LONG)strlen(cStr);
    CC_MD5( cStr, cStrLen, result );
    
    NSMutableString *target = [NSMutableString string];
    for(int i = 0; i < 16; ++ i) {
        [target appendFormat:@"%02x", result[i]];
    }
    return target;
}

//是否纯数字
- (BOOL)isPureInteger
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//是否是手机号码
- (BOOL)isMobileNumber
{
    if (self.length == 11)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_MOBILE];
        if ([predicate evaluateWithObject:self]) {
            return YES;
        }
    }
    return NO;
}
//是否是固定电话号码
- (BOOL)isTelephoneNumber
{
    if (self.length == 11 || self.length == 12) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_TELEPHONE];
//        if ([predicate evaluateWithObject:self]) {
//            return YES;
//        }
        NSRange range = [self rangeOfRegex:REGEX_TELEPHONE];
        return range.length > 2 && range.location == 0;
    }
    return NO;
}


- (NSString *)mobileNumber
{
    if (self.length == 11) {
        //正则匹配是否合法的手机号码
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_MOBILE];
        if ([predicate evaluateWithObject:self]) {
            return self;
        }
    }
    return nil;
}

- (NSString *)areaNumber
{
    NSRange range = [self rangeOfRegex:REGEX_TELEPHONE];
    if (range.length > 0) {
        NSString *str = [self substringWithRange:range];
        if ([str characterAtIndex:2] <= '2')
        {
            return [str substringToIndex:3];
        }
        else{
            if (str.length < 3) {
                return nil;
            }
            return str;
        }
    }
    return nil;
}

- (BOOL)isEmpty
{
    return [self length] == 0;
}

- (NSString*)toHexRC4WithKey:(NSString*)key
{
    int j = 0;
    unichar res[self.length];
    unsigned char s[256];
    for (int i = 0; i < 256; i++)
    {
        s[i] = i;
    }
    for (int i = 0; i < 256; i++)
    {
        j = (j + s[i] + [key characterAtIndex:(i % key.length)]) % 256;
        
        unsigned char c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
    
    int i = j = 0;
    
    for (int y = 0; y < self.length; y++)
    {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        
        unsigned char c = s[i];
        s[i] = s[j];
        s[j] = c;
        
        unsigned char f = [self characterAtIndex:y] ^ s[ (s[i] + s[j]) % 256];
        res[y] = f;
    }
    
    NSMutableString *dest = [NSMutableString string];
    for (int i = 0; i < self.length; i++) {
        [dest appendFormat:@"%02x", res[i]];
    }
    
    return dest;
}

- (NSString *)toPhoneFormat
{
    if (self.length > 3 && self.length <= 11) {
        //手机号码
        NSString *regex = @"^1[3458]";
        NSRange range = [self rangeOfRegex:regex];
        if (range.length > 0) {
            if (self.length < 8) {
                return [NSString stringWithFormat:@"%@ %@", [self substringToIndex:3], [self substringFromIndex:3]];
            }
            return [NSString stringWithFormat:@"%@ %@ %@", [self substringToIndex:3], [self substringWithRange:NSMakeRange(3, 4)], [self substringFromIndex:7]];
        }
    }
    if (self.length > 3 && self.length <= 12) {
        NSString *regex = @"^0\\d{2,3}";
        NSRange range = [self rangeOfRegex:regex];
        if (range.length > 0) {
            int index = ([self characterAtIndex:1] <= '2') ? 3 : 4;
            return [NSString stringWithFormat:@"%@ %@", [self substringToIndex:index], [self substringFromIndex:index]];
        }
    }
    
    return self;
}


@end
