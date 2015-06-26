//
//  ShoppingCartEntity.m
//  RKWXT
//
//  Created by SHB on 15/6/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ShoppingCartEntity.h"

@implementation ShoppingCartEntity

+(ShoppingCartEntity*)initShoppingCartDataWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initDataWithDic:dic];
}

-(id)initDataWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger cartID = [[dic objectForKey:@"cart_id"] integerValue];
        [self setCart_id:cartID];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShop_id:shopID];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goodsID];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoods_name:goodsName];
        
        NSString *goodsImg = [dic objectForKey:@"goods_img"];
        [self setSmallImg:goodsImg];
        
        CGFloat goodsPrice = [[dic objectForKey:@"goods_price"] floatValue];
        [self setGoods_price:goodsPrice];
        
        NSInteger goodsNum = [[dic objectForKey:@"goods_number"] integerValue];
        [self setGoods_Number:goodsNum];
        
        NSInteger stockID = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStockID:stockID];
        
        NSString *stockName = [dic objectForKey:@"goods_stock_name"];
        [self setStockName:stockName];
    }
    return self;
}

@end
