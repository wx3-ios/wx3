//
//  LMDataCollectionModel.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMDataCollectionModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMShopCollectionEntity.h"
#import "LMGoodsCollectionEntity.h"

@interface LMDataCollectionModel(){
    NSMutableArray *_goodsCollectionArr;
    NSMutableArray *_shopCollectionArr;
}
@end

@implementation LMDataCollectionModel
@synthesize shopCollectionArr = _shopCollectionArr;
@synthesize goodsCollectionArr = _goodsCollectionArr;

-(id)init{
    self = [super init];
    if(self){
        _shopCollectionArr = [[NSMutableArray alloc] init];
        _goodsCollectionArr = [[NSMutableArray alloc] init];
    }
    return self;
}

// 店铺收藏
-(void)parseShopCollectionData:(NSArray*)arr{
    if([arr count] == 0){
        [_shopCollectionArr removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadShopCollectionListSucceed object:nil];
        return;
    }
    [_shopCollectionArr removeAllObjects];
    for(NSDictionary *dic in arr){
        LMShopCollectionEntity *entity = [LMShopCollectionEntity initShopCollectionData:dic];
        entity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.homeImg];
        [_shopCollectionArr addObject:entity];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadShopCollectionListSucceed object:nil];
}

//商品收藏
-(void)parseGoodsCollectionData:(NSArray*)arr{
    if([arr count] == 0){
        [_goodsCollectionArr removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadGoodsCollectionListSucceed object:nil];
        return;
    }
    [_goodsCollectionArr removeAllObjects];
    for(NSDictionary *dic in arr){
        LMGoodsCollectionEntity *entity = [LMGoodsCollectionEntity initGoodsCollectionEntity:dic];
        entity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.homeImg];
        [_goodsCollectionArr addObject:entity];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadGoodsCollectionListSucceed object:nil];
}

-(void)lmCollectionData:(NSInteger)shop_id goods:(NSInteger)goods_id type:(LMCollection_Type)lmCollectionType dataType:(CollectionData_Type)collectionDataType{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:shop_id], @"shop_id", [NSNumber numberWithInteger:goods_id], @"goods_id", [NSNumber numberWithInt:lmCollectionType], @"dtype", [NSNumber numberWithInt:collectionDataType], @"otype", nil];
    __block LMDataCollectionModel *blockSelf = self;
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
            
            //解析收藏店铺数据
            if(lmCollectionType == LMCollection_Type_Shop && collectionDataType == CollectionData_Type_Search){
                [blockSelf parseShopCollectionData:[[retData.data objectForKey:@"data"] objectForKey:@"shop"]];
            }
            
            //解析收藏商品数据
            if(lmCollectionType == LMCollection_Type_Goods && collectionDataType == CollectionData_Type_Search){
                [blockSelf parseGoodsCollectionData:[[retData.data objectForKey:@"data"] objectForKey:@"goods"]];
            }
        }else{
            //获取收藏店铺信息失败
            if(lmCollectionType == LMCollection_Type_Shop && collectionDataType == CollectionData_Type_Search){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadShopCollectionListFailed object:nil];
            }
            
            //获取收藏商品信息失败
            if(lmCollectionType == LMCollection_Type_Goods && collectionDataType == CollectionData_Type_Search){
                [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadGoodsCollectionListFailed object:nil];
            }
        }
    }];
}

@end
