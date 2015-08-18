//
//  LuckySharkEntity.h
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuckySharkEntity : NSObject
@property (nonatomic,assign) NSInteger goods_id;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) CGFloat goods_price;
@property (nonatomic,assign) CGFloat market_price;
@property (nonatomic,assign) CGFloat shop_price;
@property (nonatomic,assign) NSInteger stock_id;
@property (nonatomic,assign) NSInteger shop_id;
@property (nonatomic,assign) NSInteger lottery_id;

+(LuckySharkEntity*)initWidthLuckySharkEntityWidthDic:(NSDictionary*)dic;

@end
