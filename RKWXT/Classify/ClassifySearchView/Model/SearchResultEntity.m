//
//  SearchResultEntity.m
//  RKWXT
//
//  Created by SHB on 15/10/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "SearchResultEntity.h"

@implementation SearchResultEntity

+(SearchResultEntity*)initSearchResultEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"goods_name"];
        [self setGoodsName:name];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
        
        NSString *imgUrl = [dic objectForKey:@"goods_home_img"];
        [self setImg:imgUrl];
        
        CGFloat marketPrice = [[dic objectForKey:@"market_price"] floatValue];
        [self setMarket_price:marketPrice];
        
        CGFloat shopPrice = [[dic objectForKey:@"shop_price"] floatValue];
        [self setShop_price:shopPrice];
    }
    return self;
}

@end
