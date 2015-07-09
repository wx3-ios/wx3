//
//  RefundStateEntity.m
//  RKWXT
//
//  Created by SHB on 15/7/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundStateEntity.h"

@implementation RefundStateEntity

+(RefundStateEntity*)initRefundStateWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@""];
        [self setName:name];
        
        NSString *phone = [dic objectForKey:@""];
        [self setPhone:phone];
        
        NSString *address = [dic objectForKey:@""];
        [self setAddress:address];
    }
    return self;
}

@end
