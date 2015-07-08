//
//  WXTURLFeedOBJ+NewData.m
//  RKWXT
//
//  Created by SHB on 15/6/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ+NewData.h"
#import "NSObject+SBJson.h"

#define D_DataURLConnectionDefaultTimeoutInterval (15.0)

@implementation WXTURLFeedOBJ (NewData)

- (void)fetchNewDataFromFeedType:(WXT_UrlFeed_Type)type httpMethod:(WXT_HttpMethod)httpMethod timeoutIntervcal:(CGFloat)timeoutInterval feed:(NSDictionary *)feed completion:(void (^)(URLFeedData *))completion{
    NSString *urlString = [self rootURL:type];
    NSString *paramString = [self urlRequestParamFrom:feed];
    
    NSURL *url = [NSURL URLWithString:urlString];
    CGFloat timeout = D_DataURLConnectionDefaultTimeoutInterval;
    if (timeoutInterval > 0){
        timeout = timeoutInterval;
    }
    
    if(type == WXT_UrlFeed_Type_NewMall_MakeOrder){
        NSArray *firstArr = [paramString componentsSeparatedByString:@"goods="];
        NSString *firstStr = [firstArr objectAtIndex:0];
        NSArray *newArr = [feed objectForKey:@"goods"];
        NSInteger number = 0;
        for(NSDictionary *dic in newArr){
            NSString *str = [dic JSONRepresentation];
            number++;
            if([newArr count] == 1){
                firstStr = [firstStr stringByAppendingFormat:@"goods=[%@]",str];
            }else{
                if([newArr count] == number){
                    firstStr = [firstStr stringByAppendingFormat:@"%@]",str];
                }else{
                    if(number == 1){
                        firstStr = [firstStr stringByAppendingFormat:@"goods=[%@,",str];
                    }else{
                        firstStr = [firstStr stringByAppendingFormat:@"%@,",str];
                    }
                }
            }
        }
        NSArray *secondArr = [paramString componentsSeparatedByString:@")&"];
        NSString *secondStr = [secondArr objectAtIndex:[secondArr count]-1];
        firstStr = [firstStr stringByAppendingFormat:@"&%@",secondStr];
        
        //解析字符串对商品部分进行转义
        NSArray *jsonArr1 = [firstStr componentsSeparatedByString:@"goods="];
        NSString *jsonStr1 = [jsonArr1 objectAtIndex:0];  //json第一部分
        NSString *jsonStr2 = [jsonArr1 objectAtIndex:1];  //json第二部分
        NSArray *jsonArr2 = [jsonStr2 componentsSeparatedByString:@"}]"];  //对第二部分进行分割
        NSString *jsonStr3 = [jsonArr2 objectAtIndex:1];  //取最后一部分
        NSString *goodsString = [jsonArr2 objectAtIndex:0];
        goodsString = [[goodsString stringByAppendingFormat:@"}]"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        paramString = [NSString stringWithFormat:@"%@goods=%@%@",jsonStr1,goodsString,jsonStr3];
        
//        paramString = firstStr;
//        NSError *error = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:feed options:NSJSONWritingPrettyPrinted error:&error];
//        paramString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
                        NSLog(@"%@",retFeedData.errorDesc);
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
