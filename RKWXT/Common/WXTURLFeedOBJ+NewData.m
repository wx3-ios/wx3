//
//  WXTURLFeedOBJ+NewData.m
//  RKWXT
//
//  Created by SHB on 15/6/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ+NewData.h"

#define D_DataURLConnectionDefaultTimeoutInterval (15.0)
//#define newUrlString @"http://oldyun.67call.com/wx3api/app_register.php"

@implementation WXTURLFeedOBJ (NewData)

- (void)fetchNewDataFromFeedType:(WXT_UrlFeed_Type)type httpMethod:(WXT_HttpMethod)httpMethod timeoutIntervcal:(CGFloat)timeoutInterval feed:(NSDictionary *)feed completion:(void (^)(URLFeedData *))completion{
    NSString *urlString = [self rootURL:type];
    NSString *paramString = [self urlRequestParamFrom:feed];
//    if (paramString){
//        urlString = [NSString stringWithFormat:@"%@?%@",urlString,paramString];
//    }
    
//    if(httpMethod == WXT_HttpMethod_Post){
//        urlString = newUrlString;
//    }
    
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
        NSData *requestData = [[paramString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestData;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block URLFeedData *retFeedData = [[URLFeedData alloc] init];
        NSError *error = nil;
        
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSString *str1 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
                    NSInteger result = [[jsonDic objectForKey:@"error"] integerValue];
                    if (result != 0){
                        retFeedData.code = result;
                        retFeedData.errorDesc = [jsonDic objectForKey:K_URLFeedOBJ_Data_ErrorDesc];
                    }else{
                        retFeedData.data = jsonDic;
                    }
                }else{
                    retFeedData.code = WXT_URLFeedData_ParseError;
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
