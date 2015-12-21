//
//  LMDataCollectionModel.h
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_Notification_Name_GoodsAddCollectionSucceed @"K_Notification_Name_GoodsAddCollectionSucceed"  //联盟商品添加收藏成功
#define K_Notification_Name_GoodsCancelCollectionSucceed @"K_Notification_Name_GoodsCancelCollectionSucceed"  //取消收藏
#define K_Notification_Name_ShopAddCollectionSucceed @"K_Notification_Name_ShopAddCollectionSucceed"  //店铺收藏成功
#define K_Notification_Name_ShopCancelCollectionSucceed @"K_Notification_Name_ShopCancelCollectionSucceed" //店铺取消收藏

#define K_Notification_Name_LoadGoodsCollectionListSucceed @"K_Notification_Name_LoadGoodsCollectionListSucceed"  //获取收藏商品列表
#define K_Notification_Name_LoadGoodsCollectionListFailed @"K_Notification_Name_LoadGoodsCollectionListFailed"  //获取收藏商品失败
#define K_Notification_Name_LoadShopCollectionListSucceed @"K_Notification_Name_LoadShopCollectionListSucceed"  //获取收藏店铺列表
#define K_Notification_Name_LoadShopCollectionListFailed @"K_Notification_Name_LoadShopCollectionListFailed"  //获取收藏店铺失败

//商家联盟商品收藏临时存储变量
#define LMGoodsCollectionDataChange @"LMGoodsCollectionDataChange"
#define LMShopCollectionDataChange @"LMShopCollectionDataChange"

typedef enum{
    LMCollection_Type_Goods = 1,  //商品  dtype
    LMCollection_Type_Shop,     //店铺
}LMCollection_Type;

typedef enum{
    CollectionData_Type_Add = 1,  //增加
    CollectionData_Type_Search,   //查询
    CollectionData_Type_Deleate,  //删除
}CollectionData_Type;

@interface LMDataCollectionModel : NSObject
@property (nonatomic,assign) LMCollection_Type lmCollectionType;
@property (nonatomic,assign) CollectionData_Type collectionDataType;

@property (nonatomic,strong) NSArray *goodsCollectionArr;
@property (nonatomic,strong) NSArray *shopCollectionArr;

//商品、店铺收藏和删除   店铺收藏和删除goodsId为0
-(void)lmCollectionData:(NSInteger)shop_id goods:(NSInteger)goods_id type:(LMCollection_Type)lmCollectionType dataType:(CollectionData_Type)collectionDataType;

@end
