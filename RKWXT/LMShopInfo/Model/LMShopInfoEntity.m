//
//  LMShopInfoEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoEntity.h"

@implementation LMShopInfoEntity

//所有商品
+(LMShopInfoEntity*)initAllGoodsEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithAllGoods:dic];
}

-(id)initWithAllGoods:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *homeImg = [dic objectForKey:@"goods_home_img"];
        [self setAll_goodsImg:homeImg];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setAll_goodsID:goodsID];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setAll_goodsName:goodsName];
        
        CGFloat marketPrice = [[dic objectForKey:@"market_price"] floatValue];
        [self setAll_marketPrice:marketPrice];
        
        CGFloat shopPrice = [[dic objectForKey:@"shop_price"] floatValue];
        [self setAll_shopPrice:shopPrice];
    }
    return self;
}

//推荐商品
+(LMShopInfoEntity*)initComGoodsEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initComGoods:dic];
}

-(id)initComGoods:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *homeImg = [dic objectForKey:@"goods_home_img"];
        [self setCom_goodsImg:homeImg];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setCom_goodsID:goodsID];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setCom_goodsName:goodsName];
        
        CGFloat marketPrice = [[dic objectForKey:@"market_price"] floatValue];
        [self setCom_marketPrice:marketPrice];
        
        CGFloat shopPrice = [[dic objectForKey:@"shop_price"] floatValue];
        [self setCom_shopPrice:shopPrice];
    }
    return self;
}

//店铺信息
+(LMShopInfoEntity*)initShopInfoEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initShopInfo:dic];
}

-(id)initShopInfo:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        NSInteger allGoods = [[dic objectForKey:@"all_goods"] integerValue];
        [self setAllGoodsNum:allGoods];
        
        NSInteger comGoods = [[dic objectForKey:@"commend_goods"] integerValue];
        [self setComGoodsNum:comGoods];
        
        NSInteger proGoods = [[dic objectForKey:@"promo_goods"] integerValue];
        [self setProGoodsNum:proGoods];
        
        NSInteger actives = [[dic objectForKey:@"dynamic"] integerValue];
        [self setActiveNum:actives];
        
        NSString *img = [dic objectForKey:@"shop_carousel_img"];
        [self setTopImg:img];
        
        NSString *name = [dic objectForKey:@"shop_name"];
        [self setShopName:name];
        
        NSString *phone = [dic objectForKey:@"telephone"];
        [self setShopPhone:phone];
    }
    return self;
}

@end
