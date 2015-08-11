//
//  RechargeListModel.m
//  RKWXT
//
//  Created by SHB on 15/8/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeListModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation RechargeListModel

-(void)rechargeListWithMoney:(NSInteger)money{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userDefault.sellerID, @"seller_user_id", @"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInteger:[UtilTool timeChange]], @"ts", [NSNumber numberWithInteger:money], @"total_fee", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_RechargeList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(rechargeListFailed:)]){
                [_delegate rechargeListFailed:retData.errorDesc];
            }
        }else{
            _orderID = [[retData.data objectForKey:@"data"] objectForKey:@"order_id"];
            if (_delegate && [_delegate respondsToSelector:@selector(rechargeListSucceed)]){
                [_delegate rechargeListSucceed];
            }
        }
    }];
}

@end
