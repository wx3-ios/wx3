//
//  LuckySharkEntity.m
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckySharkEntity.h"

@implementation LuckySharkEntity

+(LuckySharkEntity*)initWidthLuckySharkEntityWidthDic:(NSDictionary *)dic{
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
        [self setStockName:name];
        
        CGFloat shopPrice = [[dic objectForKey:@"shop_price"] floatValue];
        [self setShop_price:shopPrice];
        
        CGFloat market_price = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarket_price:market_price];
        
        CGFloat goodsPrice = [[dic objectForKey:@"goods_price"] floatValue];
        [self setGoods_price:goodsPrice];
        
        NSInteger goods_id = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goods_id];
        
        NSInteger stockID = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStock_id:stockID];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShop_id:shopID];
        
        NSInteger lott = [[dic objectForKey:@"lottery_id"] integerValue];
        [self setLottery_id:lott];
    }
    return self;
}

@end
