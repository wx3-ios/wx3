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
    NSString *rootURL = [NSString stringWithFormat:@"https://api.67call.com/agent/call_api.php"];   //通话模块
    NSString *newRootUrl = [NSString stringWithFormat:@"https://oldyun.67call.com/wx3api"];   //商城模块
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
            url = @"/app_login.php";
            break;
        case WXT_UrlFeed_Type_Regist:
            url = @"/app_register.php";
            break;
        case WXT_UrlFeed_Type_FetchPwd:
            url = @"";
            break;
        case WXT_UrlFeed_Type_GainNum:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Version:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Call:
            url = @"";
            break;
        case WXT_UrlFeed_Type_HungUp:
            url = @"";
            break;
        case WXT_UrlFeed_Type_ResetPwd:
            url = @"";
            break;
        case WXT_UrlFeed_Type_NewMall_TopImg:
            url = @"/get_top_image.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Recommond:
            url = @"/get_commend_goods.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Nav:
            url = @"/get_navigation.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Theme:
            url = @"/get_theme_list.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Surprise:
            url = @"/get_surprise_goods.php";
            break;
        case WXT_UrlFeed_Type_NewMall_CatagaryList:
            url = @"";
            break;
        case WXT_UrlFeed_Type_NewMall_GoodsInfo:
            url = @"/get_single_goods_info.php";
            break;
        case WXT_UrlFeed_Type_NewMall_ImgAndText:
            url = @"";
            break;
        case WXT_UrlFeed_Type_NewMall_ShoppingCart:
            url = @"/get_shopping_cart.php";
            break;
        case WXT_UrlFeed_Type_NewMall_UserAddress:
            url = @"/get_user_address.php";
            break;
        case WXT_UrlFeed_Type_NewMall_MakeOrder:
            url = @"/insert_order.php";
            break;
        default:
            break;
    }
    NSString *compURL = [NSString stringWithFormat:@"%@%@",rootURL,url];
    if(![url isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@%@",newRootUrl,url];
    }
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
