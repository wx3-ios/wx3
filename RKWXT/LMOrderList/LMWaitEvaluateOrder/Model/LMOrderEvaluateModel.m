//
//  LMOrderEvaluateModel.m
//  RKWXT
//
//  Created by SHB on 15/12/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderEvaluateModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LMOrderEvaluateModel

-(void)userEvaluateOrder:(NSInteger)orderID andInfo:(NSString *)content type:(OrderEvaluate_Type)type{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:orderID], @"order_id", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", content, @"evaluate", [NSNumber numberWithInt:type], @"type", nil];
//    __block LMOrderEvaluateModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_OrderEvaluate httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(lmOrderEvaluateFailed:)]){
                [_delegate lmOrderEvaluateFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(lmOrderEvaluateSucceed)]){
                [_delegate lmOrderEvaluateSucceed];
            }
        }
    }];
}

@end
