//
//  ShareModel.m
//  RKWXT
//
//  Created by app on 16/4/20.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ShareModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation ShareModel
/*
 接口名称：获取商家的分享文字
 接口地址：https://oldyun.67call.com/wx3api/get_shareinfo.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 返回数据格式：json
 成功返回: error ：0  data:数据
 失败返回：error ：1  msg:错误信息
 */

+ (void)shareInfoWith:(void(^)(NSString *share))str{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"] = @"ios";
    dic[@"ver"] = [UtilTool currentVersion];
    dic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"sid"] = [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"woxin_id"] = userObj.wxtID;
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ShareInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
           
        }else{
         str(retData.data[@"app_share_info"]);
        }
    }];
}
@end
