//
//  BalanceEntity.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BalanceEntity.h"

@implementation BalanceEntity

+(BalanceEntity*)initUserBalanceWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSString *date = [dic objectForKey:@"expireddate"];
        [self setDate:date];
        
        CGFloat balance = [[dic objectForKey:@"balance"] floatValue];
        [self setMoney:balance];
        
        NSString *state = [dic objectForKey:@"state"];
        [self setStatus:state];
    }
    return self;
}

@end
