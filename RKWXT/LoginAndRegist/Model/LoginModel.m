//
//  LoginModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation LoginModel

-(void)loginWithUser:(NSString *)userStr andPwd:(NSString *)pwdStr{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"login", @"cmd", userStr, @"phone_number", [NSNumber numberWithInt:2], @"agent_id", pwdStr, @"password", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Login httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(loginFailed:)]){
                [_delegate loginFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(loginSucceed)]){
                [_delegate loginSucceed];
            }
        }
    }];
}

@end
