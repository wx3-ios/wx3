//
//  OrderListModel.h
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_UserOderList_LoadSucceed  @"K_Notification_UserOderList_LoadSucceed"
#define K_Notification_UserOderList_LoadFailed   @"K_Notification_UserOderList_LoadFailed"

#define K_Notification_UserOderList_CancelSucceed @"K_Notification_UserOderList_CancelSucceed"
#define K_Notification_UserOderList_CancelFailed  @"K_Notification_UserOderList_CancelFailed"

#define K_Notification_UserOderList_CompleteSucceed @"K_Notification_UserOderList_CompleteSucceed"
#define K_Notification_UserOderList_CompleteFailed  @"K_Notification_UserOderList_CompleteFailed"

#define K_Notification_UserOderList_RefundSucceed @"K_Notification_UserOderList_RefundSucceed"
#define K_Notification_UserOderList_RefundFailed  @"K_Notification_UserOderList_RefundFailed"

typedef enum{
    OrderList_Type_Normal = 0,
    OrderList_Type_Loading,
    OrderList_Type_Refresh,
}OrderList_Type;

typedef enum{
    DealOrderList_Type_Normal = 0,
    DealOrderList_Type_Cancel,
    DealOrderList_Type_Complete,
}DealOrderList_Type;

typedef enum{
    Refund_Type_Normal = 0,
    Refund_Type_Order,  //退整个订单
    Refund_Type_Goods,   //退某个单品
}Refund_Type;

@interface OrderListModel : T_HPSubBaseModel
@property (nonatomic,assign) OrderList_Type orderlist_type;
@property (nonatomic,strong) NSString *orderID;  //临时记录，以备支付用
@property (nonatomic,readonly) NSArray *orderListAll;   //订单列表
@property (nonatomic,readonly) NSArray *waitListArr;    //待付款列表
@property (nonatomic,readonly) NSArray *waitSendListArr;   //待发货列表
@property (nonatomic,readonly) NSArray *waitReceiveListArr; //待收货列表

+(OrderListModel*)shareOrderListModel;
-(void)loadUserOrderList:(NSInteger)fromIndex to:(NSInteger)toIndex;
-(void)dealUserOrderListWithType:(DealOrderList_Type)type with:(NSString*)orderID;
-(void)refundOrderWithRefundType:(Refund_Type)refundType withOrderGoodsID:(NSInteger)orderGoodsID orderID:(NSInteger)orderID withMessage:(NSString*)message;
-(BOOL)shouldDataReload;

@end
