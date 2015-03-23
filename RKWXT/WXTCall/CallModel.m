//
//  CallModel.m
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CallModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation CallModel

-(void)makeCallPhone:(NSString *)phoneStr{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"call", @"cmd", userDefault.wxtID, @"user_id", [NSNumber numberWithInt:ShopID], @"agent_id", phoneStr, @"called", userDefault.token, @"token", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_FetchPwd httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_callDelegate && [_callDelegate respondsToSelector:@selector(makeCallPhoneFailed:)]){
                [_callDelegate makeCallPhoneFailed:retData.errorDesc];
            }
        }else{
            if (_callDelegate && [_callDelegate respondsToSelector:@selector(makeCallPhoneSucceed)]){
                [_callDelegate makeCallPhoneSucceed];
            }
        }
    }];
}

@end
