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
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pay", @"cmd", userDefault.wxtID, @"user_id", [NSNumber numberWithInt:ShopID], @"agent_id", num, @"card_sn", pwd, @"card_ps", userDefault.user, @"phone_number", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_Recharge httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
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
