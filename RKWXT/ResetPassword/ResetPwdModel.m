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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", newPwd, @"newpwd", userObj.pwd, @"oldpwd", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_ResetPwd httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(resetPwdFailed:)]){
                [_delegate resetPwdFailed:retData.errorDesc];
            }
        }else{
            [userObj setPwd:newPwd];
            if (_delegate && [_delegate respondsToSelector:@selector(resetPwdSucceed)]){
                [_delegate resetPwdSucceed];
            }
        }
    }];
}

@end
