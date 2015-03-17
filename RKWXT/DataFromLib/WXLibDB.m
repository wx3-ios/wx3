//
//  WXLibDB.m
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXLibDB.h"
#import "WXContactMonitor.h"
#import "CallRecord.h"
#import "WXGoodListModel.h"
#import "MyOrderListObj.h"
#import "PersonalDataObj.h"
#import "WXToken.h"
#import "WXGoodCategoryModel.h"
#import "MyOrderListObj.h"
#import "AboutShopObj.h"
#import "PersonalDataObj.h"

#import "RedPacket.h"
#import "RedPacketBalance.h"
#import "RedPacketRule.h"
#import "ShopInfo.h"

#import "NewHomePageVC.h"

@implementation WXLibDB


+ (WXLibDB*)sharedWXLibDB{
    static dispatch_once_t onceToken;
    static WXLibDB *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXLibDB alloc] init];
    });
    return sharedInstance;
}

- (void)loadLibDB{
    [[WXGoodListModel sharedGoodListModel] loadALL]; //加载所有商品列表~
	[[WXGoodCategoryModel sharedGoodCategoryModel] loadGoodCategaryList];//记载分类列表~
	
	[[RedPacketBalance sharedRedPacketBalance] loadRedPacketBalance];//加载红包余额~
	[[RedPacket sharedRedPacket] loadRedPacket];//加载红包~
	[[RedPacketRule sharedRedPacketRule] loadRedPacketRule];//加载红包规则~
	[[ShopInfo sharedShopInfo] loadShopInfo]; //加载店铺信息 （用户营业时间）
	
    [[PersonalDataObj sharePersonalInfoModel] loadPersonalInfo]; //加载个人信息
    //上传token
    [[WXToken sharedToken] setConnected:YES];
    [[WXToken sharedToken] setNeedSendToken];
    
    [[WXContactMonitor sharedWXContactMonitor] loadWXContacter];//加载woxin联系人~
    [[AddressBook sharedAddressBook] uploadSysContacters];//上传通讯录~
    [[CallRecord sharedCallRecord] loadRecord];             //加载通话记录~
    
    [[NewHomePageVC sharedHomePageVC] loadWxHomePageData];
}

- (void)removeLibDB{
    [[WXContactMonitor sharedWXContactMonitor] removeWXContacter];
    [[CallRecord sharedCallRecord] removeCallRecorder];
    [[WXGoodListModel sharedGoodListModel] removeALL];
    //设置token需要重新上传~
    [[WXToken sharedToken] setNeedResendToken];
    [[WXGoodCategoryModel sharedGoodCategoryModel] removeALL];
    [[MyOrderListObj sharedOrderList] removeOrderList];
    [[PersonalDataObj sharePersonalInfoModel] toInit];
	[[RedPacketBalance sharedRedPacketBalance] toInit];
	[[RedPacket sharedRedPacket] toInit];
	[[ShopInfo sharedShopInfo] toInit];
}

- (void)changeSubShop{
	[[ShopInfo sharedShopInfo] toInit];
	[[RedPacketRule sharedRedPacketRule] toInit];//去掉红包规则
    [[WXGoodCategoryModel sharedGoodCategoryModel] removeALL];//去掉所有的商品分类
    [[WXGoodListModel sharedGoodListModel] removeALL];//移除所有商品
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_SubShopHasChanged object:nil];
    [[WXGoodListModel sharedGoodListModel] loadALL]; //加载所有商品列表~
    [[MyOrderListObj sharedOrderList] removeOrderList];   //清除订单列表
	[[ShopInfo sharedShopInfo] loadShopInfo]; //加载店铺信息 （用户营业时间）
}

@end
