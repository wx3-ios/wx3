//
//  MenuItem.h
//  Woxin2.0
//
//  Created by le ting on 8/8/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuExtra.h"

@interface MenuSubItem :NSObject
@property (nonatomic,retain)NSString *name;//商品名称
@property (nonatomic,assign)E_GoodType categoryType;//类型，是单点的菜品还是套餐~
@property (nonatomic,assign)NSInteger goodID;//商品ID
@property (nonatomic,assign)NSInteger number;//个数

+ (MenuSubItem*)menuSubItemWithDictionary:(NSDictionary*)dic;
- (NSDictionary*)convertToDictionary;
- (CGFloat)price;
@end

@interface MenuItem : NSObject
@property (nonatomic,retain)MenuExtra *extra;
@property (nonatomic,retain)NSArray *menuSubItemArray; //所有的商品或套餐~

@property (nonatomic,readonly)NSArray *uiGoodList;
@property (nonatomic,readonly)NSArray *uiPacketGoodList;

+ (MenuItem*)menuItemWithDictionary:(NSDictionary*)dic;
- (void)setUiGoodList:(NSArray *)uiGoodList uiPacketGoodList:(NSArray*)uiPacketGoodList;//保存的时候要转化为MenuItem
- (NSString*)menuSubItemJson;//所有商品的json数据
- (CGFloat)sumPrice; //总价格
- (NSInteger)sumNumber;//总份数
- (NSArray*)allGoodsAndPackets;//所有的商品 包括套餐
- (NSMutableDictionary*)orderConfirmLibJson; //调用lib接口的时候需要转化为json字符串
@end