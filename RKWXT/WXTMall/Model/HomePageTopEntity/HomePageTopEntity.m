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
        NSInteger sort = [[dic objectForKey:@"sort"] integerValue];
        [self setSort:sort];
        
        NSString *topImg = [dic objectForKey:@"top_img"];
        [self setTopImg:topImg];
    }
    return self;
}

@end
