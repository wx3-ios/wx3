//
//  UserCutEntity.m
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserCutEntity.h"

@implementation UserCutEntity

+(UserCutEntity*)initUserCutEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        CGFloat money = [[dic objectForKey:@""] floatValue];
        [self setMoney:money];
        
        NSInteger wxID = [[dic objectForKey:@""] integerValue];
        [self setUserID:wxID];
        
        NSInteger date = [[dic objectForKey:@""] integerValue];
        [self setDate:date];
    }
    return self;
}

@end
