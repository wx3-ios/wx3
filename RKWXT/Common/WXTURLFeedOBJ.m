//
//  WXTURLFeedOBJ.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ.h"

@implementation WXTURLFeedOBJ

+ (WXTURLFeedOBJ*)sharedURLFeedOBJ{
    static dispatch_once_t onceToken;
    static WXTURLFeedOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXTURLFeedOBJ alloc] init];
    });
    return sharedInstance;
}

- (NSString*)rootURL:(WXT_UrlFeed_Type)type{
    NSString *url = nil;
    NSString *rootURL = [NSString stringWithFormat:@"http://api.67call.com/agent/api.php"];
    switch (type) {
        case WXT_UrlFeed_Type_LoadBalance:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Recharge:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Sign:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Login:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Regist:
            url = @"";
            break;
        default:
            break;
    }
    NSString *compURL = [NSString stringWithFormat:@"%@%@",rootURL,url];
    return compURL;
}

- (NSString*)urlRequestParamFrom:(NSDictionary*)dic{
    NSArray *keys = [dic allKeys];
    if ([keys count] == 0){
        return nil;
    }
    
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *key in keys){
        id value = [dic objectForKey:key];
        if (!value){
            KFLog_Normal(YES, @"无效的参数 key = %@",key);
            continue;
        }
        if ([keys indexOfObject:key] != 0){
            [mutString appendString:@"&"];
        }
        [mutString appendFormat:@"%@=%@",key,value];
    }
    return mutString;
}

@end
