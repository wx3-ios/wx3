//
//  LMShopInfoAllGoodsEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoAllGoodsEntity.h"

@implementation LMShopInfoAllGoodsEntity

+(LMShopInfoAllGoodsEntity*)initLMShopInfoAllGoodsListEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *goodsImg = [dic objectForKey:@"goods_home_img"];
        [self setImgUrl:goodsImg];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
        NSInteger good_id = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:good_id];
        
        CGFloat market = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarketPrice:market];
        
        CGFloat shopPrice = [[dic objectForKey:@"shop_price"] floatValue];
        [self setShopPrice:shopPrice];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSInteger addTime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAddTime:addTime];
    }
    return self;
}

@end
