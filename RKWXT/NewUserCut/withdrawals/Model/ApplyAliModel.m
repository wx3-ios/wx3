//
//  ApplyAliModel.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ApplyAliModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ApplyAliModel

-(void)applyAliMoney:(CGFloat)money{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithFloat:(float)money], @"amount", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ApplyAliMoney httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(applyAliMoneyFailed:)]){
                [_delegate applyAliMoneyFailed:retData.errorDesc];
            }
        }else{
            if([_delegate respondsToSelector:@selector(applyAliMoneySucceed)]){
                [_delegate applyAliMoneySucceed];
            }
        }
    }];
}

@end
