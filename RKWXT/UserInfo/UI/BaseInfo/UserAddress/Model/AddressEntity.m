//
//  AddressEntity.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AddressEntity.h"

@implementation AddressEntity

+(AddressEntity*)initAddressEntityWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *addr = [dic objectForKey:@"address"];
        [self setAddress:addr];
        
        NSInteger addID = [[dic objectForKey:@"address_id"] integerValue];
        [self setAddressID:addID];
        
        NSString *person = [dic objectForKey:@"consignee"];
        [self setUserName:person];
        
        NSString *phone = [dic objectForKey:@"telephone"];
        [self setUserPhone:phone];
        
        NSInteger defaultID = [[dic objectForKey:@"is_default"] integerValue];
        [self setNormalID:defaultID];
    }
    return self;
}

@end
