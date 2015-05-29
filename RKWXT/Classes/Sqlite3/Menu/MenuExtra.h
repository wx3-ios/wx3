//
//  MenuExtra.h
//  Woxin2.0
//
//  Created by le ting on 8/11/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItemDef.h"

#define kInvalidMenuItemUID (-1)

@interface MenuExtra : NSObject
@property (nonatomic,assign)NSInteger UID; //菜单的标示符~
@property (nonatomic,assign)NSInteger subShopID;//分店ID
@property (nonatomic,retain)NSString *subShopName;//分店名称

@property (nonatomic,assign)NSInteger time; //菜单生成时间~
@property (nonatomic,assign)E_MenuType menuType;//菜单的类型~
@property (nonatomic,retain)NSString *name;//姓名
@property (nonatomic,retain)NSString *phoneNumber; //电话号码
@property (nonatomic,retain)NSString *address; //地址
@property (nonatomic,retain)NSString *remark;
@property (nonatomic,readonly)NSString *menuTypeDesc;

+ (MenuExtra*)menuExtraWithExtra:(MenuExtra*)extra;
@end