//
//  WXSqlite+shopCart.m
//  CallTesting
//
//  Created by le ting on 5/15/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXSqlite.h"
#import "ShopCartDefine.h"
#import "WXSqliteItem.h"

#define kWXShopCartTableName @"kWXShopCartTableName"
typedef enum{
    E_WXShopCart_ID = 0,
    //商品ID
    E_WXShopCart_GoodID,
    //商品的属性
    E_WXShopCart_GoodAttribute,
    //商品的数目
    E_WXShopCart_GoodNumber,
    
    E_WXShopCart_Invalid,
}E_ShopCartItem;

const static S_WXSqliteItem sqliteItemArray[E_WXShopCart_Invalid] = {
    {kPrimaryKey,E_SQLITE_DATA_INT,1},
    {kCartGoodID,E_SQLITE_DATA_INT,0},
    {kCartGoodAttribute,E_SQLITE_DATA_TXT,0},
    {kCartGoodNumber,E_SQLITE_DATA_INT,0},
};


@implementation WXSqlite (shopCart)

- (NSString*)shopCartTableNmae{
    return kWXShopCartTableName;
}

//获取初始化的sqliteItem
- (WXSqliteItem*)shopCartSqliteItemFor:(E_ShopCartItem)colIndex{
    S_WXSqliteItem sItem = sqliteItemArray[colIndex];
    WXSqliteItem *item = [WXSqliteItem itemWithSqliteItemStruct:sItem];
    return item;
}

- (NSArray *)shopCartsqliteItemArray{
    NSMutableArray *itemArray = [NSMutableArray array];
    for(E_ShopCartItem eItem = E_WXShopCart_ID; eItem < E_WXShopCart_Invalid; eItem++){
        WXSqliteItem *item = [self shopCartSqliteItemFor:eItem];
        [itemArray addObject:item];
    }
    return itemArray;
}

- (BOOL)createShopCartTable{
    NSArray *itemArray = [self shopCartsqliteItemArray];
    return [self createSqliteTable:[self shopCartTableNmae] itemArray:itemArray];
}

- (NSArray*)sqlItemArrayWithGoodID:(NSInteger)goodID goodAttribute:(NSString*)attribute  goodNumber:(NSInteger)goodNumber{
    NSMutableArray *itemArray = [NSMutableArray array];
    WXSqliteItem *item = [self shopCartSqliteItemFor:E_WXShopCart_GoodID];
    item.data = [NSNumber numberWithInt:(int)goodID];
    [itemArray addObject:item];
    
    if(attribute){
        item = [self shopCartSqliteItemFor:E_WXShopCart_GoodAttribute];
        item.data = attribute;
        [itemArray addObject:item];
    }
    item = [self shopCartSqliteItemFor:E_WXShopCart_GoodNumber];
    item.data = [NSNumber numberWithInteger:goodNumber];
    [itemArray addObject:item];
    return itemArray;
}

- (BOOL)insertGoodID:(NSInteger)goodID goodAttribute:(NSString*)attribute goodNumber:(NSInteger)goodNumber{
    NSArray *itemArray = [self sqlItemArrayWithGoodID:goodID goodAttribute:attribute goodNumber:goodNumber];
    return [self insertTable:[self shopCartTableNmae] itemDataArray:itemArray];
}

- (BOOL)updateGoodID:(NSInteger)goodID goodAttribute:(NSString*)attribute  goodNumber:(NSInteger)goodNumber
                wherePrimaryID:(NSInteger)primaryID{
    NSArray *itemArray = [self sqlItemArrayWithGoodID:goodID goodAttribute:attribute goodNumber:goodNumber];
    WXSqliteItem *item = [self shopCartSqliteItemFor:E_WXShopCart_ID];
    item.data = [NSNumber numberWithInt:(int)primaryID];
    
    return [self updateData:[self shopCartTableNmae] primaryItem:item itemArray:itemArray];
}

//删除row 以primary定位
- (BOOL)deleteShopCartArray:(NSInteger*)primaryArray rowNumber:(NSInteger)number{
    return [self deleteTableName:[self shopCartTableNmae] PrimaryIDArray:primaryArray rowNumber:number];
}

- (NSArray*)loadAllShopCartData{
    NSArray *itemArray = [self shopCartsqliteItemArray];
    return [self loadData:[self shopCartTableNmae] itemArray:itemArray];
}
@end
