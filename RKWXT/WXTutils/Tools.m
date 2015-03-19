//
//  Tools.m
//  Okboo
//
//  Created by jjyo.kwan on 12-8-15.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import "Tools.h"
#import<commoncrypto/CommonDigest.h>
#import "RegexKitLite.h"
@implementation Tools

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}



+ (NSString *)md5FromString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    unsigned int cStrLen = (CC_LONG)strlen(cStr);
    CC_MD5( cStr, cStrLen, result );
    
    NSMutableString *target = [NSMutableString string];
    for(int i = 0; i < 16; ++ i) {
        [target appendFormat:@"%02x", result[i]];
    }
    return target;
}


+ (NSString*)hexRC4String:(NSString*)str key:(NSString*)key
{
    int j = 0;
    unichar res[str.length];
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
    
    for (int y = 0; y < str.length; y++)
    {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        
        unsigned char c = s[i];
        s[i] = s[j];
        s[j] = c;
        
        unsigned char f = [str characterAtIndex:y] ^ s[ (s[i] + s[j]) % 256];
        res[y] = f;
    }
    
    NSMutableString *dest = [NSMutableString string];
    for (int i = 0; i < str.length; i++) {
        [dest appendFormat:@"%02x", res[i]];
    }
    
    return dest;
}





+ (NSString *)prettyFormatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    NSString *dateString = nil;
    NSInteger dayAgo = 0;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *todayDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    NSInteger timeInterval = (int)[date timeIntervalSinceDate:todayDate];
    if (timeInterval < 0) {
//        dayAgo = abs(timeInterval) / (24 * 60 * 60) + 1;
    }
    
    if (dayAgo == 0) {
        [dateFormatter setDateFormat:@"今天 HH:mm"];
        dateString = [dateFormatter stringFromDate:date];
    }
    else if (dayAgo == 1)
    {
        [dateFormatter setDateFormat:@"昨天 HH:mm"];
        dateString = [dateFormatter stringFromDate:date];
    }
    else
    {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        dateString = [dateFormatter stringFromDate:date];
    }
    return dateString;
}

+ (NSString *)stringFormDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFormString:(NSString *)string dateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

+ (NetworkStatus)currentNetWorkStatus
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num) {
        int n = [num intValue];
        if (n == 1)
        {
            return NetworkStatus2G;
        }else if (n == 2)
        {
            return NetworkStatus3G;
        }
        else if (n == 3){
            return NetworkStatus4G;
        }
        else{
            return NetworkStatusWifi;
        }
    }
    return NetworkStatusNone;
    
}


+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+(NSString*)pheoneChangeWith:(NSString*)oldPhone{
    NSString *newPhone = nil;
    NSString *str = [NSString stringWithFormat:@"%c2B",'%'];
    if([oldPhone hasPrefix:@"86"]){
        newPhone = [NSString stringWithFormat:@"%c2B%@",'%',oldPhone];
        return newPhone;
    }
    if([oldPhone hasPrefix:@"+86"]){
        NSString *str = [oldPhone substringFromIndex:1];
        oldPhone = [NSString stringWithFormat:@"%c2B%@",'%',str];
        return oldPhone;
    }
    if([oldPhone hasPrefix:str]){
        return oldPhone;
    }
    newPhone = [NSString stringWithFormat:@"%c2B86%@",'%',oldPhone];
    return newPhone;
}

+(NSString*)newPhoneWithString:(NSString*)oldPhone{
    NSString *newPhone = [NSString string];
    for(int i = 0;i < oldPhone.length; i++){
        NSString *c = [oldPhone substringWithRange:NSMakeRange(i,1)];
        if(![c isEqualToString:@"-"]){
            newPhone = [newPhone stringByAppendingString:c];
        }
    }
    return newPhone;
}

@end
