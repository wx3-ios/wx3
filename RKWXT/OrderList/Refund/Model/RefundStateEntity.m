//
//  RefundStateEntity.m
//  RKWXT
//
//  Created by SHB on 15/7/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundStateEntity.h"

@implementation RefundStateEntity

+(RefundStateEntity*)initRefundStateWithDic:(NSDictionary *)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithDic:dic];
}

//"agree_refund" = 1;
//"apply_refund_cause" = "\U6d4b\U8bd5";
//"apply_refund_time" = 1436867058;
//"order_goods_status" = 0;
//"refund_address" = "";
//"refund_consignee" = "";
//"refund_state" = 1;
//"refund_telephone" = "";
//"refund_total_money" = "0.01";
//"seller_operating_time" = 1436867058;
//"seller_remark" = "\U7528\U6237\U7533\U8bf7\U672a\U53d1\U8d27\U9000\U6b3e";
//"success_refund_time" = 0;

-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        NSString *name = [dic objectForKey:@"refund_consignee"];
        [self setName:name];
        
        NSString *phone = [dic objectForKey:@"refund_telephone"];
        [self setPhone:phone];
        
        NSString *address = [dic objectForKey:@"refund_address"];
        [self setAddress:address];
        
        NSInteger agree = [[dic objectForKey:@"agree_refund"] integerValue];
        [self setRefund_type:agree];
        
        NSInteger refundState = [[dic objectForKey:@"refund_state"] integerValue];
        [self setUser_Refund_type:refundState];
        
        NSString *money = [dic objectForKey:@"refund_total_money"];
        [self setRefund_total_money:money];
    }
    return self;
}

@end
