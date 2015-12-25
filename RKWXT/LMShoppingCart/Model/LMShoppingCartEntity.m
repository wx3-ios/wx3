//
//  LMShoppingCartEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartEntity.h"

@implementation LMShoppingCartEntity

+(LMShoppingCartEntity*)initLMShoppCartEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger cartID = [[dic objectForKey:@"cart_id"] integerValue];
        [self setCartID:cartID];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
        
        NSString *img = [dic objectForKey:@"goods_img"];
        [self setImgUrl:img];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
        NSInteger buyNUm = [[dic objectForKey:@"goods_number"] integerValue];
        [self setBuyNumber:buyNUm];
        
        CGFloat price = [[dic objectForKey:@"goods_price"] floatValue];
        [self setGoodsPrice:price];
        
        NSInteger stockID = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStockID:stockID];
        
        NSString *stockname = [dic objectForKey:@"goods_stock_name"];
        [self setStockName:stockname];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSString *shopName = [dic objectForKey:@"shop_name"];
        [self setShopName:shopName];
        
        NSInteger stockNum = [[dic objectForKey:@"stock_number"] integerValue];
        [self setStockNumber:stockNum];
        
        NSString *shopImg = [dic objectForKey:@"shop_home_img"];
        [self setShopImg:shopImg];
    }
    return self;
}

@end
