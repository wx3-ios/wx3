//
//  LMOrderListEntity.m
//  RKWXT
//
//  Created by SHB on 15/12/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderListEntity.h"

@implementation LMOrderListEntity

+(LMOrderListEntity*)initLmOrderInfoEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initOrderInfoDic:dic];
}

-(id)initOrderInfoDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger addtime = [[dic objectForKey:@"add_time"] integerValue];
        [self setAddTime:addtime];
        
        NSString *address = [dic objectForKey:@"address"];
        [self setUserAddress:address];
        
        NSString *userName = [dic objectForKey:@"consignee"];
        [self setUserName:userName];
        
        NSString *userPhone = [dic objectForKey:@"telephone"];
        [self setUserPhone:userPhone];
        
        CGFloat payMoney = [[dic objectForKey:@"fact_total_fee"] floatValue];
        [self setPayMoney:payMoney];
        
        NSInteger payType = [[dic objectForKey:@"is_payment"] integerValue];
        [self setPayType:payType];
        
        NSInteger sendType = [[dic objectForKey:@"is_shipments"] integerValue];
        [self setSendType:sendType];
        
        NSInteger evaluate = [[dic objectForKey:@"is_evaluate"] integerValue];
        [self setEvaluate:evaluate];
        
        NSInteger orderID = [[dic objectForKey:@"order_id"] integerValue];
        [self setOrderId:orderID];
        
        NSInteger orderState = [[dic objectForKey:@"order_status"] integerValue];
        [self setOrderState:orderState];
        
        CGFloat orderMoney = [[dic objectForKey:@"order_total_money"] floatValue];
        [self setOrderMoney:orderMoney];
        
        CGFloat carriage = [[dic objectForKey:@"postage"] floatValue];
        [self setCarriageMoney:carriage];
        
        CGFloat redParget = [[dic objectForKey:@"red_packet"] floatValue];
        [self setRedpacket:redParget];
        
        NSString *remark = [dic objectForKey:@"remark"];
        [self setUserRemark:remark];
        
        NSString *sendname = [dic objectForKey:@"shipments_type"];
        [self setSendName:sendname];
        
        NSInteger shopID = [[dic objectForKey:@"shop_id"] integerValue];
        [self setShopID:shopID];
        
        NSString *shopName = [dic objectForKey:@"shop_name"];
        [self setShopName:shopName];
        
        NSString *shopPhone = [dic objectForKey:@"shop_telephone"];
        [self setShopPhone:shopPhone];
        
        NSString *sendNum = [dic objectForKey:@"tracking_number"];
        [self setSendNumber:sendNum];
    }
    return self;
}

+(LMOrderListEntity*)initLmOrderGoodsListEntity:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initOrderGoodsListEntity:dic];
}

-(id)initOrderGoodsListEntity:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSInteger dealRefund = [[dic objectForKey:@"agree_refund"] integerValue];
        [self setShopDealType:dealRefund];
        
        CGFloat fact_pay_money = [[dic objectForKey:@"fact_pay_money"] floatValue];
        [self setGoodsValue:fact_pay_money];
        
        CGFloat redpacket = [[dic objectForKey:@"fact_red_packet"] floatValue];
        [self setGoodsRedPacket:redpacket];
        
        NSInteger goodsID = [[dic objectForKey:@"goods_id"] integerValue];
        [self setGoodsID:goodsID];
        
        NSString *img = [dic objectForKey:@"goods_img"];
        [self setGoodsImg:img];
        
        NSString *goodsName = [dic objectForKey:@"goods_name"];
        [self setGoodsName:goodsName];
        
        NSInteger stockID = [[dic objectForKey:@"goods_stock_id"] integerValue];
        [self setStockID:stockID];
        
        NSString *stockname = [dic objectForKey:@"goods_stock_name"];
        [self setStockName:stockname];
        
        NSInteger sendType = [[dic objectForKey:@"is_shipments"] integerValue];
        [self setGoodsSendType:sendType];
        
        NSInteger orderGoodsID = [[dic objectForKey:@"order_goods_id"] integerValue];
        [self setOrderGoodsID:orderGoodsID];
        
        NSInteger orderGoodsState = [[dic objectForKey:@"order_goods_status"] integerValue];
        [self setGoodsOrderID:orderGoodsState];
        
        NSInteger refundState = [[dic objectForKey:@"refund_state"] integerValue];
        [self setRefundState:refundState];
        
        CGFloat refundMoney = [[dic objectForKey:@"refund_total_money"] floatValue];
        [self setRefundMoney:refundMoney];
        
        NSInteger buyNum = [[dic objectForKey:@"sales_number"] integerValue];
        [self setBuyNumber:buyNum];
        
        CGFloat stockPrice = [[dic objectForKey:@"sales_price"] floatValue];
        [self setStockPrice:stockPrice];
        
        CGFloat should_pay_money = [[dic objectForKey:@"should_pay_money"] floatValue];
        [self setGoodsShouldPay:should_pay_money];
    }
    return self;
}

@end