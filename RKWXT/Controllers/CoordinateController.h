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

//- (void)toCallTabBarVC:(id)sender animated:(BOOL)animated;
//- (void)toContactDetail:(id)sender contactInfo:(id)contactInfo contactType:(E_ContacterType)contactType animated:(BOOL)animated;//联系人详情

//new
-(void)toGuideView:(id)sender animated:(BOOL)animated;//引导页面
-(void)toSignVC:(id)sender animated:(BOOL)animated;//签到
-(void)toRechargeVC:(id)sender animated:(BOOL)animated;//充值
-(void)toOrderList:(id)sender selectedShow:(NSInteger)number animated:(BOOL)animated;//订单页面
-(void)toGoodsInfoVC:(id)sender goodsID:(NSInteger)goodsID animated:(BOOL)animated;//商品详情
-(void)toUserBonusVC:(id)sender animated:(BOOL)animated; //红包
-(void)toMakeOrderVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated; //下单
-(void)toOrderPayVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated; //支付
-(void)toRefundVC:(id)sender goodsInfo:(id)goodsInfo animated:(BOOL)animated;  //退款
-(void)toRefundInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated;//查看退款详情
-(void)toOrderInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated;//查看订单详情
-(void)toAboutShopVC:(id)sender animated:(BOOL)animated; //商家信息
-(void)toJPushCenterVC:(id)sender animated:(BOOL)animated; //消息中心
-(void)toJPushMessageInfoVC:(id)sender messageID:(NSInteger)messageID animated:(BOOL)animated; //消息详情
-(void)toWebVC:(id)sender url:(NSString*)webUrl title:(NSString*)title animated:(BOOL)animated; //跳转到网页
@end
