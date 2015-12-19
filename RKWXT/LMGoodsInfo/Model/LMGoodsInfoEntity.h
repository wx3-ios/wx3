//
//  LMGoodsInfoEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LMGoods_Postage_Have = 0,   //不包邮
    LMGoods_Postage_None,       //包邮
}LMGoods_Postage;

typedef enum{
    LMGoods_Collection_None = 0,  //未收藏
    LMGoods_Collection_Has,
}LMGoods_Collection;

@interface LMGoodsInfoEntity : NSObject
@property (nonatomic,strong) NSString *homeImg;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSArray *goodsImgArr;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) LMGoods_Postage postage;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) NSInteger meterageID;
@property (nonatomic,strong) NSString *meterageName;
@property (nonatomic,assign) NSInteger goodshop_id;
@property (nonatomic,assign) LMGoods_Collection collectionType;

@property (nonatomic,strong) NSString *sellerAddress;
@property (nonatomic,assign) CGFloat sellerLatitude;
@property (nonatomic,assign) CGFloat sellerLongitude;
@property (nonatomic,assign) NSInteger sellerID;
@property (nonatomic,strong) NSString *sellerName;

//基本参数
@property (nonatomic,strong) NSString *attrName;
@property (nonatomic,strong) NSString *attrValue;

//评价
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userHeadImg;

//相关店铺
@property (nonatomic,strong) NSString *shopAddress;
@property (nonatomic,assign) CGFloat shopLatitude;
@property (nonatomic,assign) CGFloat shopLongitude;
@property (nonatomic,assign) CGFloat shopDistance;
@property (nonatomic,assign) CGFloat shopID;
@property (nonatomic,strong) NSString *shopName;

//库存
@property (nonatomic,assign) NSInteger userCut;
@property (nonatomic,assign) NSInteger stockNum;
@property (nonatomic,assign) CGFloat stockPrice;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;

//临时属性
@property (nonatomic,assign) BOOL selected;

+(LMGoodsInfoEntity*)initGoodsInfoEntity:(NSDictionary*)dic;  //商品详情
+(LMGoodsInfoEntity*)initSellerInfoEntity:(NSDictionary*)dic;  //所属商家
+(LMGoodsInfoEntity*)initBaseAttrDataEntity:(NSDictionary*)dic;//基础属性
+(LMGoodsInfoEntity*)initEvaluteDataEntity:(NSDictionary*)dic;  //评价
+(LMGoodsInfoEntity*)initOtherShopEntity:(NSDictionary*)dic;  //推荐商家
+(LMGoodsInfoEntity*)initStockDataEntity:(NSDictionary*)dic; //库存

@end
