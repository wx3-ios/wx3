//
//  RegistModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RegistModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation RegistModel

-(void)registWithUserPhone:(NSString *)userStr andPwd:(NSString *)pwdStr andSmsID:(NSInteger)smsID andCode:(NSInteger)code andRecommondUser:(NSString *)recommondUserStr{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"register", @"cmd", userStr, @"phone_number", pwdStr,@"password", [NSNumber numberWithInteger:smsID], @"sms_id", [NSNumber numberWithInteger:code], @"sms_code", recommondUserStr, @"recommend_user", [NSNumber numberWithInt:ShopID], @"agent_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Regist httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(registFailed:)]){
                [_delegate registFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(registSucceed)]){
                [_delegate registSucceed];
            }
        }
    }];
}

@end
