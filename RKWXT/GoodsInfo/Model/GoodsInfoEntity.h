//
//  GoodsInfoEntity.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfoEntity : NSObject
//商品基本介绍
@property (nonatomic,assign) NSInteger goods_id;      //商品id
@property (nonatomic,strong) NSString *intro;         //商品介绍
@property (nonatomic,strong) NSString *smallImg;      //商品小图
@property (nonatomic,strong) NSString *bigImg;        //顶部图片
@property (nonatomic,strong) NSArray *imgArr;         //顶部图片数组
@property (nonatomic,assign) CGFloat market_price;    //市场价
@property (nonatomic,assign) CGFloat shop_price;      //店铺价
@property (nonatomic,assign) CGFloat distribution_Price;   //分销价
@property (nonatomic,strong) NSString *meterage_name; //商家名
@property (nonatomic,assign) NSInteger concernID;     //为0则未关注

//商品行业基础属性
@property (nonatomic,strong) NSArray *customNameArr;      //通用属性数组名称
@property (nonatomic,strong) NSArray *customInfoArr;      //通用属性数组内容
@property (nonatomic,strong) NSString *customKey;     //通用参数key
@property (nonatomic,strong) NSString *customValue;   //通用参数value

//库存
@property (nonatomic,assign) NSInteger stockID;   //库存主健ID
@property (nonatomic,strong) NSString *stockName;  //库存属性组合
@property (nonatomic,assign) CGFloat stockPrice;   //组合价格
@property (nonatomic,assign) NSInteger stockNumber; //组合库存数量
@property (nonatomic,assign) NSInteger stockBonus; //商品可用红包
@property (nonatomic,assign) CGFloat userCut;      //商品分成多少

@property (nonatomic,assign) BOOL selested;
@property (nonatomic,assign) BOOL use_red;
@property (nonatomic,assign) BOOL use_cut;
@property (nonatomic,assign) NSInteger buyNumber;

+(GoodsInfoEntity*)goodsInfoEntityWithBaseDic:(NSDictionary*)baseDic withStockDic:(NSDictionary*)stockDic;

@end