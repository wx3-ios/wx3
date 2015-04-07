//
//  CoordinateController.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CoordinateController.h"
//#import "RegisterVC.h"
#import "LoginVC.h"
//#import "WXAllFriendVC.h"
#import "ContactDetailVC.h"
//#import "PersonalInfoViewController.h"
//#import "MoreFunctionVC.h"
//#import "WXOrderMenuVC.h"
//#import "OrderConfirmVC.h"
//#import "BranchOfficeVC.h"
//#import "WXMenuVC.h"
//#import "WXMenuVC.h"
//#import "GoodsInfoVC.h"
//#import "SysMsgVC.h"
//#import "SysMsgDetailVC.h"
//#import "MyOrderListVC.h"
//#import "WXMenuDetailVC.h"
//#import "WXMenuDetailVC.h"
//#import "WXGuideVC.h"
//#import "ShopDetailVC.h"
//#import	"SubShopVC.h"
//#import "AboutShopInfoVC.h"
//#import "TopWebAdvVC.h"

//#import "RefundVC.h"
//#import "OrderListVC.h"
//#import "OrderPayVC.h"
//#import "OrderDtailVC.h"
//#import "RefundStatusVC.h"

@implementation CoordinateController

+ (CoordinateController*)sharedCoordinateController{
    static dispatch_once_t onceToken;
    static CoordinateController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoordinateController alloc] init];
    });
    return sharedInstance;
}

//+ (WXUINavigationController*)sharedNavigationController{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    WXUINavigationController *navigationController = appDelegate.navigationController;
//    return navigationController;
//}

//- (void)toLogin:(id)sender animated:(BOOL)animated completion:(void (^)())completion{
//    WXUIViewController *vc = sender;
//    LoginVC *logVC = [[[LoginVC alloc] init] autorelease];
//	[logVC setBWithOutGuide:YES];
//    WXUINavigationController *nav = [[[WXUINavigationController alloc] initWithRootViewController:logVC] autorelease];
//    [vc presentViewController:nav animated:YES completion:^{
//        completion();
//    }];
//}

//- (void)toRegisterVC:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    RegisterVC *regVC = [[[RegisterVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:regVC];
//}

//- (void)toChooseSubShopVC:(id)sender animated:(BOOL)animated{
//	WXUIViewController *vc = sender;
//	SubShopVC *subShopVC = [[[SubShopVC alloc] init] autorelease];
//	[vc.wxNavigationController pushViewController:subShopVC];
//}

//- (void)toBranceOfficeVC:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    BranchOfficeVC *brance = [[[BranchOfficeVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:brance];
//}

//- (void)toCallTabBarVC:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXCallUITabBarVC *callTabBarVC = [[[WXCallUITabBarVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:callTabBarVC];
//}

- (void)toContactDetail:(id)sender contactInfo:(id)contactInfo contactType:(E_ContacterType)contactType animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    ContactDetailVC * contactInfoVC = [[ContactDetailVC alloc] init] ;
//    [contactInfoVC setContacterInfo:contactInfo];
//    [contactInfoVC setContacterType:contactType];
    [vc.wxNavigationController pushViewController:contactInfoVC];
}

//- (void)toAllWXContacters:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXAllFriendVC *allFriendVC = [[WXAllFriendVC alloc] init] ;
//    [vc.wxNavigationController pushViewController:allFriendVC];
//}

//- (void)toPersonalInfo:(id)sender animated:(BOOL)animate{
//    WXUIViewController *vc = sender;
//    PersonalInfoViewController *personalVC = [[PersonalInfoViewController alloc] init] ;
//    [vc.wxNavigationController pushViewController:personalVC];
//}

//- (void)toMoreFunction:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    MoreFunctionVC *personalVC = [[MoreFunctionVC alloc] init] ;
//    [vc.wxNavigationController pushViewController:personalVC];
//}

//- (void)toGoodsInfoVC:(id)sender goodInfo:(WXGoodEntity*)goodInfo animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    GoodsInfoVC *goodsInfoVC = [[GoodsInfoVC alloc] init] ;
//    [goodsInfoVC setGoodEntity:goodInfo];
//    [vc.wxNavigationController pushViewController:goodsInfoVC];
//}

//- (void)toOrderMenu:(id)sender source:(E_OrderMenuSource)source goodList:(NSArray*)goodList extra:(MenuExtra*)extra animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXOrderMenuVC *orderVC = [[WXOrderMenuVC alloc] init] ;
//    [orderVC setSource:source];
//    if(source != E_OrderMenuSource_None){
//        [orderVC setOrderGoodList:goodList menuExtra:extra];
//    }
//    [vc.wxNavigationController pushViewController:orderVC];
//}

