//
//  LMSellerInfoEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerInfoEntity.h"

@implementation LMSellerInfoEntity

+(LMSellerInfoEntity*)initSellerInfoEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        NSString *img = [dic objectForKey:@"seller_carousel_img"];
        [self setImgUrl:img];
        
        NSString *logo = [dic objectForKey:@"seller_logo"];
        [self setSellerImg:logo];
        
        NSString *name = [dic objectForKey:@"seller_name"];
        [self setSellerName:name];
        
        NSString *phone = [dic objectForKey:@"telephone"];
        [self setSellerPhone:phone];
    }
    return self;
}

+(LMSellerInfoEntity*)initShopListEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic1:dic];
}

-(id)initWithDic1:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *goodsImg = [dic objectForKey:@"goods_home_img"];
        [self setGoodsImg:goodsImg];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSInteger goodsId = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsId];
    }
    return self;
}

+(LMSellerInfoEntity*)initShopInfoEtity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic2:dic];
}

-(id)initWithDic2:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *shopImg = [dic objectForKey:@"shop_home_img"];
        [self setShopImg:shopImg];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSString *shopName = [dic objectForKey:@"shop_name"];
        [self setShopName:shopName];
    }
    return self;
}

@end
