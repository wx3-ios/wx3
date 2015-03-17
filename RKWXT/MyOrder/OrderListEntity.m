//
//  OrderListEntity.m
//  Woxin2.0
//
//  Created by qq on 14-8-12.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "OrderListEntity.h"

@implementation OrderListEntity

-(void)dealloc{
    [super dealloc];
}

+ (OrderListEntity *)orderListWithDictionary:(NSDictionary *)orderDic{
    if(!orderDic){
        return nil;
    }
    
    return [[[self alloc] initWithOrderDic:orderDic] autorelease];
}

- (id)initWithOrderDic:(NSDictionary *)orderDic{
    if(self = [super init]){
        NSString *order_id = [orderDic objectForKey:@"order_id"];
        [self setOrder_id:order_id];
        CGFloat price = [[orderDic objectForKey:@"price"] floatValue];
        [self setPrice:price];
        NSInteger time = [[orderDic objectForKey:@"time"] integerValue];
        [self setTime:time];
        NSInteger type = [[orderDic objectForKey:@"order_type"] integerValue];
        [self setType:type];
        NSString *phone = [orderDic objectForKey:@"phone"];
        [self setPhoneNum:phone];
        NSString *name = [orderDic objectForKey:@"name"];
        [self setName:name];
        NSInteger shop_id = [[orderDic objectForKey:@"shop_id"] integerValue];
        [self setShop_id:shop_id];
        NSString *shop_name = [orderDic objectForKey:@"shop_name"];
        [self setShop_name:shop_name];
        NSString *remark = [orderDic objectForKey:@"remark"];
        [self setRemarks:remark];
        NSString *address = [orderDic objectForKey:@"address"];
        [self setAddress:address];
        NSInteger red_package = [[orderDic objectForKey:@"red_package"] integerValue];
        [self setRed_package:red_package];
        NSString *unit = [orderDic objectForKey:@"meterage_name"];
        [self setUnit:unit];
        
        //套餐
        NSArray *arr = [orderDic objectForKey:@"data"];
        [self setDataArr:arr];
//        for(NSDictionary *dic in arr){
//            NSInteger goodID = [[dic objectForKey:@"id"] integerValue];
//            [self setGoodID:goodID];
//            NSString *goodName = [dic objectForKey:@"name"];
//            [self setGoodName:goodName];
//            NSInteger goodNum = [[dic objectForKey:@"num"] integerValue];
//            [self setGoodNum:goodNum];
//            CGFloat goodPrice = [[dic objectForKey:@"price"] floatValue];
//            [self setGoodPrice:goodPrice];
//            NSInteger goodType = [[dic objectForKey:@"type"] integerValue];
//            [self setGoodType:goodType];
//        }
    }
    return self;
}

@end