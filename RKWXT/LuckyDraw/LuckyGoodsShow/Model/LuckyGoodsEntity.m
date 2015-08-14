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
        NSString *imgUrl = [dic objectForKey:@""];
        [self setImgUrl:imgUrl];
        
        NSString *name = [dic objectForKey:@""];
        [self setName:name];
        
        CGFloat price = [[dic objectForKey:@""] floatValue];
        [self setPrice:price];
    }
    return self;
}

@end
