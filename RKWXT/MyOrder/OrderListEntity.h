//
//  OrderListEntity.h
//  Woxin2.0
//
//  Created by qq on 14-8-12.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListEntity : NSObject
@property (nonatomic,retain) NSString *order_id;    //订单号
@property (nonatomic,assign) CGFloat price;         //价格
@property (nonatomic,assign) NSInteger time;        //订单时间
@property (nonatomic,assign) NSInteger type;        //订单类型  1-到店  2-外卖
@property (nonatomic,retain) NSString *phoneNum;    //联系电话
@property (nonatomic,retain) NSString *name;        //用户姓名
@property (nonatomic,assign) NSInteger shop_id;     //分店id
@property (nonatomic,retain) NSString *shop_name;   //分店名称
@property (nonatomic,retain) NSString *remarks;     //备注
@property (nonatomic,retain) NSString *address;     //地址
@property (nonatomic,assign) NSInteger red_package; //使用红包金额
@property (nonatomic,retain) NSString *unit;        //单位

//套餐
@property (nonatomic,assign) NSInteger goodID;      //goodID 如果是套餐就是套餐的ID，如果是商品，就是商品的ID
@property (nonatomic,assign) NSInteger goodNum;     //个数
@property (nonatomic,retain) NSString *goodName;
@property (nonatomic,assign) CGFloat goodPrice;
@property (nonatomic,assign) NSInteger goodType;
@property (nonatomic,retain) NSArray *dataArr;

+ (OrderListEntity *)orderListWithDictionary:(NSDictionary *)orderDic;

@end