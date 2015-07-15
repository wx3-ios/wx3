//
//  RefundStateEntity.h
//  RKWXT
//
//  Created by SHB on 15/7/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Refund_Type_Normal = 0,
    Refund_Type_Agree,
    Refund_Type_Refuse,
}Refund_Type;

typedef enum{
    User_Refund_Type_Normal = 0,
    User_Refund_Type_Apply,
    User_Refund_Type_HasDone,
}User_Refund_Type;

@interface RefundStateEntity : NSObject

@property (nonatomic,assign) Refund_Type refund_type;              //商家退款状态
@property (nonatomic,assign) User_Refund_Type user_Refund_type;    //用户退款状态
@property (nonatomic,strong) NSString *refund_total_money;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *address;

+(RefundStateEntity*)initRefundStateWithDic:(NSDictionary*)dic;

@end
