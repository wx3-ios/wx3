//
//  LoginModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LoginModel

-(void)loginWithUser:(NSString *)userStr andPwd:(NSString *)pwdStr{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userStr, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Login httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"error"] integerValue] != 0){
            [NOTIFY_CENTER postNotificationName:KNotification_LoginFailed object:retData.errorDesc];
            if (_delegate && [_delegate respondsToSelector:@selector(loginFailed:)]){
                [_delegate loginFailed:retData.errorDesc];
            }
        }else{
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            //            [userDefault setToken:[dic objectForKey:@"token"]];
            [userDefault setWxtID:[dic objectForKey:@"woxin_id"]];
            [NOTIFY_CENTER postNotificationName:KNotification_LoginSucceed object:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(loginSucceed)]){
                [_delegate loginSucceed];
            }
        }
    }];
}

@end
