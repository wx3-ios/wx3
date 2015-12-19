//
//  LMDataCollectionModel.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMDataCollectionModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation LMDataCollectionModel

-(void)lmCollectionData:(NSInteger)shop_id goods:(NSInteger)goods_id type:(LMCollection_Type)lmCollectionType dataType:(CollectionData_Type)collectionDataType{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:shop_id], @"shop_id", [NSNumber numberWithInteger:goods_id], @"goods_id", [NSNumber numberWithInt:lmCollectionType], @"dtype", [NSNumber numberWithInt:collectionDataType], @"otype", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMCollection httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code == 0){
            if(lmCollectionType == LMCollection_Type_Goods && collectionDataType == CollectionData_Type_Add){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsAddCollectionSucceed object:nil];
            }
            if(lmCollectionType == LMCollection_Type_Goods && collectionDataType == CollectionData_Type_Deleate){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_GoodsCancelCollectionSucceed object:nil];
            }
            if(lmCollectionType == LMCollection_Type_Shop && collectionDataType == CollectionData_Type_Add){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_ShopAddCollectionSucceed object:nil];
            }
            if(lmCollectionType == LMCollection_Type_Shop && collectionDataType == CollectionData_Type_Deleate){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_ShopCancelCollectionSucceed object:nil];
            }
        }
    }];
}

@end
