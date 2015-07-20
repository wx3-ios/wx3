//
//  CustomMadeOBJ.m
//  Woxin2.0
//
//  Created by Elty on 10/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

typedef enum {
    E_Certificate_Type_Develop = 1,
    E_Certificate_Type_Ditribution = 2,
}E_Certificate_Type;

//typedef enum {
//    //可以购买的
//    E_Merchandise_CanBuy = 0,
//    //文化类
//    E_Merchandise_Cultures
//}E_MerchandiseType;

#define D_KEY_MERCHANTID        @"D_KEY_MERCHANTID"
#define D_KEY_APP_TYPE          @"D_KEY_APP_TYPE"
#define D_KEY_APP_MERCHANTNAME  @"D_KEY_APP_MERCHANTNAME"
#define D_KEY_CERTIFICATIONTYPE @"D_KEY_CERTIFICATIONTYPE"
#define D_KEY_APP_IS_SERVER_OLD @"D_KEY_APP_IS_SERVER_OLD"

#define D_KEY_APP_CATEGORY @"D_KEY_APP_CATEGORY"
#define D_KEY_APP_SUBSHOPID @"D_KEY_APP_SUBSHOPID"
#define D_KEY_APP_AREAID	@"D_KEY_APP_AREAID"
#define D_KEY_FIND_NAME    @"D_KEY_FIND_NAME"
#define D_KEY_FIND_SHOWNAV @"D_KEY_FIND_SHOWNAV"
#define D_KEY_SHOWCOMPANY @"D_KEY_SHOWCOMPANY"

#pragma mark 引导页
#define D_KEY_APP_GUIDE @"D_KEY_APP_GUIDE"
#define D_KEY_APP_GUIDE_ENABLE @"D_KEY_APP_GUIDE_ENABLE" //是否有引导页~
#define D_KEY_APP_GUIDE_PAGE @"D_KEY_APP_GUIDE_PAGE" //引导页的页数~

#pragma mark 注册和登录
#define D_KEY_LOG_REG	@"D_KEY_LOG_REG"
#define D_KEY_LOG_REG_BAG_ENABLE	@"D_KEY_LOG_REG_BAG_ENABLE"//注册和登录页面是否有背景图片~
#define D_KEY_LOG_REG_E_COLOR	@"D_KEY_LOG_REG_E_COLOR" //注册和登录页面的颜色枚举~

#define D_KEY_OTHER_COLOR @"D_KEY_OTHER_COLOR" //其他颜色的编号~
#import "CustomMadeOBJ.h"

@interface CustomMadeOBJ()
{
    NSDictionary *_customMadeDic;
}
@end


@implementation CustomMadeOBJ

- (void)dealloc{
//    [super dealloc];
}

+ (CustomMadeOBJ*)sharedCustomMadeOBJS{
    static dispatch_once_t onceToken;
    static CustomMadeOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CustomMadeOBJ alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CustomMade" ofType:@"plist"];
        _customMadeDic = [NSDictionary dictionaryWithContentsOfFile:path] ;
    }
    return self;
}

- (NSInteger)merchantID{
    NSInteger merchantID = [[_customMadeDic objectForKey:D_KEY_MERCHANTID] integerValue];
    KFLog_Normal(YES, @"merchantID = %d",(int)merchantID);
    return merchantID;
}

- (E_App_Type)appType{
    NSInteger appType = [[_customMadeDic objectForKey:D_KEY_APP_TYPE] integerValue];
    KFLog_Normal(YES, @"appType = %d",(int)appType);
    return appType;
}

- (NSString*)merchantName{
    NSString *merchantName = [_customMadeDic objectForKey:D_KEY_APP_MERCHANTNAME];
    KFLog_Normal(YES, @"merchantName = %@",merchantName);
    return merchantName;
}

- (NSInteger)certificationType{
    NSInteger certificationType = [[_customMadeDic objectForKey:D_KEY_CERTIFICATIONTYPE] integerValue];
    KFLog_Normal(YES, @"certificationType = %d",(int)certificationType);
    return certificationType;
}

- (E_App_Category)appCategory;{
	NSInteger appMode = [[_customMadeDic objectForKey:D_KEY_APP_CATEGORY] integerValue];
	return appMode;
}

- (NSInteger)subShopID{
	NSInteger subShopID = [[_customMadeDic objectForKey:D_KEY_APP_SUBSHOPID] integerValue];
	return subShopID;
}

- (NSInteger)areaID{
	NSInteger areaID = [[_customMadeDic objectForKey:D_KEY_APP_AREAID] integerValue];
	return areaID;
}

//发现栏名字
-(NSString*)findSignName{
    NSString *findName = [_customMadeDic objectForKey:D_KEY_FIND_NAME];
    KFLog_Normal(YES, @"findName = %@",findName);
    return findName;
}
//展示公司
-(NSInteger)showCompany{
    NSInteger show = [[_customMadeDic objectForKey:D_KEY_SHOWCOMPANY] integerValue];
    return show;
}

-(NSInteger)showFindNav{
    NSInteger show = [[_customMadeDic objectForKey:D_KEY_FIND_SHOWNAV] integerValue];
    return show;
}

- (BOOL)isDistributeServerAddressOld{
	BOOL isOld = [[_customMadeDic objectForKey:D_KEY_APP_IS_SERVER_OLD] boolValue];
	return isOld;
}

//- (NSString*)distributeAddress{
//	BOOL isDistributeServerAddressOld = [self isDistributeServerAddressOld];
//	if (isDistributeServerAddressOld){
//		return D_DistributeServerOldAddress;
//	}else {
//		return D_DistributeServerNewAddress;
//	}
//}

- (NSString *)serverAddress{
	NSString *serverAddress = nil;
//	switch (kAppServiceAddressType) {
//		case E_Distribute:
//			serverAddress = [self distributeAddress];
//			break;
//		case E_DistributeBeta:
//			serverAddress = D_DistributeBetaServerAddress;
//			break;
//		case E_Develop:
//			serverAddress = D_DevelopServiceAddress;
//			break;
//	}
	return serverAddress;
}



#pragma mark 引导页~
- (NSDictionary*)guideConfig{
	return [_customMadeDic objectForKey:@"D_KEY_APP_GUIDE"];
}

- (BOOL)isGuideEnabled{
	NSDictionary *guideConfig = [self guideConfig];
	return [[guideConfig objectForKey:D_KEY_APP_GUIDE_ENABLE] boolValue];
}

- (NSInteger)guidePage{
	NSDictionary *guideConfig = [self guideConfig];
	return [[guideConfig objectForKey:D_KEY_APP_GUIDE_PAGE] integerValue];
}
#pragma mark 注册和登录~
- (NSDictionary*)regAndLoginConfig{
	return [_customMadeDic objectForKey:D_KEY_LOG_REG];
}

- (BOOL)isRegAndLoginBagEnabled{
	NSDictionary *regAndLoginConfig = [self regAndLoginConfig];
	return [[regAndLoginConfig objectForKey:D_KEY_LOG_REG_BAG_ENABLE] boolValue];
}

- (NSInteger)regAndLoginColorEnum{
	NSDictionary *regAndLoginConfig = [self regAndLoginConfig];
	return [[regAndLoginConfig objectForKey:D_KEY_LOG_REG_E_COLOR] integerValue];
}

- (NSInteger)otherColorEnum{
	return [[_customMadeDic objectForKey:D_KEY_OTHER_COLOR] integerValue];
}

@end
