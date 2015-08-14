//
//  LuckyGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuckyGoodsEntity : NSObject
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CGFloat price;

+(LuckyGoodsEntity*)initLuckyGoodsWithDic:(NSDictionary*)dic;

@end
