//
//  FetchPwdModel.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "FetchPwdModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation FetchPwdModel

-(void)fetchPwdWithUserPhone:(NSString *)phone{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"forget_password", @"cmd", phone, @"phone_number", [NSNumber numberWithInt:(int)kMerchantID], @"agent_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Login httpMethod:WXT_HttpMethod_Get timeoutIntervcal:40 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(fetchPwdFailed:)]){
                [_delegate fetchPwdFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(fetchPwdSucceed)]){
                [_delegate fetchPwdSucceed];
            }
        }
    }];
}

@end
