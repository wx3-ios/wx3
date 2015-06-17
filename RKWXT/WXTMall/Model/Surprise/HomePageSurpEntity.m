//
//  HomePageSurpEntity.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageSurpEntity.h"

@implementation HomePageSurpEntity

+(HomePageSurpEntity*)homePageSurpEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goodsID];
        
        NSString *name = [dic objectForKey:@"goods_name"];
        [self setGoods_name:name];
        
        NSString *imgUrl = [dic objectForKey:@"goods_home_img"];
        [self setHome_img:imgUrl];
    }
    return self;
}

@end
