//
//  ConfirmUserAliModel.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ConfirmUserAliModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ConfirmUserAliModel

-(void)confirmUserAliAcountWith:(NSString *)userAliAcount with:(NSString *)userName with:(UserAli_Submit)aliType with:(NSInteger)rcode with:(NSString *)userPhone{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userAliAcount, @"account", userName, @"username", [NSNumber numberWithInt:(int)aliType], @"type", [NSNumber numberWithInt:(int)rcode], @"rcode", [NSNumber numberWithInt:(int)userObj.smsID], @"rand_id", userPhone, @"phone", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SubmitUserAliAcount httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(confirmUserAliAcountFailed:)]){
                [_delegate confirmUserAliAcountFailed:retData.errorDesc];
            }
        }else{
            if([_delegate respondsToSelector:@selector(confirmUserAliAcountSucceed)]){
                [_delegate confirmUserAliAcountSucceed];
            }
        }
    }];
}

@end
