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
    
    }
    return self;
}

@end
