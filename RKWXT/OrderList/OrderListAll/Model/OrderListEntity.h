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
    Order_Status_Normal = 0, //订单可操作
    Order_Status_Complete, // 订单已完成
    Order_Status_Cancel,    //订单已取消
    Order_Status_None,      //订单不可操作（可能由退款导致，此订单尚未交易完成）
}Order_Status;

//退款
typedef enum{
    Refund_Status_Normal = 0,  //未申请
    Refund_Status_Being,       //已申请，如果商家同意则为退款中
    Refund_Status_HasDone,     //已退款
}Refund_Status;

//商家处理退款
typedef enum{
    ShopDeal_Refund_Normal = 0,  //未处理
    ShopDeal_Refund_Agree,       //同意
    ShopDeal_Refund_Refuse,      //不同意
}ShopDeal_Status;

@interface OrderListEntity : NSObject
@property (nonatomic,assign) Pay_Status pay_status;
@property (nonatomic,assign) Goods_Status goods_status;
@property (nonatomic,assign) Order_Status order_status;
@property (nonatomic,assign) Refund_Status refund_status;
@property (nonatomic,assign) ShopDeal_Status shopDeal_status;
@property (nonatomic,strong) NSArray *goodsArr;  //存放商品列表的数据

//订单基础信息
@property (nonatomic,assign) NSInteger order_id;    //订单ID
@property (nonatomic,assign) NSInteger add_time;    //订单时间
@property (nonatomic,strong) NSString *address;     //收货地址
@property (nonatomic,strong) NSString *consignee;   //联系人姓名
@property (nonatomic,strong) NSString *userPhone;   //收货人电话
@property (nonatomic,assign) CGFloat total_fee;     //订单实付金额
@property (nonatomic,assign) CGFloat all_money;     //订单应付金额
@property (nonatomic,assign) NSInteger red_packet;  //使用红包金额
@property (nonatomic,strong) NSString *shopPhone;   //商家电话
@property (nonatomic,strong) NSString *remark;      //买家留言
@property (nonatomic,strong) NSString *courierNum;  //快递单号
@property (nonatomic,strong) NSString *courierName; //快递名字

//订单商品信息
@property (nonatomic,assign) NSInteger goods_id;    //商品ID
@property (nonatomic,strong) NSString *goods_img;   //商品小图
@property (nonatomic,strong) NSString *goods_name;  //商品名称
@property (nonatomic,assign) NSInteger stock_id;    //套餐ID
@property (nonatomic,strong) NSString *stockName;   //套餐名称
@property (nonatomic,assign) NSInteger sales_num;   //购买数量
@property (nonatomic,assign) CGFloat sales_price;   //商品单价
@property (nonatomic,assign) CGFloat factPayMoney;  //商品总付金额（商品单价＊n－红包）
@property (nonatomic,assign) CGFloat factRedPacket; //商品使用总红包
@property (nonatomic,assign) NSInteger orderGoodsID; //退款所用专属id
@property (nonatomic,assign) CGFloat refundTotalMoney; //退款金额
@property (nonatomic,assign) CGFloat postage;   //订单运费

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL selectAll;

+(OrderListEntity*)orderListDataWithDictionary:(NSDictionary*)dic;
+(OrderListEntity*)orderInfoDataWithDictionary:(NSDictionary*)dic;

@end
