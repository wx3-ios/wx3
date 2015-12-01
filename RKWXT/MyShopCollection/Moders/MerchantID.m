//
//  MerchantID.m
//  RKWXT
//
//  Created by app on 15/11/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MerchantID.h"
#import "TimeShopData.h"
@implementation MerchantID
- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        _scare_buying_id = dict[@"scare_buying_id"];
        _goods_id = dict[@"goods_id"];
         _is_delete = dict[@"is_delete"];
         _seller_user_id = dict[@"seller_user_id"];
         _shop_id = dict[@"shop_id"];
         _goods_stock_id = dict[@"goods_stock_id"];
        TimeShopData *data = [[TimeShopData alloc]initWithDict:dict[@"goods"]];
        [self.dataArray addObject:data];
    }
    return self;
}

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
