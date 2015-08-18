//
//  LuckyGoodsEntity.m
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsEntity.h"

@implementation LuckyGoodsEntity

+(LuckyGoodsEntity*)initLuckyGoodsWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *imgUrl = [dic objectForKey:@"goods_home_img"];
        [self setImgUrl:imgUrl];
        
        NSString *name = [dic objectForKey:@"goods_name"];
        [self setName:name];
        
        CGFloat price = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarket_price:price];
        
        CGFloat price1 = [[dic objectForKey:@"shop_price"] floatValue];
        [self setShop_price:price1];
        
        NSInteger goods_id = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goods_id];
    }
    return self;
}

@end
