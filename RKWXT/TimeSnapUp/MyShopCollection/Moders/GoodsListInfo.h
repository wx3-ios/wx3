//
//  GoodsListInfo.h
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsListInfo : NSObject
@property (nonatomic,strong)NSString *scare_buying_id; //为0是普通商品，16为抢购商品
@property (nonatomic,strong)NSString *begin_time; //开始时间
@property (nonatomic,strong)NSString *end_time; //结束时间
@property (nonatomic,strong)NSString *scare_buying_price; //抢购商品价格
@property (nonatomic,strong)NSString *goods_price; //商品价格
@property (nonatomic,strong)NSString *goods_name; //商品名称
@property (nonatomic,strong)NSString *goods_home_img; //商品图片
@property (nonatomic,strong)NSString *add_goods_home_img; //商品图片链接
@property (nonatomic,strong)NSString *goods_number; //库存数量

//"scare_buying_id": "16",
//"shop_id": "3",
//"goods_id": "100003",
//"goods_stock_id": "610",

//"scare_buying_number": "20",
//"user_scare_buying_number": "0",
//"scare_buying_price": "788.00",
//"sort_order": "4",
//"add_time": "1447753420",
//"is_delete": "0",
//"goods_stock_name": "奥迪Q5&#160;800元/天",
//"": "69",
//"": "800.00",
//"is_use_cat": "0",
//"is_use_dog": "0",
//"is_use_red": "22",
//"divide": "203",
//"": "上衣演示",
//"cat_id": "21",
//"goods_type_id": "4",
//"goods_home_img": "20150804/20150804173523_590871.jpeg",
//"goods_icarousel_img": "20150804/20150804173617_901087.jpeg,20150804/20150804173631_548785.jpeg,",
//"meterage_id": "2",
//"shop_price": "6666.00",
//"market_price": "8888.00",
//"is_postage": "0",
//"weight": "5521",
//"goods_type_name": "服装",
//"shop_name": "韩潮",
//"cat_name": "快乐大本营",
//"meterage_name": "个"
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
