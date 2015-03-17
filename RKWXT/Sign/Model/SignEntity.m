//
//  SignEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SignEntity.h"

@implementation SignEntity

+(SignEntity*)signWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        CGFloat money = [[dic objectForKey:@"money"] floatValue];
        [self setMoney:money];
        
        NSString *msg = [dic objectForKey:@"msg"];
        [self setMessage:msg];
        
        NSInteger time = [[dic objectForKey:@"time"] integerValue];
        [self setTime:time];
    }
    return self;
}

@end
