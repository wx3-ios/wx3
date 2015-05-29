//
//  WXMenuSqlite.m
//  Woxin2.0
//
//  Created by le ting on 8/8/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXMenuSqlite.h"
#import "MenuItemDef.h"
#import "WXSqliteItem.h"
//#import "NSObject+SBJson.h"
#import "WXSqlite.h"

#define kMenuSqlName @"menu"

typedef enum {
    E_MenuItem_UID = 0,//菜单的标示符~
    E_MenuItem_SubShopID,//分店ID
    E_MenuItem_SubShopName,//分店名称
    E_MenuItem_SubItems,//所有的商品或套餐~
    E_MenuItem_Time,//菜单生成时间~
    E_MenuItem_MenuType,//菜单的类型~
    E_MenuItem_Name,//姓名
    E_MenuItem_Phone,//电话号码
    E_MenuItem_Address,//地址
    E_MenuItem_Remark,//备注
    
    E_MenuItem_Invalid,
}E_MenuItem;

const static S_WXSqliteItem menuItemArray [E_MenuItem_Invalid] = {
    {kPrimaryKey,E_SQLITE_DATA_INT,1},
    {kMenuItemSubShopID,E_SQLITE_DATA_INT,0},
    {kSubShopName,E_SQLITE_DATA_TXT,0},
    {kSubItems,E_SQLITE_DATA_TXT,0},
    {kTime,E_SQLITE_DATA_INT,0},
    {kMenuType,E_SQLITE_DATA_INT,0},
    {kName,E_SQLITE_DATA_TXT,0},
    {kPhone,E_SQLITE_DATA_TXT,0},
    {kAddress,E_SQLITE_DATA_TXT,0},
    {kRemark,E_SQLITE_DATA_TXT,0},
};

@implementation WXMenuSqlite

+ (WXMenuSqlite*)sharedMenuSqlite{
    static dispatch_once_t onceToken;
    static WXMenuSqlite * sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXMenuSqlite alloc] init];
        if([sharedInstance createMenuTable]){
            KFLog_Normal(YES, @"创建菜单表单成功");
        }else{
            KFLog_Normal(YES, @"创建菜单表单失败");
        }
    });
    return sharedInstance;
}

- (NSString*)currentMenuSqlName{
    return kMenuSqlName;
}

//获取初始化的sqliteItem
- (WXSqliteItem*)menuSqlItemFor:(E_MenuItem)colIndex{
    S_WXSqliteItem sItem = menuItemArray[colIndex];
    WXSqliteItem *item = [WXSqliteItem itemWithSqliteItemStruct:sItem];
    return item;
}

- (NSArray *)menuSqlItemArray{
    NSMutableArray *itemArray = [NSMutableArray array];
    for(E_MenuItem eItem = E_MenuItem_UID; eItem < E_MenuItem_Invalid; eItem++){
        WXSqliteItem *item = [self menuSqlItemFor:eItem];
        [itemArray addObject:item];
    }
    return itemArray;
}

- (BOOL)createMenuTable{
    NSArray *itemArray = [self menuSqlItemArray];
    return [[WXSqlite sharedSqlite] createSqliteTable:[self currentMenuSqlName] itemArray:itemArray];
}

- (WXSqliteItem*)sqliteItemWithInteger:(NSInteger)number menuItemIndex:(E_MenuItem)index{
    WXSqliteItem *sqlItem = [self menuSqlItemFor:index];
    sqlItem.data = [NSNumber numberWithInt:(int)number];
    return sqlItem;
}

- (WXSqliteItem*)sqliteItemWithTxt:(NSString*)txt menuItemIndex:(E_MenuItem)index{
    WXSqliteItem *sqlItem = [self menuSqlItemFor:index];
    if(!txt){
        txt = @"";
    }
    sqlItem.data = txt;
    return sqlItem;
}

- (NSArray*)sqliteArrayWithSubShopID:(NSInteger)subShopID subShopName:(NSString*)subShopName json:(NSString*)json createTime:(NSInteger)time menuType:(E_MenuType)menuType name:(NSString*)name
   phone:(NSString*)phone address:(NSString*)address remark:(NSString*)remark{
    
    NSMutableArray *itemArray = [NSMutableArray array];
    WXSqliteItem *item = [self sqliteItemWithInteger:subShopID menuItemIndex:E_MenuItem_SubShopID];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:subShopName menuItemIndex:E_MenuItem_SubShopName];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:json menuItemIndex:E_MenuItem_SubItems];
    [itemArray addObject:item];
    item = [self sqliteItemWithInteger:time menuItemIndex:E_MenuItem_Time];
    [itemArray addObject:item];
    item = [self sqliteItemWithInteger:menuType menuItemIndex:E_MenuItem_MenuType];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:name menuItemIndex:E_MenuItem_Name];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:phone menuItemIndex:E_MenuItem_Phone];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:address menuItemIndex:E_MenuItem_Address];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:remark menuItemIndex:E_MenuItem_Remark];
    [itemArray addObject:item];
    return itemArray;
}

- (NSArray*)sqliteItemFromMenuItem:(MenuItem*)menuItem{
    NSString *json = [menuItem menuSubItemJson];
    NSArray *itemArray = [self sqliteArrayWithSubShopID:menuItem.extra.subShopID subShopName:menuItem.extra.subShopName json:json createTime:menuItem.extra.time menuType:menuItem.extra.menuType name:menuItem.extra.name phone:menuItem.extra.phoneNumber address:menuItem.extra.address remark:menuItem.extra.remark];
    return itemArray;
}

- (NSInteger)insertMenuItem:(MenuItem*)menuItem{
    if(!menuItem){
        return -1;
    }
    NSArray *itemArray = [self sqliteItemFromMenuItem:menuItem];
    return [[WXSqlite sharedSqlite] insertTable:[self currentMenuSqlName] itemDataArray:itemArray];
}

- (BOOL)updateMenuItem:(MenuItem*)menuItem{
    NSArray *itemArray = [self sqliteItemFromMenuItem:menuItem];
    WXSqliteItem *item = [self menuSqlItemFor:E_MenuItem_UID];
    item.data = [NSNumber numberWithInteger:menuItem.extra.UID];
    return [[WXSqlite sharedSqlite] updateData:[self currentMenuSqlName] primaryItem:item itemArray:itemArray];
}

- (BOOL)saveMenuItem:(MenuItem*)menuItem{
    if(menuItem.extra.UID >= 0){
        return [self updateMenuItem:menuItem];
    }else{
        return [self insertMenuItem:menuItem];
    }
}

- (BOOL)deleteMenuArray:(NSInteger*)UIDArray rowNumber:(NSInteger)number{
    return [[WXSqlite sharedSqlite] deleteTableName:[self currentMenuSqlName] PrimaryIDArray:UIDArray rowNumber:number];
}

- (NSArray*)loadAllMenu{
    NSArray *itemArray = [self menuSqlItemArray];
    NSArray * dataArray = [[WXSqlite sharedSqlite] loadData:[self currentMenuSqlName] itemArray:itemArray];
    NSMutableArray *mutArray = [NSMutableArray array];
    for(NSDictionary*dic in dataArray){
        MenuItem *item = [MenuItem menuItemWithDictionary:dic];
        if(item){
            [mutArray addObject:item];
        }
    }
    return mutArray;
}
@end