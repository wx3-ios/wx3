//
//  AboutShopEntity.h
//  Woxin2.0
//
//  Created by qq on 14-8-19.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutShopEntity : NSObject
@property (nonatomic,strong) NSString *seller_name;
@property (nonatomic,strong) NSString *seller_desc;
@property (nonatomic,strong) NSString *smallImg;
@property (nonatomic,retain) NSArray *imgArr;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *address;

+ (AboutShopEntity *)shopInfoEntityWithDic:(NSDictionary *)shopDic;

@end
