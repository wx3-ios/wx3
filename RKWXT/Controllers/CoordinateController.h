//
//  CoordinateController.h
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    E_ContacterType_System = 0,//系统用户
    E_ContacterType_WoXin,//我信用户～
    E_ContacterType_Stranger,//陌生人~
}E_ContacterType;

typedef enum {
    E_OrderMenuSource_None,//没有来源
    E_OrderMenuSource_Menu,//来源于菜单~
    E_OrderMenuSource_Order,//来源于订单
    E_OrderMenuSource_Good,//来源于单个商品~
    
    E_OrderMenuSource_Invalid,
}E_OrderMenuSource;

typedef enum {
    E_GuideView_Mode_Register = 0,
    E_GuideView_Mode_Scane
}E_GuideView_Mode;

@class MenuExtra;
@class WXGoodEntity;
@protocol OrderConfirmVCDelegate;
@interface CoordinateController : NSObject

+ (CoordinateController*)sharedCoordinateController;
+ (WXUINavigationController*)sharedNavigationController;

- (void)toLogin:(id)sender animated:(BOOL)animated completion:(void (^)())completion;//登陆页面
- (void)toRegisterVC:(id)sender animated:(BOOL)animated;//注册页面
- (void)toChooseSubShopVC:(id)sender animated:(BOOL)animated;//选择分店的新接口
- (void)toBranceOfficeVC:(id)sender animated:(BOOL)animated;//选择分店
- (void)toCallTabBarVC:(id)sender animated:(BOOL)animated;
- (void)toContactDetail:(id)sender contactInfo:(id)contactInfo contactType:(E_ContacterType)contactType animated:(BOOL)animated;//联系人详情
- (void)toAllWXContacters:(id)sender animated:(BOOL)animated;//to所有联系人~
- (void)toPersonalInfo:(id)sender animated:(BOOL)animated;//个人信息
- (void)toMoreFunction:(id)sender animated:(BOOL)animated;//更多
- (void)toOrderMenu:(id)sender source:(E_OrderMenuSource)source goodList:(NSArray*)goodList extra:(MenuExtra*)extra animated:(BOOL)animated;//订餐
- (void)toOrderConfirm:(id)sender /*delegate:(id<OrderConfirmVCDelegate>)delegate source:(E_OrderMenuSource)source
              goodList:(NSArray*)goodList goodExtra:(MenuExtra*)extra*/animated:(BOOL)animated;//订单确认页面
- (void)toMenu:(id)sender animated:(BOOL)animated;//菜单
- (void)toMenuDetail:(id)sender menuItem:(id)menuItem animated:(BOOL)animated;//订单详情
- (void)toGoodsInfoVC:(id)sender goodInfo:(WXGoodEntity*)goodInfo animated:(BOOL)animated;//商品详情
- (void)toSystemMessage:(id)sender animated:(BOOL)animated;//系统推送信息
- (void)toSystemMessageDetail:(id)sender messageInfo:(id)info animated:(BOOL)animated;//系统信息详情
- (void)toBranchOfficeInfo:(id)sender animated:(BOOL)animated;//店铺详情
- (void)toGuideView:(id)sender mode:(E_GuideView_Mode)mode animated:(BOOL)animated;//引导页面
- (void)toShopDetail:(id)sender animated:(BOOL)animated;//去商店详情
- (void)toTopWebAdv:(id)sender advInfo:(id)advInfo animated:(BOOL)animated;//首页顶部web广告~
- (void)toOrderPay:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated;//付款
- (void)toRefund:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated;//退款~
- (void)toOrderDetail:(id)sender orderInfo:(id)orderInfo delegate:(id)delegate animated:(BOOL)animated;//订单详情
- (void)toRefundDetail:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated;//退款详情
//new
-(void)toSignVC:(id)sender animated:(BOOL)animated;//签到
-(void)toRechargeVC:(id)sender animated:(BOOL)animated;//充值
-(void)toCartDetail:(id)sender animated:(BOOL)animated;// 购物车
-(void)toOrderList:(id)sender selectedShow:(NSInteger)number animated:(BOOL)animated;//订单页面
-(void)toGoodsInfoVC:(id)sender goodsID:(NSInteger)goodsID animated:(BOOL)animated;//商品详情
@end
