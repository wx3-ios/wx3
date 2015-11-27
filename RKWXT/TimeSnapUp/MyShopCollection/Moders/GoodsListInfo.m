//
//  GoodsListInfo.m
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "GoodsListInfo.h"

@implementation GoodsListInfo
- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
           _scare_buying_id = dict[@"scare_buying_id"];
           _begin_time = dict[@"begin_time"];
           _end_time = dict[@"end_time"];
           _scare_buying_price = dict[@"scare_buying_price"];
           _goods_price = dict[@"goods_price"];
           _goods_name = dict[@"goods_name"];
           _goods_home_img = dict[@"goods_home_img"];
           _goods_number = dict[@"goods_number"];
           _goods_id = dict[@"goods_id"];
        
    }
    return self;
}



-(void)setAdd_goods_home_img:(NSString *)add_goods_home_img{
    _add_goods_home_img = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,_goods_home_img];
}

@end
