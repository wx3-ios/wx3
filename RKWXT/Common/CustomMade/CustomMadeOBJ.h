//
//  CustomMadeOBJ.h
//  Woxin2.0
//
//  Created by Elty on 10/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	E_App_Category_Eatable = 0,//餐饮类~
	E_App_Category_Public,//大众版
}E_App_Category;

typedef enum {
	E_APP_Type_Personal = 1, //个人版本
	E_APP_Type_Store,//商家版
	E_APP_Type_Company,//企业版
}E_App_Type;

@interface CustomMadeOBJ : NSObject

+ (CustomMadeOBJ*)sharedCustomMadeOBJS;
- (NSInteger)merchantID;//商家ID
- (E_App_Type)appType;//1:个人版 2:商家版 3:企业版
- (NSString*)merchantName;//商家名称
- (NSInteger)certificationType;//证书类型~ 1:开发证书  2:发布证书
- (NSString *)serverAddress; //服务器的地址~
- (E_App_Category)appCategory;//app分类~
- (BOOL)isDistributeServerAddressOld;//地址是否为老服务器的地址~
//当app分类为大众版的时候~ 分店ID和区域ID才有用~
- (NSInteger)subShopID;
- (NSInteger)areaID;

#pragma mark 引导页~
- (BOOL)isGuideEnabled;
- (NSInteger)guidePage;

#pragma mark 注册和登录~
- (BOOL)isRegAndLoginBagEnabled;
- (NSInteger)regAndLoginColorEnum;

//其他颜色~
- (NSInteger)otherColorEnum;
@end
