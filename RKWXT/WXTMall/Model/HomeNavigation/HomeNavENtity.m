//
//  HomeNavENtity.m
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomeNavENtity.h"

@implementation HomeNavENtity

+(HomeNavENtity*)homeNavigationEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
    
    }
    return self;
}

@end