//- (void)toOrderConfirm:(id)sender delegate:(id<OrderConfirmVCDelegate>)delegate source:(E_OrderMenuSource)source
//              goodList:(NSArray*)goodList goodExtra:(MenuExtra*)extra{
//    WXUIViewController *vc = sender;
//    OrderConfirmVC *orderConfirmVC = [[[OrderConfirmVC alloc] init] autorelease];
//    [orderConfirmVC setDelegate:delegate];
//    [orderConfirmVC setAllGoodChose:goodList];
//    [orderConfirmVC setMenuGoodsExtra:extra];
//    [orderConfirmVC setMenuSource:source];
//    [vc.wxNavigationController pushViewController:orderConfirmVC];
//}

//- (void)toMenu:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXMenuVC *menuVC = [[[WXMenuVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:menuVC];
//}

//- (void)toMenuDetail:(id)sender menuItem:(id)menuItem animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXMenuDetailVC *menuDetailVC = [[[WXMenuDetailVC alloc] init] autorelease];
//    [menuDetailVC setMenuItem:menuItem];
//    [vc.wxNavigationController pushViewController:menuDetailVC];
//}

//- (void)toSystemMessage:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    SysMsgVC *sysMsgVC = [[[SysMsgVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:sysMsgVC];
//}

//- (void)toSystemMessageDetail:(id)sender messageInfo:(id)info animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    SysMsgDetailVC *sysMsgDetailVC = [[[SysMsgDetailVC alloc] init] autorelease];
//    [sysMsgDetailVC setSysMsgDetailInfo:info];
//    [vc.wxNavigationController pushViewController:sysMsgDetailVC];
//}

//- (void)toOrderList:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    OrderListVC *orderListVC = [[[OrderListVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:orderListVC];
//}

//- (void)toBranchOfficeInfo:(id)sender animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    ShopDetailVC *shopDetailVC = [[[ShopDetailVC alloc] init] autorelease];
//    [vc.wxNavigationController pushViewController:shopDetailVC];
//}

//- (void)toGuideView:(id)sender mode:(E_GuideView_Mode)mode animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXGuideVC *guideVC = [[[WXGuideVC alloc] init] autorelease];
//    [guideVC setMode:mode];
//    WXUINavigationController *nav = [[[WXUINavigationController alloc] initWithRootViewController:guideVC] autorelease];
//    [vc presentViewController:nav animated:animated completion:^{
//    }];
//}

//- (void)toShopDetail:(id)sender animated:(BOOL)animated{
//	WXUIViewController *vc = sender;
//	AboutShopInfoVC *shopDetailVC = [[[AboutShopInfoVC alloc] init] autorelease];
//	[shopDetailVC setFirstSelectedAtIndex:1];
//	[vc.wxNavigationController pushViewController:shopDetailVC completion:^{
//	}];
//}

//- (void)toTopWebAdv:(id)sender advInfo:(id)advInfo animated:(BOOL)animated{
//	WXUIViewController *vc = sender;
//	TopWebAdvVC *topWebVC = [[[TopWebAdvVC alloc] init] autorelease];
//	[topWebVC setTopAdvInfo:advInfo];
//	[vc.wxNavigationController pushViewController:topWebVC completion:^{
//	}];
//}

//- (void)toOrderPay:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
//	WXUIViewController *vc = sender;
//	OrderPayVC *orderPayVC = [[[OrderPayVC alloc] init] autorelease];
//	[orderPayVC setOrderEntity:orderInfo];
//	[vc.wxNavigationController pushViewController:orderPayVC completion:^{
//	}];
//}

//- (void)toRefund:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
//	WXUIViewController *vc = sender;
//	RefundVC *refundVC = [[[RefundVC alloc] init] autorelease];
//	[refundVC setOrderEntity:orderInfo];
//	[vc.wxNavigationController pushViewController:refundVC completion:^{
//	}];
//}

//- (void)toOrderDetail:(id)sender orderInfo:(id)orderInfo delegate:(id)delegate animated:(BOOL)animated{
//	WXUIViewController *vc = sender;
//	OrderDtailVC *orderDetailVC = [[[OrderDtailVC alloc] init] autorelease];
//	[orderDetailVC setOrderEntity:orderInfo];
//	[orderDetailVC setDelegate:delegate];
//	[vc.wxNavigationController pushViewController:orderDetailVC completion:^{
//	}];
//}

//- (void)toRefundDetail:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    RefundStatusVC *refundStatusVC = [[[RefundStatusVC alloc] init] autorelease];
//    [refundStatusVC setOrderEntity:orderInfo];
//    [vc.wxNavigationController pushViewController:refundStatusVC completion:^{
//    }];
//}

@end
