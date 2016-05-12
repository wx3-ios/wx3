//
//  ShopActivityModel.m
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ShopActivityModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "WXTURLFeedOBJ.h"
#import "ShopActivityEntity.h"

@implementation ShopActivityModel
+ (instancetype)shareShopActivity{
    static ShopActivityModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ShopActivityModel alloc]init];
    });
    return model;
}

/*
 接口名称：获取店铺的活动
 接口地址：https://oldyun.67call.com/wx3api/get_shop_action.php
 请求方式：POST
 输入参数:
 公共参数:
 pid:平台类型(android,ios),
 ver:版本号,
 ts:时间戳,
 woxin_id:我信ID
 shop_id : 店铺ID
 返回数据格式:json
 成功返回: error :0  data:数据
 失败返回:error :1  msg:错误信息
 
 
 
 full_reduce      	#满减  格式 80:20   满80减20
 isshop_postage      #满多少包邮
 action_type  		#0.没有活动 1.满多少包邮  2.满减
 */

- (void)loadShopActivity{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"pid"] = @"ios";
    dic[@"ver"] = [UtilTool currentVersion];
    dic[@"ts"] = [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"] = userObj.wxtID;
    dic[@"shop_id"] = [NSNumber numberWithInt:(int)kSubShopID];
    __block ShopActivityEntity *entity = [ShopActivityEntity shareShopActionEntity];
    NSLog(@"%@",dic);
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ShopAction httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
         
        }else{
            entity = [ShopActivityEntity shopActivityEntityWithDic:retData.data[@"data"]];
        }
    }];
}

@end
