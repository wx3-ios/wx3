//
//  LMSellerListEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerListEntity.h"

@implementation LMSellerListEntity

+(LMSellerListEntity*)initSellerListEntityWidth:(NSDictionary *)dic{
    if(!dic){
        
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self  =[super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        CGFloat distance = [[dic objectForKey:@"distance"] floatValue];
        [self setDistance:distance];
        
        CGFloat la = [[dic objectForKey:@"latitude"] floatValue];
        [self setLatitude:la];
        
        CGFloat lo = [[dic objectForKey:@"longitude"] floatValue];
        [self setLonitude:lo];
        
        NSString *img = [dic objectForKey:@"seller_home_img"];
        [self setSellerImg:img];
        
        NSString *name = [dic objectForKey:@"seller_name"];
        [self setSellerName:name];
        
        NSInteger sellerID = [[dic objectForKey:@"seller_id"] integerValue];
        [self setSellerId:sellerID];
    }
    return self;
}

@end
