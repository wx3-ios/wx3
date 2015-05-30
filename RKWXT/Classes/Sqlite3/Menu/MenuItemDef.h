//
//  Header.h
//  Woxin2.0
//
//  Created by le ting on 8/8/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#ifndef Woxin2_0_Header_h
#define Woxin2_0_Header_h

typedef enum {
    E_MenuType_FaceToFace = 0,//到店付
    E_MenuType_TakeOut, //外卖
    
    E_MenuType_Invalid,
}E_MenuType;

#define  kUID           @"kUID"//菜单的标示符~
#define  kMenuItemSubShopID     @"kSubShopID"//分店ID
#define  kSubShopName   @"kSubShopName"//分店的名称
#define  kSubItems      @"kSubItems"//所有的商品或套餐~
#define  kTime          @"kTime"//菜单生成时间~
#define  kMenuType      @"kMenuType"//菜单的类型~
#define  kName          @"kName"//姓名
#define  kPhone         @"kPhone" //电话号码
#define  kAddress       @"kAddress"//地址
#define  kRemark        @"kRemark"//备注

#define D_MenuSubItemCategoryType @"D_MenuSubItemCategoryType"
#define D_MenuSubItemGoodID @"D_MenuSubItemGoodID"
#define D_MenuSubItemNumber @"D_MenuSubItemNumber"
#define D_MenuSubItemName @"D_MenuSubItemName"

#endif