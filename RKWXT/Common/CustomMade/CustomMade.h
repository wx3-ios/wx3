//
//  CustomMade.h
//  Woxin2.0
//
//  Created by Elty on 10/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#ifndef Woxin2_0_CustomMade_h
#define Woxin2_0_CustomMade_h

#import "CustomMadeOBJ.h"

#define kMerchantName [CustomMadeOBJ sharedCustomMadeOBJS].merchantName //软件的名称
#define kAPPType [CustomMadeOBJ sharedCustomMadeOBJS].appType //app的类型~
#define kCertificationType [CustomMadeOBJ sharedCustomMadeOBJS].certificationType //证书类型
#define kMerchantID [CustomMadeOBJ sharedCustomMadeOBJS].merchantID   //商家ID
#define	kAppMode [CustomMadeOBJ sharedCustomMadeOBJS].appCategory //app分类~
#define	kIsAppModePublic ([CustomMadeOBJ sharedCustomMadeOBJS].appCategory == E_App_Category_Public) //是否为公众版
#define	kIsDistributeServiceAddressOld [CustomMadeOBJ sharedCustomMadeOBJS].isDistributeServerAddressOld//是否为老服务器~
#define	kSubShopID [CustomMadeOBJ sharedCustomMadeOBJS].subShopID //分店ID
#define	kAreaID [CustomMadeOBJ sharedCustomMadeOBJS].areaID //区域ID
#define	D_ServerAddress [CustomMadeOBJ sharedCustomMadeOBJS].serverAddress //服务器地址~

#pragma mark 引导页~
#define	kIsGuideEnabled [CustomMadeOBJ sharedCustomMadeOBJS].isGuideEnabled
#define kGuidePage	[CustomMadeOBJ sharedCustomMadeOBJS].guidePage

#pragma mark 注册和登录~
#define	kIsRegAndLoginBagEnabled [CustomMadeOBJ sharedCustomMadeOBJS].isRegAndLoginBagEnabled
#define	kRegAndLoginColorEnum [CustomMadeOBJ sharedCustomMadeOBJS].regAndLoginColorEnum

#pragma mark 侧边栏~
#define	kIsLeftSideBgEnabled [CustomMadeOBJ sharedCustomMadeOBJS].isLeftSideBgEnabled
#define	kLeftSideBgColorEnum [CustomMadeOBJ sharedCustomMadeOBJS].leftSideBgColorEnum
#endif
