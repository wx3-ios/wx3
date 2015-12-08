//
//  ShopUnionClassifyEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopUnionClassifyEntity.h"

@implementation ShopUnionClassifyEntity

+(ShopUnionClassifyEntity*)initClassifyEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"industry_name"];
        [self setIndustryName:name];
        
        NSInteger classifyID = [[dic objectForKey:@"industry_id"] integerValue];
        [self setIndustryID:classifyID];
    }
    return self;
}

@end
