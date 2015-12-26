//
//  LMSearchSellerEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchSellerEntity.h"

@implementation LMSearchSellerEntity

+(LMSearchSellerEntity*)initLMSearchSellerEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"seller_name"];
        [self setSellerName:name];
        
        NSInteger sellerID = [[dic objectForKey:@"seller_id"] integerValue];
        [self setSellerID:sellerID];
        
        NSString *logo = [dic objectForKey:@"seller_logo"];
        [self setImgUrl:logo];
        
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
    }
    return self;
}

@end
