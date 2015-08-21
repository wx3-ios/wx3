//
//  LuckyOrderEntity.h
//  RKWXT
//
//  Created by SHB on 15/8/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

//订单是否付款
typedef enum{
    LuckyOrder_Pay_Wait = 0,
    LuckyOrder_Pay_Done,
}LuckyOrder_Pay;

//订单是否发货
typedef enum{
    LuckyOrder_Send_Wait = 0,
    LuckyOrder_Send_Done,
}LuckyOrder_Send;

//订单状态
typedef enum{
    LuckyOrder_Status_Wait = 0,
    LuckyOrder_Status_Done,  //完成
    LuckyOrder_Status_Close, //关闭
}LuckyOrder_Status;


@interface LuckyOrderEntity : NSObject
@property (nonatomic,assign) LuckyOrder_Pay pay_status;
@property (nonatomic,assign) LuckyOrder_Send send_status;
@property (nonatomic,assign) LuckyOrder_Status order_status;

@property (nonatomic,strong) NSString *address;   //收货人地址
@property (nonatomic,strong) NSString *userName;  //收货人姓名
@property (nonatomic,strong) NSString *userPhone; //联系人电话
@property (nonatomic,assign) NSInteger goods_id;  //商品id
@property (nonatomic,strong) NSString *goods_img; //商品图片
@property (nonatomic,strong) NSString *goods_name;//商品名称
@property (nonatomic,assign) NSInteger stock_id;  //属性主键ID
@property (nonatomic,strong) NSString *stockName; //属性名称
@property (nonatomic,assign) NSInteger lottery_id; //中奖ID
@property (nonatomic,assign) CGFloat goods_price;  //运费
@property (nonatomic,assign) CGFloat market_price; //市场价格
@property (nonatomic,assign) NSInteger order_id;   //订单ID
@property (nonatomic,assign) NSInteger makeOrderTime; //下单时间
@property (nonatomic,assign) NSInteger send_time;  //发货时间
@property (nonatomic,strong) NSString *send_type;  //发货类型
@property (nonatomic,strong) NSString *sellerPhone;//卖家电话
@property (nonatomic,strong) NSString *send_number;//快递单号

+(LuckyOrderEntity*)initLuckyOrderEntityWidthDic:(NSDictionary*)dic;

@end
