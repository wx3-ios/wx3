//
//  GoodsAttentionModel.m
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "GoodsAttentionModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation GoodsAttentionModel

//收藏
-(void)goodsPayAttention:(NSInteger)goodsID and:(NSInteger)stockID andLimitID:(NSInteger)limitID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:1], @"type", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", [NSNumber numberWithInt:goodsID], @"goods_id", [NSNumber numberWithInt:stockID], @"goods_stock_id", [NSNumber numberWithInt:limitID], @"scare_buying_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PayAttention httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsPayAttentionFailed object:retData.errorDesc];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsPayAttentionSucceed object:[NSNumber numberWithInteger:goodsID]];
        }
    }];
}

//查看是否已经收藏
-(void)searchGoodsPayAttention:(NSInteger)goodsID limitID:(NSInteger)limitID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:5], @"type", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", [NSNumber numberWithInt:goodsID], @"goods_id", [NSNumber numberWithInt:limitID], @"scare_buying_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PayAttention httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_SearchGoodsAttentionSucceed object:retData.data];
        }
    }];
}

//取消收藏
-(void)cancelGoodsAttention:(NSInteger)goodsID limitID:(NSInteger)limitID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:4], @"type", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", [NSNumber numberWithInt:goodsID], @"goods_id", [NSNumber numberWithInt:limitID], @"scare_buying_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_PayAttention httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsCancelAttentionFailed object:retData.errorDesc];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsCancelAttentionSucceed object:[NSNumber numberWithInteger:goodsID]];
        }
    }];
}

@end
