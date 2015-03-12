//
//  RechargeModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"

@implementation RechargeModel

-(void)rechargeWithCardNum:(NSString *)num andPwd:(NSString *)pwd{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pay", @"cmd", @"1003227", @"user_id", [NSNumber numberWithInt:2], @"agent_id", num, @"card_sn", pwd, @"card_ps", @"18613213051", @"phone_number", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Recharge httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(rechargeFailed:)]){
                [_delegate rechargeFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(rechargeSucceed)]){
                [_delegate rechargeSucceed];
            }
        }
    }];
}

@end
