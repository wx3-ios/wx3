//
//  ResetNewPwdModel.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ResetNewPwdModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation ResetNewPwdModel

-(void)resetNewPwdWithUserPhone:(NSString *)phone withCode:(NSInteger)code withNewPwd:(NSString *)newPwd{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", phone, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", newPwd, @"newpwd", [NSNumber numberWithInt:(int)code], @"rcode", [NSNumber numberWithInt:(int)userObj.smsID], @"rand_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_New_ResetNewPwd httpMethod:WXT_HttpMethod_Post timeoutIntervcal:40 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(resetNewPwdFailed:)]){
                [_delegate resetNewPwdFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(resetNewPwdSucceed)]){
                [_delegate resetNewPwdSucceed];
            }
        }
    }];
}

@end