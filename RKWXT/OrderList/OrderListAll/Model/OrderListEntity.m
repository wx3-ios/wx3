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
        
        NSInteger agree = [[dic objectForKey:@"agree_refund"] integerValue];
        [self setShopDeal_status:agree];
        
        NSInteger refund = [[dic objectForKey:@"refund_state"] integerValue];
        [self setRefund_status:refund];
        
        CGFloat factPay = [[dic objectForKey:@"fact_pay_money"] floatValue];
        [self setFactPayMoney:factPay];
        
        CGFloat factRed = [[dic objectForKey:@"fact_red_packet"] floatValue];
        [self setFactRedPacket:factRed];
        
        NSString *stockName= [dic objectForKey:@"goods_stock_name"];
        [self setStockName:stockName];
        
        NSInteger orderGoodsID = [[dic objectForKey:@"order_goods_id"] integerValue];
        [self setOrderGoodsID:orderGoodsID];
        
        CGFloat refundTotalMoney = [[dic objectForKey:@"refund_total_money"] floatValue];
        [self setRefundTotalMoney:refundTotalMoney];
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
        
        NSString *shopPhone = [dic objectForKey:@"shop_telephone"];
        [self setShopPhone:shopPhone];
        
        NSString *couriername = [dic objectForKey:@"shipments_type"];
        [self setCourierName:couriername];
        
        NSString *couriernum = [dic objectForKey:@"tracking_number"];
        [self setCourierNum:couriernum];
        
        NSString *remark = [dic objectForKey:@"remark"];
        [self setRemark:remark];
        
        CGFloat postage = [[dic objectForKey:@"postage"] floatValue];
        [self setPostage:postage];
    }
    return self;
}

@end
