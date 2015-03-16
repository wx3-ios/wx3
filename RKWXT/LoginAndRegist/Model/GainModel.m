//
//  GainModel.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "GainModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation GainModel

-(void)gainNumber:(NSString *)userStr{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"get_sms_auth_code", @"cmd", userStr, @"phone_number", [NSNumber numberWithInt:ShopID], @"agent_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_GainNum httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(gainNumFailed:)]){
                [_delegate gainNumFailed:retData.errorDesc];
            }
        }else{
            NSInteger smsID = [[dic objectForKey:@"sms_id"] integerValue];
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            [userDefault setSmsID:smsID];
            
            if (_delegate && [_delegate respondsToSelector:@selector(gainNumSucceed)]){
                [_delegate gainNumSucceed];
            }
        }
    }];
}

@end
