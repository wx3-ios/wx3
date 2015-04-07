//
//  WXTURLFeedOBJ+Data.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ+Data.h"

#define D_DataURLConnectionDefaultTimeoutInterval (10.0)

@implementation WXTURLFeedOBJ (Data)

- (void)fetchDataFromFeedType:(WXT_UrlFeed_Type)type httpMethod:(WXT_HttpMethod)httpMethod timeoutIntervcal:(CGFloat)timeoutInterval feed:(NSDictionary*)feed completion:(void(^)(URLFeedData *))completion{
    NSString *urlString = [self rootURL:type];
    NSString *paramString = [self urlRequestParamFrom:feed];
    if (paramString){
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,paramString];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    CGFloat timeout = D_DataURLConnectionDefaultTimeoutInterval;
    if (timeoutInterval > 0){
        timeout = timeoutInterval;
    }
    __block NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    if (httpMethod == WXT_HttpMethod_Get){
        [request setHTTPMethod:@"GET"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block URLFeedData *retFeedData = [[URLFeedData alloc] init];
        NSError *error = nil;
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (error){
            NSInteger code = error.code;
            retFeedData.code = code;
            NSString *errorDesc = @"网络请求失败,请稍后再试试";
            switch (code){
                case NSURLErrorTimedOut:
                    errorDesc = @"请求超时";
                    break;
                case NSURLErrorNotConnectedToInternet:
                    errorDesc = @"网络连接断开";
                    break;
                default:
                    retFeedData.code = WXT_URLFeedData_UndefinedError;
                    break;
            }
            [retFeedData setErrorDesc:errorDesc];
        }else{
            if (jsonData){
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                if (jsonDic){
//                    NSInteger code = [[jsonDic objectForKey:K_URLFeedOBJ_Data_Code] integerValue];
                    NSInteger result = [[jsonDic objectForKey:@"success"] integerValue];
                    if (result != 1){
                        retFeedData.code = result;
                        retFeedData.errorDesc = [jsonDic objectForKey:K_URLFeedOBJ_Data_ErrorDesc];
                    }else{
//                        retFeedData.data = [jsonDic objectForKey:@"data"];
                        retFeedData.data = jsonDic;
                    }
                }else{
                    retFeedData.code = WXT_URLFeedData_ParseError;
                    //					retFeedData.errorDesc = @"数据解析失败";
                }
            }else{
                retFeedData.code = WXT_URLFeedData_EmptyDataReturned;
                retFeedData.errorDesc = @"返回数据为空";
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(retFeedData);
        });
    });
}

@end
