//
//  WXTURLFeedOBJ.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLFeedData.h"

typedef enum {
    WXT_UrlFeed_Type_LoadBalance = 0,
    WXT_UrlFeed_Type_Recharge,
    WXT_UrlFeed_Type_Sign,
    WXT_UrlFeed_Type_Login,
    WXT_UrlFeed_Type_Regist,
    WXT_UrlFeed_Type_FetchPwd,
    WXT_UrlFeed_Type_GainNum,
    WXT_UrlFeed_Type_Version,
    WXT_UrlFeed_Type_Call,
    WXT_UrlFeed_Type_HungUp,
    WXT_UrlFeed_Type_ResetPwd,
    
    WXT_UrlFeed_Type_NewMall_TopImg,
    WXT_UrlFeed_Type_NewMall_Recommond,
    WXT_UrlFeed_Type_NewMall_Nav,
    WXT_UrlFeed_Type_NewMal_LimitBuy,
    WXT_UrlFeed_Type_NewMall_Theme,
    WXT_UrlFeed_Type_NewMall_Surprise,
    WXT_UrlFeed_Type_NewMall_CatagaryList,
    WXT_UrlFeed_Type_NewMall_GoodsInfo,
    WXT_UrlFeed_Type_NewMall_ImgAndText,
    WXT_UrlFeed_Type_NewMall_ShoppingCart,
    WXT_UrlFeed_Type_NewMall_UserAddress,
    WXT_UrlFeed_Type_NewMall_MakeOrder,
    WXT_UrlFeed_Type_New_UserBonus,
    WXT_UrlFeed_Type_New_GainBonus,
    WXT_UrlFeed_Type_New_LoadUserBonus,
    WXT_UrlFeed_Type_New_OrderList,
    WXT_UrlFeed_Type_New_DealOrderList,
    WXT_UrlFeed_Type_New_Code,
    WXT_UrlFeed_Type_New_ResetNewPwd,
    WXT_UrlFeed_Type_New_Refund,
    WXT_UrlFeed_Type_New_RefundInfo,
    WXT_UrlFeed_Type_New_UpdapaOrderID,
    WXT_UrlFeed_Type_New_AboutShop,
    WXT_UrlFeed_Type_New_Version,
    WXT_UrlFeed_Type_New_Balance,
    WXT_UrlFeed_Type_New_JPushMessageInfo,
    WXT_UrlFeed_Type_New_Call,
    WXT_UrlFeed_Type_New_Sign,
    WXT_UrlFeed_Type_New_PersonalInfo,
    WXT_UrlFeed_Type_New_Recharge,
    WXT_UrlFeed_Type_New_Wechat,
    WXT_UrlFeed_Type_New_UserCut,
    WXT_UrlFeed_Type_New_RechargeList,
    WXT_UrlFeed_Type_New_LuckyGoodsList,
    WXT_UrlFeed_Type_New_LuckyShark,
    WXT_UrlFeed_Type_New_SharkNumber,
    WXT_UrlFeed_Type_New_LuckyMakeOrder,
    WXT_UrlFeed_Type_New_LuckyOrderList,
    WXT_UrlFeed_Type_New_LoadJPushMessage,
    WXT_UrlFeed_Type_New_CompleteLuckyOrder,
    WXT_UrlFeed_Type_New_SharedSucceed,
    WXT_UrlFeed_Type_New_UpdateUserHeader,
    WXT_UrlFeed_Type_New_LoadUserHeader,
    //提成
    WXT_UrlFeed_Type_New_LoadMyCutInfo,
    WXT_UrlFeed_Type_New_LoadMyClientPerson,
    WXT_UrlFeed_Type_New_LoadMyClientInfo,
    WXT_UrlFeed_Type_New_LoadUserAliAccount,
    WXT_UrlFeed_Type_New_SubmitUserAliAcount,
    WXT_UrlFeed_Type_New_ApplyAliMoney,
    WXT_UrlFeed_Type_New_LoadAliRecordList,
    WXT_UrlFeed_Type_New_UserCutSource,
    
    //分类
    WXT_UrlFeed_Type_New_LoadClassifyData,
    WXT_UrlFeed_Type_New_LoadClassifyGoodsList,
    WXT_UrlFeed_Type_New_SearchGoods,
    
    //地址
    WXT_UrlFeed_Type_New_CheckAreaVersion,
    WXT_UrlFeed_Type_New_LoadAreaData,
    WXT_UrlFeed_Type_NewMall_NewUserAddress,
    WXT_UrlFeed_Type_New_SearchCarriageMoney,
    WXT_UrlFeed_Type_New_NewMakeOrder,
    WXT_UrlFeed_Type_New_LimitBuyMakeOrder,
    
    //限时购
    WXT_UrlFeed_Type_TimeToBuy,
    //单个商品
    WXT_UrlFeed_Type_SingleTimeGoods,
    
    //收藏
    WXT_UrlFeed_Type_New_PayAttention,
    
     //商家个人中心
    WXT_UrlFeed_Type_Store_Center,
    
    //商家联盟
    WXT_UrlFeed_Type_Home_ShopUnion,
    
    WXT_UrlFeed_Type_Invalid,
}WXT_UrlFeed_Type;

@interface WXTURLFeedOBJ : NSObject
+ (WXTURLFeedOBJ*)sharedURLFeedOBJ;
- (NSString*)rootURL:(WXT_UrlFeed_Type)type;
- (NSString*)urlRequestParamFrom:(NSDictionary*)dic;
@end

typedef enum{
    WXT_HttpMethod_Get = 0, //GET
    WXT_HttpMethod_Post,  //POST
}WXT_HttpMethod;

#define K_URLFeedOBJ_Data_Code @"error"
#define K_URLFeedOBJ_Data_ErrorDesc @"msg"
#define K_URLFeedOBJ_Data_Content @"data"
