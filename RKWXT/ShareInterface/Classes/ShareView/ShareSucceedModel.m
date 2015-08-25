//
//  ShareSucceedModel.m
//  RKWXT
//
//  Created by SHB on 15/8/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ShareSucceedModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ShareSucceedModel

+(ShareSucceedModel*)sharedSucceed{
    static dispatch_once_t onceToken;
    static ShareSucceedModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[ShareSucceedModel alloc] init];
    });
    return sharedInstance;
}

-(void)sharedSucceed{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInteger:[UtilTool timeChange]], @"ts", [NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:4], @"type", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_SharedSucceed httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            KFLog_Normal(YES, @"分享成功");
        }else{
            KFLog_Normal(YES, @"分享失败");
        }
    }];
}

@end
