//
//  GoodsInfoEntity.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "GoodsInfoEntity.h"

@implementation GoodsInfoEntity

-(id)init{
    self = [super init];
    if(self){
        _selested = NO;
    }
    return self;
}

+(GoodsInfoEntity*)goodsInfoEntityWithBaseDic:(NSDictionary *)baseDic withStockDic:(NSDictionary *)stockDic{
    if(!baseDic || !stockDic){
        return nil;
    }
    return [[self alloc] initWithBaseDic:baseDic withStockDic:stockDic];
}

//{"error":0,"data":{"stock":[{"goods_stock_id":"1","goods_id":"1","goods_stock_name":"ddqw","goods_number":"11","goods_price":"11.00"},{"goods_stock_id":"2","goods_id":"1","goods_stock_name":"gre","goods_number":"22","goods_price":"22.00"}],

//"attr":[{"goods_id":"1","attr_name":"\u5c4f\u5e55\u5c3a\u5bf8","attr_value":"4.5\u5bf8"},{"goods_id":"1","attr_name":"\u7f51\u7edc\u5236\u5f0f","attr_value":"\u7535\u4fe1"},{"goods_id":"1","attr_name":"CPU","attr_value":"8\u6838"},{"goods_id":"1","attr_name":"\u5916\u89c2\u6837\u5f0f","attr_value":"\u7ffb\u76d6\u624b\u673a|\u6ed1\u76d6\u624b\u673a"},{"goods_id":"1","attr_name":"\u673a\u8eab\u5b58\u50a8","attr_value":"fewfew"},{"goods_id":"1","attr_name":"\u5c4f\u5e55\u5206\u8fa8\u7387","attr_value":"200*200"}],"goods":


//{"goods_id":"1","goods_name":"few","goods_home_img":"20150612\/20150612181522_873261.jpeg","goods_icarousel_img":"20150612\/20150612181531_279195.jpeg,","meterage_name":"\u4e2a","shop_price":"11.00","market_price":"11.00"}}}

-(id)initWithBaseDic:(NSDictionary*)baseDic withStockDic:(NSDictionary*)stockDic{
    if(self = [super init]){
        NSInteger goodsID = [[baseDic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goodsID];
        
        NSString *name = [baseDic objectForKey:@"goods_name"];
        [self setIntro:name];
        
        NSString *urlStr = [baseDic objectForKey:@"goods_icarousel_img"];  //存在多张图片，需要自行分割
        [self setBigImg:urlStr];
        
        NSString *smallImg = [baseDic objectForKey:@"goods_home_img"];
        [self setSmallImg:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,smallImg]];
        
        NSString *meterageName = [baseDic objectForKey:@"meterage_name"];
        [self setMeterage_name:meterageName];
        
        CGFloat shopPrice = [[baseDic objectForKey:@"shop_price"] floatValue];
        [self setShop_price:shopPrice];
        
        CGFloat marketPrice = [[baseDic objectForKey:@"market_price"] floatValue];
        [self setMarket_price:marketPrice];
        
        //库存
        NSInteger stockID = [[stockDic objectForKey:@"goods_stock_id"] integerValue];
        [self setStockID:stockID];
        
        NSString *stockName = [stockDic objectForKey:@"goods_stock_name"];
        [self setStockName:stockName];
        
        CGFloat stockPrice = [[stockDic objectForKey:@"goods_price"] floatValue];
        [self setStockPrice:stockPrice];
        
        NSInteger stockNum = [[stockDic objectForKey:@"goods_number"] integerValue];
        [self setStockNumber:stockNum];
    }
    return self;
}

@end