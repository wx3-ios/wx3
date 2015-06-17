//
//  HomePageRecEntity.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageRecEntity.h"

@implementation HomePageRecEntity

+(HomePageRecEntity*)homePageRecEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSInteger goods_id = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goods_id];
        
        NSString *name = [dic objectForKey:@"goods_name"];
        [self setGoods_name:name];
        
        NSString *img = [dic objectForKey:@"goods_home_img"];
        [self setHome_img:img];
    }
    return self;
}

@end
