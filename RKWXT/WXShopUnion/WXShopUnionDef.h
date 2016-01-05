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
#import "LMHomeHotGoodsCell.h"

#import "WXShopUnionModel.h"
#import "LMHomeMoreHotGoodsModel.h"
#import "ShopUnionClassifyEntity.h"
#import "ShopUnionHotGoodsEntity.h"
#import "ShopUnionHotShopEntity.h"

#import "LMSearchListVC.h"
#import "LMSellerClassifyVC.h"
#import "LMSellerListVC.h"
#import "LMGoodsInfoVC.h"
#import "LMCollectionVC.h"
#import "LMHomeOrderVC.h"
#import "LMShoppingCartVC.h"
#import "LMSellerInfoVC.h"

#define Size self.bounds.size
#define ShopUnionClassifyRowHeight (165)
#define ShopUnionActivityRowHeight (115)

#define ShopUnionHotShopTextHeight (40)
#define ShopUnionHotShopListHeight (125)

#define ShopUnionHotGoodsTextHeight (40)
#define ShopUnionHotGoodsListHeight (222)

//商家联盟首页section
enum{
    ShopUnion_Section_Classify = 0,
//    ShopUnion_Section_Activity,
    ShopUnion_Section_HotShop,
    ShopUnion_Section_HotGoods,
    
    ShopUnion_Section_Invalid,
};

enum{
    ShopUnionDownView_UserOrder = 0,
    ShopUnionDownView_UserStore,
    ShopUnionDownView_UserShoppingCar,
    
    ShopUnionDownView_Invalid,
};

#endif /* WXShopUnionDef_h */
