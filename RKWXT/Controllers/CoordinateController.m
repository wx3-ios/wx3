//
//  CoordinateController.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CoordinateController.h"
#import "LoginVC.h"
#import "ContactDetailVC.h"
#import "SignViewController.h"
#import "RechargeVC.h"
#import "WXTCartDetailViewController.h"
#import "WXTGoodsDetailViewController.h"
#import "WXTOrderConfirmViewController.h"
@implementation CoordinateController

+ (CoordinateController*)sharedCoordinateController{
    static dispatch_once_t onceToken;
    static CoordinateController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoordinateController alloc] init];
    });
    return sharedInstance;
}

- (void)toContactDetail:(id)sender contactInfo:(id)contactInfo contactType:(E_ContacterType)contactType animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    ContactDetailVC * contactInfoVC = [[ContactDetailVC alloc] init];
    [vc.wxNavigationController pushViewController:contactInfoVC];
}

-(void)toSignVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    SignViewController *signVC = [[SignViewController alloc] init];
    [vc.wxNavigationController pushViewController:signVC];
}

-(void)toRechargeVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    RechargeVC *rechargeVC = [[RechargeVC alloc] init];
    [vc.wxNavigationController pushViewController:rechargeVC];
}

- (void)toGoodsInfoVC:(id)sender goodInfo:(WXGoodEntity*)goodInfo animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    WXTGoodsDetailViewController *goodsInfoVC = [[WXTGoodsDetailViewController alloc] init] ;
//    [goodsInfoVC setGoodEntity:goodInfo];
    [vc.wxNavigationController pushViewController:goodsInfoVC];
}

//- (void)toOrderMenu:(id)sender source:(E_OrderMenuSource)source goodList:(NSArray*)goodList extra:(MenuExtra*)extra animated:(BOOL)animated{
//    WXUIViewController *vc = sender;
//    WXOrderMenuVC *orderVC = [[WXOrderMenuVC alloc] init] ;
//    [orderVC setSource:source];
//    if(source != E_OrderMenuSource_None){
//        [orderVC setOrderGoodList:goodList menuExtra:extra];
//    }
//    [vc.wxNavigationController pushViewController:orderVC];
//}

- (void)toOrderConfirm:(id)sender /*delegate:(id<OrderConfirmVCDelegate>)delegate source:(E_OrderMenuSource)source
              goodList:(NSArray*)goodList goodExtra:(MenuExtra*)extra*/animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    WXTOrderConfirmViewController *orderConfirmVC = [[WXTOrderConfirmViewController alloc] init];
//    [orderConfirmVC setDelegate:delegate];
//    [orderConfirmVC setAllGoodChose:goodList];
//    [orderConfirmVC setMenuGoodsExtra:extra];
//    [orderConfirmVC setMenuSource:source];
    [vc.wxNavigationController pushViewController:orderConfirmVC];
}

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

- (void)toCartDetail:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    WXTCartDetailViewController * cartDetailVC = [[WXTCartDetailViewController alloc]init];
    [vc.wxNavigationController pushViewController:cartDetailVC];
}

@end
