//
//  TimeShopData.m
//  RKWXT
//
//  Created by app on 15/11/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "TimeShopData.h"

@implementation TimeShopData
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self =[super init]) {
        self.begin_time = dict[@"begin_time"];
        self.end_time = dict[@"end_time"];
        self.goods_price = dict[@"goods_price"];
        self.scare_buying_number = dict[@"scare_buying_number"];
        self.scare_buying_price = dict[@"scare_buying_price"];
        self.goods_name = dict[@"goods_name"];
        self.goods_home_img = dict[@"goods_home_img"];
        self.add_time = dict[@"add_time"];
        self.sort_order = dict[@"sort_order"];
        self.scare_buying_id = dict[@"scare_buying_id"];
        self.shop_id = dict[@"shop_id"];
        self.goods_id = dict[@"goods_id"];
        self.user_scare_buying_number = dict[@"user_scare_buying_number"];
        self.goods_stock_name = dict[@"goods_stock_name"];
        self.goods_stock_id = dict[@"goods_stock_id"];
        self.shop_name = dict[@"shop_name"];
     //   [self setValuesForKeysWithDictionary:dict];
        
        
        
        
        
    }
    return self;
}

- (NSString*)add_goods_home_img{
    
    return  [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,_goods_home_img];
}

@end
