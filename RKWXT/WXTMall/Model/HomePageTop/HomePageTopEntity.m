//
//  HomePageTopEntity.m
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageTopEntity.h"

@implementation HomePageTopEntity

+(HomePageTopEntity*)homePageTopEntityWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithJsonDictionary:dic];
}

-(id)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *topImg = [dic objectForKey:@"top_image"];
        [self setTopImg:topImg];
        
        NSString *address = [dic objectForKey:@"top_address_id"];
        [self setLinkAddress:address];
        
        NSInteger type = [[dic objectForKey:@"top_nav_type_id"] integerValue];
        [self setTopType:type];
    }
    return self;
}

@end
