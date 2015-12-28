//
//  LMSearchHotGoodsEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchHotGoodsEntity.h"

@implementation LMSearchHotGoodsEntity

+(LMSearchHotGoodsEntity*)initLMSearchHotGoodsEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *keyword = [dic objectForKey:@"keyword"];
        [self setGoodsName:keyword];
        
        NSInteger searchID = [[dic objectForKey:@"search_id"] integerValue];
        [self setSearchID:searchID];
    }
    return self;
}

@end
