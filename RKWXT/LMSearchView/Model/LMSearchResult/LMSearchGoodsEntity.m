//
//  LMSearchGoodsEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchGoodsEntity.h"

@implementation LMSearchGoodsEntity

+(LMSearchGoodsEntity*)initLMSearchGoodsEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *homeImg = [dic objectForKey:@"goods_home_img"];
        [self setGoodsImg:homeImg];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
        CGFloat marketPrice = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarketPrice:marketPrice];
        
        CGFloat shopPrice = [[dic objectForKey:@"shop_price"] floatValue];
        [self setShopPrice: shopPrice];
    }
    return self;
}

@end
