//
//  LMShopCollectionEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopCollectionEntity.h"

@implementation LMShopCollectionEntity

+(LMShopCollectionEntity*)initShopCollectionData:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        CGFloat score = [[dic objectForKey:@"score"] floatValue];
        [self setScore:score];
        
        NSString *homeImg = [dic objectForKey:@"shop_home_img"];
        [self setHomeImg:homeImg];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSString *shopName = [dic objectForKey:@"shop_name"];
        [self setShopName:shopName];
    }
    return self;
}

@end
