//
//  LMShopInfoEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShopInfoEntity : NSObject
//推荐商品
@property (nonatomic,strong) NSString *com_goodsImg;
@property (nonatomic,assign) NSInteger com_goodsID;
@property (nonatomic,strong) NSString *com_goodsName;
@property (nonatomic,assign) CGFloat com_marketPrice;
@property (nonatomic,assign) CGFloat com_shopPrice;

//所有商品
@property (nonatomic,strong) NSString *all_goodsImg;
@property (nonatomic,assign) NSInteger all_goodsID;
@property (nonatomic,strong) NSString *all_goodsName;
@property (nonatomic,assign) CGFloat all_marketPrice;
@property (nonatomic,assign) CGFloat all_shopPrice;

//店铺信息
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) NSInteger allGoodsNum;  //所有商品
@property (nonatomic,assign) NSInteger activeNum;    //店铺活动
@property (nonatomic,assign) NSInteger comGoodsNum;   //推荐商品
@property (nonatomic,assign) NSInteger proGoodsNum;   //促销商品
@property (nonatomic,strong) NSString *topImg;
@property (nonatomic,strong) NSString *homeImg; 
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *shopPhone;
@property (nonatomic,assign) NSInteger collection;  // 收藏

+(LMShopInfoEntity*)initAllGoodsEntity:(NSDictionary*)dic;
+(LMShopInfoEntity*)initComGoodsEntity:(NSDictionary*)dic;
+(LMShopInfoEntity*)initShopInfoEntity:(NSDictionary*)dic;
 
@end
