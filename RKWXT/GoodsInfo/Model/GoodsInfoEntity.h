//
//  GoodsInfoEntity.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfoEntity : NSObject
@property (nonatomic,assign) NSInteger goods_id;      //商品id
@property (nonatomic,retain) NSString *intro;         //商品介绍
@property (nonatomic,retain) NSString *name;          //商品名
@property (nonatomic,retain) NSString *img;           //顶部图片
@property (nonatomic,assign) CGFloat market_price;    //市场价
@property (nonatomic,assign) CGFloat shop_price;      //店铺价
@property (nonatomic,assign) CGFloat distribution_Price;   //分销价
@property (nonatomic,retain) NSString *meterage_name; //商家名
@property (nonatomic,assign) NSInteger concernID;     //为0则未关注

@property (nonatomic,strong) NSString *customKey;     //通用参数key
@property (nonatomic,strong) NSString *customValue;   //通用参数value

@property (nonatomic,assign) BOOL selested;
@property (nonatomic,assign) NSInteger buyNumber;

//@property (nonatomic,strong) NSString *

@end
