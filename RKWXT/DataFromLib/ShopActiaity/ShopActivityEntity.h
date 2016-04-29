//
//  ShopActivityEntity.h
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ShopActivityType_Default = 0,
    ShopActivityType_IsPosgate,
    ShopActivityType_Reduction
}ShopActivityType;

@interface ShopActivityEntity : NSObject
+ (instancetype)shareShopActionEntity;
@property (nonatomic,assign)CGFloat postage;
@property (nonatomic,copy) NSString *fullReduction;
@property (nonatomic,assign)CGFloat full;
@property (nonatomic,assign)CGFloat action;
@property (nonatomic,assign)ShopActivityType type; // 0.没有活动 1.满多少包邮  2.满减
+ (instancetype)shopActivityEntityWithDic:(NSDictionary*)dic;
@end
