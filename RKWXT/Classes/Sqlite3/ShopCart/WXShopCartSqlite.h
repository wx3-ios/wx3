//
//  WXShopCartSqlite.h
//  CallTesting
//
//  Created by le ting on 5/15/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXBaseSqlite.h"

@class WXShopCartEntity;
@interface WXShopCartSqlite : WXBaseSqlite

//加载所有的数据
- (NSArray*)loadAllShopCartData;
//插入数据
- (NSInteger)insertShopCartData:(WXShopCartEntity*)entity;
//更新数据
- (BOOL)updateShopCartData:(WXShopCartEntity*)entity;
//删除数据
- (BOOL)deleteShopCartDataArray:(NSArray*)array;
@end
