//
//  ShopUnionHotShopEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopUnionHotShopEntity.h"

@implementation ShopUnionHotShopEntity

+(ShopUnionHotShopEntity*)initShopUnionHotShopEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        CGFloat distance = [[dic objectForKey:@"distance"] floatValue];
        [self setDistance:distance];
        
        CGFloat latitude = [[dic objectForKey:@"latitude"] floatValue];
        [self setLatitude:latitude];
        
        CGFloat longitude = [[dic objectForKey:@"longitude"] floatValue];
        [self setLongitude:longitude];
        
        NSInteger sellerID = [[dic objectForKey:@"seller_id"] integerValue];
        [self setSellerID:sellerID];
        
        NSString *imgUrl = [dic objectForKey:@"seller_logo"];
        [self setSellerLogo:imgUrl];
        
        NSString *name = [dic objectForKey:@"seller_name"];
        [self setSellerName:name];
    }
    return self;
}

@end
