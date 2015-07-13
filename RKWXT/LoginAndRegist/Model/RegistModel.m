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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userStr, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:pwdStr],@"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", recommondUserStr, @"referrer", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)code], @"rcode", [NSNumber numberWithInt:(int)smsID], @"rand_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Regist httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(registFailed:)]){
                [_delegate registFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(registSucceed)]){
                [_delegate registSucceed];
            }
        }
    }];
}

@end
