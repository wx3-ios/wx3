//
//  WXShopUnionDef.h
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#ifndef WXShopUnionDef_h
#define WXShopUnionDef_h

#import "WXShopCityListVC.h"
#import "LocalAreaModel.h"
#import "UserLocation.h"
#import "WXShopUnionAreaView.h"
#import "MJRefresh.h"
#import "WXTUITextField.h"

#import "ShopUnionClassifyCell.h"
#import "WXShopUnionActivityCell.h"
#import "WXShopUnionHotShopTitleCell.h"
#import "WXShopUnionHotShopCell.h"
#import "WXShopUnionHotGoodsTitleCell.h"
#import "WXShopUnionHotGoodsCell.h"

#import "WXShopUnionModel.h"

#import "LMSearchListVC.h"

#define Size self.bounds.size
#define ShopUnionClassifyRowHeight (165)
#define ShopUnionActivityRowHeight (115)

#define ShopUnionHotShopTextHeight (25)
#define ShopUnionHotShopListHeight (125)

#define ShopUnionHotGoodsTextHeight (25)
#define ShopUnionHotGoodsListHeight (115)

//商家联盟首页section
enum{
    ShopUnion_Section_Classify = 0,
    ShopUnion_Section_Activity,
    ShopUnion_Section_HotShop,
    ShopUnion_Section_HotGoods,
    
    ShopUnion_Section_Invalid,
};

enum{
    ShopUnionClassify_Hot = 0,
    ShopUnionClassify_Dress,
    ShopUnionClassify_Food,
    ShopUnionClassify_Furniture,
    ShopUnionClassify_Service,
    
    ShopUnionClassify_Invalid,
};

enum{
    ShopUnionDownView_UserOrder = 0,
    ShopUnionDownView_UserStore,
    ShopUnionDownView_UserShoppingCar,
    
    ShopUnionDownView_Invalid,
};

#endif /* WXShopUnionDef_h */
