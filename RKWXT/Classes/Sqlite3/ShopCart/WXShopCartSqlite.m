//
//  WXShopCartSqlite.m
//  CallTesting
//
//  Created by le ting on 5/15/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXShopCartSqlite.h"
#import "ShopCartDefine.h"
#import "WXSqlite.h"
#import "WXShopCartEntity.h"

@implementation WXShopCartSqlite

+ (id)shared{
    static dispatch_once_t onceToken;
    static WXShopCartSqlite *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        [[WXSqlite sharedSqlite] createShopCartTable];
        sharedInstance = [[WXShopCartSqlite alloc] init];
    });
    return sharedInstance;
}

- (NSArray*)shopCartEntityFrom:(NSArray*)msgDicArray{
    NSMutableArray *array = [NSMutableArray array];
    
    for(NSDictionary *dic in msgDicArray){
        WXShopCartEntity *entity = [[WXShopCartEntity alloc] init];
        NSNumber *idPrimaryKey = [dic objectForKey:kPrimaryKey];
        if(idPrimaryKey){
            entity.primaryID = [idPrimaryKey integerValue];
        }
        
        NSNumber *idGoodID = [dic objectForKey:kCartGoodID];
        if(idGoodID){
            entity.goodID = [idGoodID integerValue];
        }
        
        NSString *attribute = [dic objectForKey:kCartGoodAttribute];
        entity.attribute = attribute;
        
        NSNumber *idNumber = [dic objectForKey:kCartGoodNumber];
        if(idNumber){
            entity.goodNumber = [idNumber integerValue];
        }
        [array addObject:entity];
    }
    return array;
}

//加载所有的数据
- (NSArray*)loadAllShopCartData{
    NSArray *msgDicArray = [[WXSqlite sharedSqlite] loadAllShopCartData];;
    return [self shopCartEntityFrom:msgDicArray];
}
//插入数据
- (NSInteger)insertShopCartData:(WXShopCartEntity*)entity{
    NSInteger msgUID = [[WXSqlite sharedSqlite] insertGoodID:entity.goodID goodAttribute:entity.attribute goodNumber:entity.goodNumber];
    return msgUID;
}

//更新数据
- (BOOL)updateShopCartData:(WXShopCartEntity*)entity{
    return [[WXSqlite sharedSqlite] updateGoodID:entity.goodID goodAttribute:entity.attribute goodNumber:entity.goodNumber wherePrimaryID:entity.primaryID];
}
//删除数据
- (BOOL)deleteShopCartDataArray:(NSArray*)array{
    NSInteger count = [array count];
    NSInteger primaryArray[count];
    memset(primaryArray, 0, sizeof(primaryArray));
    
    for(NSInteger index = 0; index < count; index++){
        WXShopCartEntity *entity = [array objectAtIndex:index];
        primaryArray[index] = entity.primaryID;
    }
    return [[WXSqlite sharedSqlite] deleteShopCartArray:primaryArray rowNumber:count];
}
@end
