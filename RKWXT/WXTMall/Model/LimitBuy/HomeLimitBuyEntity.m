//
//  HomeLimitBuyEntity.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "HomeLimitBuyEntity.h"

@implementation HomeLimitBuyEntity

+(HomeLimitBuyEntity*)initLimitBuyEntityWith:(NSDictionary *)dic{
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
