//
//  SearchResultEntity.m
//  RKWXT
//
//  Created by SHB on 15/10/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "SearchResultEntity.h"

@implementation SearchResultEntity

+(SearchResultEntity*)initSearchResultEntityWith:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"goods_name"];
        [self setGoodsName:name];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
    }
    return self;
}

@end
