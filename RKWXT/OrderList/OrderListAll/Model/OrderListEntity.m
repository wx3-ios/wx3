//
//  OrderListEntity.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderListEntity.h"

@implementation OrderListEntity

//订单商品信息
+(OrderListEntity*)orderListDataWithDictionary:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoods_id:goodsID];
        
        NSString *goodsImg = [dic objectForKey:@"goods_img"];
        [self setGoods_img:goodsImg];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoods_name:goodsName];
        
        NSInteger stockID = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStock_id:stockID];
        
        NSInteger number = [[dic objectForKey:@"sales_number"] integerValue];
        [self setSales_num:number];
        
        CGFloat price = [[dic objectForKey:@"sales_price"] floatValue];
        [self setSales_price:price];
        
        NSInteger orderID = [[dic objectForKey:@"order_id"] integerValue];
        [self setOrder_id:orderID];
    }
    return self;
}

//订单基本信息
+(OrderListEntity*)orderInfoDataWithDictionary:(NSDictionary*)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initOrderGoodsInfoWithDic:dic];
}

-(id)initOrderGoodsInfoWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger addTime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAdd_time:addTime];
        
        NSString *address = [dic objectForKey:@"address"];
        [self setAddress:address];
        
        NSString *consignee = [dic objectForKey:@"consignee"];
        [self setConsignee:consignee];
        
        NSString *phone = [dic objectForKey:@"telephone"];
        [self setUserPhone:phone];
        
        CGFloat fee = [[dic objectForKey:@"fact_total_fee"] floatValue];
        [self setTotal_fee:fee];
        
        NSInteger pay = [[dic objectForKey:@"is_payment"] integerValue];
        [self setPay_status:pay];
        
        NSInteger send = [[dic objectForKey:@"is_shipments"] integerValue];
        [self setGoods_status:send];
        
        NSInteger orderID = [[dic objectForKey:@"order_id"] integerValue];
        [self setOrder_id:orderID];
        
        NSInteger orderStatus = [[dic objectForKey:@"order_status"] integerValue];
        [self setOrder_status:orderStatus];
        
        CGFloat money = [[dic objectForKey:@"order_total_money"] floatValue];
        [self setAll_money:money];
        
        NSInteger redPacket = [[dic objectForKey:@"red_packet"] integerValue];
        [self setRed_packet:redPacket];
    }
    return self;
}

@end
