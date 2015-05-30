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
        
    }
    return self;
}

@end
