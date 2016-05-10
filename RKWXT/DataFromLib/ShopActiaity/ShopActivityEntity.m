//
//  ShopActivityEntity.m
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ShopActivityEntity.h"

@implementation ShopActivityEntity
+(instancetype)shareShopActionEntity{
    static ShopActivityEntity *entity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entity = [[ShopActivityEntity alloc]init];
    });
    return entity;
}

+(instancetype)shopActivityEntityWithDic:(NSDictionary *)dic{
    ShopActivityEntity *entity = [ShopActivityEntity shareShopActionEntity];
    entity.postage = [dic[@"isshop_postage"] floatValue];
    entity.fullReduction = dic[@"full_reduce"];
    int type = [dic[@"action_type"] intValue];
    [entity setType:type];
    [ShopActivityEntity  shopWithactity];
    return entity;
}

+ (void)shopWithactity{
     ShopActivityEntity *entity = [ShopActivityEntity shareShopActionEntity];
    if ([entity.fullReduction isEqualToString:@""] || [entity.fullReduction isEqual:nil]) return;
    NSArray *arr = [entity.fullReduction componentsSeparatedByString:@":"];
    if ([arr count] <= 0) return;
    entity.full = [arr[0] floatValue];
    entity.action = [arr[1] floatValue];
}

@end
