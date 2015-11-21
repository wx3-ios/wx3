//
//  TimeShopData.h
//  RKWXT
//
//  Created by app on 15/11/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeShopData : NSObject
/** 开始时间  */
@property (nonatomic,strong)NSString *begin_time;
/** 结束时间  */
@property (nonatomic,strong)NSString *end_time;
/** 库存价格  */
@property (nonatomic,strong)NSString *goods_price;
/** 抢购数量  */
@property (nonatomic,strong)NSString *scare_buying_number;
/** 抢购价格  */
@property (nonatomic,strong)NSString *scare_buying_price;
/** 商品名称  */
@property (nonatomic,strong)NSString *goods_name;
/** 商品图片  */
@property (nonatomic,strong)NSString *goods_home_img;
/** 拼接的图片地址  */
@property (nonatomic,strong)NSString *add_goods_home_img;


@property (nonatomic,assign,getter=isEnd_Image_Hidden)BOOL end_Image_Hidden;
@property (nonatomic,assign,getter=isImageHidden)BOOL beg_imageHidden; //是否显示
@property (nonatomic,assign,getter=isDownHidden)BOOL downHidden; //是否显示






/** 添加时间  */
@property (nonatomic,strong)NSString *add_time;
/** 排序  */
@property (nonatomic,strong)NSString *sort_order;
/** 商店ID  */
@property (nonatomic,strong)NSString *shop_id;
/** 商品ID  */
@property (nonatomic,strong)NSString *goods_id;
/** 商店名称  */
@property (nonatomic,strong)NSString *shop_name;
/** 限购ID  */
@property (nonatomic,strong)NSString *scare_buying_id;
/** 库存ID  */
@property (nonatomic,strong)NSString *goods_stock_id;
/** 库存名称  */
@property (nonatomic,strong)NSString *goods_stock_name;
/** 用户限购数量  */
@property (nonatomic,strong)NSString *user_scare_buying_number;


- (instancetype)initWithDict:(NSDictionary*)dict;
@end
