//
//  GoodsAttentionModel.h
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_Notification_Name_SearchGoodsAttentionSucceed @"K_Notification_Name_SearchGoodsAttentionSucceed"
#define K_Notification_Name_GoodsPayAttentionSucceed    @"K_Notification_Name_GoodsPayAttentionSucceed"
#define K_Notification_Name_GoodsPayAttentionFailed     @"K_Notification_Name_GoodsPayAttentionSucceed"
#define K_Notification_Name_GoodsCancelAttentionSucceed @"K_Notification_Name_GoodsCancelAttentionSucceed"
#define K_Notification_Name_GoodsCancelAttentionFailed  @"K_Notification_Name_GoodsCancelAttentionFailed"

@interface GoodsAttentionModel : NSObject

//查看该商品是否已经收藏
-(void)searchGoodsPayAttention:(NSInteger)goodsID limitID:(NSInteger)limitID;
//收藏商品
-(void)goodsPayAttention:(NSInteger)goodsID and:(NSInteger)stockID andLimitID:(NSInteger)limitID;
//取消收藏
-(void)cancelGoodsAttention:(NSInteger)goodsID limitID:(NSInteger)limitID;

@end
