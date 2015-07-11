//
//  AboutShopEntity.m
//  Woxin2.0
//
//  Created by qq on 14-8-19.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "AboutShopEntity.h"

@implementation AboutShopEntity

+ (AboutShopEntity *)shopInfoEntityWithDic:(NSDictionary *)shopDic{
    if(!shopDic){
        return nil;
    }
    return [[self alloc] initWithShopDic:shopDic];
}

- (id)initWithShopDic:(NSDictionary *)shopDic{
    if(self = [super init]){
        NSString *name = [shopDic objectForKey:@"name"];
        [self setName:name];
        NSString *tel = [shopDic objectForKey:@"tel"];
        [self setTel:tel];
        NSString *address = [shopDic objectForKey:@"address"];
        [self setAddress:address];
    }
    return self;
}

@end
