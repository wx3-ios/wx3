//
//  OrderListEntity.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

//支付状态
typedef enum{
    Pay_Status_WaitPay = 0,  //待支付
    Pay_Status_HasPay,       //已支付
}Pay_Status;

//发货状态
typedef enum{
    Goods_Status_WaitSend = 0,  //待发货
    Goods_Status_HasSend,       //已发货
}Goods_Status;

//订单状态
typedef enum{
    Order_Status_Cancel = 0, //订单已取消
    Order_Status_Complete, // 订单已完成
}Order_Status;

@interface OrderListEntity : NSObject
@property (nonatomic,assign) Pay_Status pay_status;
@property (nonatomic,assign) Goods_Status goods_status;
@property (nonatomic,assign) Order_Status order_status;

+(OrderListEntity*)orderListDataWithDictionary:(NSDictionary*)dic;

@end
