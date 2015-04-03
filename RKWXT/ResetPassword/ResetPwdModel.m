//
//  ResetPwdModel.m
//  RKWXT
//
//  Created by SHB on 15/3/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ResetPwdModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation ResetPwdModel

-(void)resetPwdWithNewPwd:(NSString *)newPwd{
    if(!newPwd){
        return;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"change_password", @"cmd", userObj.pwd, @"old_password",userObj.wxtID, @"user_id", newPwd,@"new_password",[NSNumber numberWithInt:(int)kMerchantID], @"agent_id", userObj.token, @"token", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_ResetPwd httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        NSInteger secceed = [[dic objectForKey:@"success"] integerValue];
        if (secceed != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(resetPwdFailed:)]){
                [_delegate resetPwdFailed:retData.errorDesc];
            }
        }else{
            [userObj setPwd:newPwd];
            [userObj setToken:[dic objectForKey:@"new_token"]];
            if (_delegate && [_delegate respondsToSelector:@selector(resetPwdSucceed)]){
                [_delegate resetPwdSucceed];
            }
        }
    }];
}

@end
