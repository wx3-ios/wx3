//
//  MerchantID.h
//  RKWXT
//
//  Created by app on 15/11/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeShopData;
@interface MerchantID : NSObject
@property (nonatomic,strong)NSString *goods_id; //
@property (nonatomic,strong)NSString *goods_stock_id; //
@property (nonatomic,strong)NSString *is_delete; //
@property (nonatomic,strong)NSString *scare_buying_id; //
@property (nonatomic,strong)NSString *seller_user_id; //
@property (nonatomic,strong)NSString *shop_id; //
@property (nonatomic,strong)NSMutableArray *dataArray;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
