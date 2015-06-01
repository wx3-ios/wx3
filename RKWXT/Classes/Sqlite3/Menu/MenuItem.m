//
//  MenuItem.m
//  Woxin2.0
//
//  Created by le ting on 8/8/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "MenuItem.h"
#import "WXUIGoodEntity.h"
#import "WXUIPacketGoodEntity.h"
#import "WXGoodListModel.h"
#import "SetMealEntity.h"
#import "SqliteDef.h"


@implementation MenuSubItem
- (void)dealloc{
//    [super dealloc];
}

+ (MenuSubItem*)menuSubItemWithDictionary:(NSDictionary*)dic{
    return [[self alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        NSInteger categoryType = [[dic objectForKey:D_MenuSubItemCategoryType] integerValue];
        NSInteger subItemGoodID = [[dic objectForKey:D_MenuSubItemGoodID] integerValue];
        NSInteger  number = [[dic objectForKey:D_MenuSubItemNumber] integerValue];
        NSString *subShopName = [dic objectForKey:D_MenuSubItemName];
        [self  setCategoryType:(E_GoodType)categoryType];
        [self setGoodID:subItemGoodID];
        [self setNumber:number];
        [self setName:subShopName];
    }
    return self;
}

- (NSDictionary*)convertToDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:_categoryType] forKey:D_MenuSubItemCategoryType];
    [dic setObject:[NSNumber numberWithInteger:_goodID] forKey:D_MenuSubItemGoodID];
    [dic setObject:[NSNumber numberWithInteger:_number] forKey:D_MenuSubItemNumber];
    if(!_name){
        _name = @"";
    }
    [dic setObject:_name forKey:D_MenuSubItemName];
    return dic;
}

- (CGFloat)price{
    CGFloat price = 0.0;
    if(_categoryType == E_CategoryType_Good){
        WXGoodEntity *entity = [[WXGoodListModel sharedGoodListModel] goodsOfID:_goodID];
        price = entity.shopPrice;
    }else{
        SetMealEntity *entity = [[WXGoodListModel sharedGoodListModel] packetGoodOfID:_goodID];
        price = entity.price;
    }
    return price;
}

@end

@implementation MenuItem

- (void)dealloc{
    RELEASE_SAFELY(_menuSubItemArray);
    RELEASE_SAFELY(_extra);
    [super dealloc];
}

+ (MenuItem*)menuItemWithDictionary:(NSDictionary*)dic{
    return [[[self alloc] initWithDictionary:dic] autorelease];
}

- (id)initWithDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        self.extra = [[[MenuExtra alloc] init] autorelease];
        NSInteger UID = [[dic objectForKey:kPrimaryKey] integerValue];
        [self.extra setUID:UID];
        NSInteger subShopID = [[dic objectForKey:kMenuItemSubShopID] integerValue];
        [self.extra setSubShopID:subShopID];
        NSString *subShopName = [dic objectForKey:kSubShopName];
        [self.extra setSubShopName:subShopName];
        NSString *json = [dic objectForKey:kSubItems];
        [self setMenuSubItemArray:[self goodsArrayFromJson:json]];
        NSInteger time = [[dic objectForKey:kTime] integerValue];
        [self.extra setTime:time];
        NSInteger menuType = [[dic objectForKey:kMenuType] integerValue];
        [self.extra setMenuType:(E_MenuType)menuType];
        NSString *name = [dic objectForKey:kName];
        [self.extra setName:name];
        NSString *phone = [dic objectForKey:kPhone];
        [self.extra setPhoneNumber:phone];
        NSString *address = [dic objectForKey:kAddress];
        [self.extra setAddress:address];
        NSString *remark = [dic objectForKey:kRemark];
        [self.extra setRemark:remark];
    }
    return self;
}

- (NSArray*)goodsArrayFromJson:(NSString*)json{
    NSArray *dicArray = [json JSONValue];
    if(!dicArray){
        KFLog_Normal(YES, @"解析json数据失败");
        return nil;
    }
    NSMutableArray *mutArray = [NSMutableArray array];
    for(NSDictionary *dic in dicArray){
        MenuSubItem *item = [MenuSubItem menuSubItemWithDictionary:dic];
        if(dic){
            [mutArray addObject:item];
        }
    }
    return mutArray;
}

- (NSArray*)uiGoodList{
    NSMutableArray *goodList = [NSMutableArray array];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(MenuSubItem *subItem in _menuSubItemArray){
        if(subItem.categoryType == E_CategoryType_Good){
            WXGoodEntity *goodEntity = [[WXGoodListModel sharedGoodListModel] goodsOfID:subItem.goodID];
            if(goodEntity){
                WXUIGoodEntity *uiGoodEntity = [[[WXUIGoodEntity alloc] init] autorelease];
                uiGoodEntity.numberChose = subItem.number;
                [uiGoodEntity setGoodEntity:goodEntity];
                [goodList addObject:uiGoodEntity];
            }
        }
    }
    [pool drain];
    return goodList;
}

