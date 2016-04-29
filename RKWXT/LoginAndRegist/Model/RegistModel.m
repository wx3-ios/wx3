//
//  RegistModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RegistModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation RegistModel

-(void)registWithUserPhone:(NSString *)userStr andPwd:(NSString *)pwdStr andSmsID:(NSInteger)smsID andCode:(NSInteger)code andRecommondUser:(NSString *)recommondUserStr{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userStr, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", recommondUserStr, @"referrer", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)code], @"rcode", [NSNumber numberWithInt:(int)smsID], @"rand_id", nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pid"] = @"ios";
    dict[@"phone"] = userStr;
    dict[@"pwd"] = [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr];
    dict[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dict[@"ver"] = [UtilTool currentVersion];
//    dict[@"referrer"] = recommondUserStr;
    dict[@"sid"] = [NSNumber numberWithInt:(int)kMerchantID];
    dict[@"rcode"] = [NSNumber numberWithInt:(int)code];
    dict[@"rand_id"] = [NSNumber numberWithInt:(int)smsID];

    
    NSLog(@"%@",dict);
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Regist httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dict completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(registFailed:)]){
                [_delegate registFailed:retData.errorDesc];
            }
        }else{
            WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
            [userObj setUser:userStr];
            if (_delegate && [_delegate respondsToSelector:@selector(registSucceed)]){
                [_delegate registSucceed];
            }
        }
    }];
}

@end
