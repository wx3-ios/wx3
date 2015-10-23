//
//  ClassiftGoodsEntity.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassiftGoodsEntity.h"

@implementation ClassiftGoodsEntity

+(ClassiftGoodsEntity*)initCLassifyGoodsListData:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *goodsImg = [dic objectForKey:@"goods_home_img"];
        [self setGoodsImg:goodsImg];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
    }
    return self;
}

@end