- (NSArray*)uiPacketGoodList{
    NSMutableArray *packetGoodList = [NSMutableArray array];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(MenuSubItem *subItem in _menuSubItemArray){
        if(subItem.categoryType == E_CategoryType_PacketGood){
            SetMealEntity *packetGoodEntity = [[WXGoodListModel sharedGoodListModel] packetGoodOfID:subItem.goodID];
            if(packetGoodEntity){
                WXUIPacketGoodEntity *uiPacketGoodEntity = [[[WXUIPacketGoodEntity alloc] init] autorelease];
                uiPacketGoodEntity.numberChose = subItem.number;
                [uiPacketGoodEntity setPacketGoodEntity:packetGoodEntity];
                [packetGoodList addObject:uiPacketGoodEntity];
            }
        }
    }
    [pool drain];
    return packetGoodList;
}

- (void)setUiGoodList:(NSArray *)uiGoodList uiPacketGoodList:(NSArray*)uiPacketGoodList{
    NSMutableArray *menuSubItemArray = [NSMutableArray array];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(WXUIGoodEntity *uiGoodEntity in uiGoodList){
        MenuSubItem *subItem = [[[MenuSubItem alloc] init] autorelease];
        [subItem setName:uiGoodEntity.goodEntity.name];
        [subItem setNumber:uiGoodEntity.numberChose];
        [subItem setCategoryType:E_CategoryType_Good];
        [subItem setGoodID:uiGoodEntity.goodEntity.goodID];
        [menuSubItemArray addObject:subItem];
    }
    
    for(WXUIPacketGoodEntity *uiPacketGoodEntity in uiPacketGoodList){
        MenuSubItem *subItem = [[[MenuSubItem alloc] init] autorelease];
        [subItem setName:uiPacketGoodEntity.packetGoodEntity.name];
        [subItem setNumber:uiPacketGoodEntity.numberChose];
        [subItem setCategoryType:E_CategoryType_PacketGood];
        [subItem setGoodID:uiPacketGoodEntity.packetGoodEntity.UID];
        [menuSubItemArray addObject:subItem];
    }
    [pool drain];
    [self setMenuSubItemArray:menuSubItemArray];
}

- (CGFloat)sumPrice{
    CGFloat sumPrice = 0.0;
    for(MenuSubItem *subItem in _menuSubItemArray){
        E_GoodType type = subItem.categoryType;
        CGFloat price = 0.0;
        if(type == E_CategoryType_Good){
            WXGoodEntity *goodEntity = [[WXGoodListModel sharedGoodListModel] goodsOfID:subItem.goodID];
            if(goodEntity){
                price = goodEntity.shopPrice;
            }
        }else{
            SetMealEntity *packetGood = [[WXGoodListModel sharedGoodListModel] packetGoodOfID:subItem.goodID];
            if(packetGood){
                price = packetGood.price;
            }
        }
        sumPrice += price*subItem.number;
    }
    return sumPrice;
}

- (NSInteger)sumNumber{
    NSInteger sum = 0;
    for(MenuSubItem *subItem in _menuSubItemArray){
        sum += subItem.number;
    }
    return sum;
}

- (NSString*)menuSubItemJson{
    NSMutableArray *subItemDicArray = [NSMutableArray array];
    for(MenuSubItem *subItem in _menuSubItemArray){
		//数目为0的话不加载~
		if (subItem.number <= 0){
			continue;
		}
        NSDictionary *subItemDic = [subItem convertToDictionary];
        if(subItemDic){
            [subItemDicArray addObject:subItemDic];
        }
    }
    return [subItemDicArray JSONRepresentation];
}

- (NSArray*)allGoodsAndPackets{
    NSMutableArray *allGoods = [NSMutableArray array];
    [allGoods addObjectsFromArray:self.uiGoodList];
    [allGoods addObjectsFromArray:self.uiPacketGoodList];
    return allGoods;
}

- (NSMutableDictionary*)orderConfirmLibJson{
    NSMutableArray *goodDicArray = [NSMutableArray array];
    for(MenuSubItem *subItem in _menuSubItemArray){
        E_GoodType goodType = subItem.categoryType;
        NSString *type = [NSString stringWithFormat:@"%d",goodType+1];
        NSString *goodIDStr = [NSString stringWithFormat:@"%d",(int)subItem.goodID];
        NSString *numberStr = [NSString stringWithFormat:@"%d",(int)subItem.number];
        if(subItem.number > 0){
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",goodIDStr,@"id",numberStr,@"num", nil];
            [goodDicArray addObject:dic];
        }
    }
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:goodDicArray,@"data", nil];
    [jsonDic setObject:[NSString stringWithFormat:@"%d",(int)goodDicArray.count] forKey:@"count"];
    //菜单类型
    NSString *menuTypeStr = [NSString stringWithFormat:@"%d",_extra.menuType +1];
    [jsonDic setObject:menuTypeStr forKey:@"order_type"];
    [jsonDic setObject:_extra.phoneNumber forKey:@"phone"];
    [jsonDic setObject:_extra.subShopName forKey:@"shop_name"];
    [jsonDic setObject:_extra.name forKey:@"name"];
    [jsonDic setObject:_extra.remark forKey:@"remark"];
    [jsonDic setObject:_extra.address forKey:@"address"];
	return jsonDic;
}
@end
