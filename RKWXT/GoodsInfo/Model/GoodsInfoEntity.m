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
        
        NSInteger postage = [[baseDic objectForKey:@"is_postage"] integerValue];
        [self setPostage:postage];
        
        //库存
        NSInteger stockID = [[stockDic objectForKey:@"goods_stock_id"] integerValue];
        [self setStockID:stockID];
        
        NSString *stockName = [stockDic objectForKey:@"goods_stock_name"];
        [self setStockName:stockName];
        
        CGFloat stockPrice = [[stockDic objectForKey:@"goods_price"] floatValue];
        [self setStockPrice:stockPrice];
        
        NSInteger stockNum = [[stockDic objectForKey:@"goods_number"] integerValue];
        [self setStockNumber:stockNum];
        
        NSInteger stockBonus = [[stockDic objectForKey:@"is_use_red"] integerValue];
        [self setStockBonus:stockBonus];
        if(stockBonus > 0){
            [self setUse_red:YES];
        }
        
        CGFloat divide = [[stockDic objectForKey:@"divide"] floatValue];
        [self setUserCut:divide];
        if(divide > 0){
            [self setUse_cut:YES];
        }
    }
    return self;
}

@end