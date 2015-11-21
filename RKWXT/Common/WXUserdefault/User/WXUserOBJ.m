//
//  WXUserOBJ.m
//  CallTesting
//
//  Created by le ting on 5/9/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUserOBJ.h"

@implementation WXUserOBJ

+ (WXUserOBJ*)sharedUserOBJ{
    static dispatch_once_t onceToken;
    static WXUserOBJ *sharedUserOBJ = nil;
    dispatch_once(&onceToken, ^{
        sharedUserOBJ = [[WXUserOBJ alloc] init];
    });
    return sharedUserOBJ;
}

- (void)setWoxinID:(NSString*)wxID{
	WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
	[userDefault setObject:wxID forKey:D_WXUserdefault_Key_tWoxinID];
}

- (void)setUser:(NSString*)user{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:user forKey:D_WXUserdefault_Key_tUser];
}

- (void)setPWD:(NSString*)pwd{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:pwd forKey:D_WXUserdefault_Key_tPWD];
}

- (void)setAutoLoad:(BOOL)autoLoad{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:autoLoad forKey:D_WXUserdefault_Key_iLoadType];
}

- (void)setRemPWD:(BOOL)remPWD{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:remPWD forKey:D_WXUserdefault_Key_bRememberPWD];
}

- (void)setSubAgentAcronymName:(NSString*)subAgentAcronymName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:subAgentAcronymName forKey:D_WXUserdefault_Key_tAgentAcronymName];
}
- (void)setSubAgentName:(NSString*)subAgentName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:subAgentName forKey:D_WXUserdefault_Key_tAgentName];
}
- (void)setSubAgentID:(NSInteger)subAgentID{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:subAgentID forKey:D_WXUserdefault_Key_iSubAgentID];
}

- (void)setSubCityName:(NSString *)subCityName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:subCityName forKey:D_WXUserdefault_Key_iSubCityName];
}

- (void)setAuthority:(NSInteger)iAuthority{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:iAuthority forKey:D_WXUserdefault_Key_iAuthority];
}

- (void)setGeneralAgency:(BOOL)bGeneralAgency{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:bGeneralAgency forKey:D_WXUserdefault_Key_bGeneralAgency];
}

-(void)setUserLocationCity:(NSString *)cityName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:cityName forKey:D_WXUserdefault_Location_City];
}

-(void)setUserLocationArea:(NSString *)areaName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:areaName forKey:D_WXUserdefault_Location_Area];
}

-(void)setUserLocationLatitude:(CGFloat)latitude{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setFloat:latitude forkey:D_WXUserdefault_Location_Latitude];
}

-(void)setUserLocationLongitude:(CGFloat)longitude{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setFloat:longitude forkey:D_WXUserdefault_Location_Longitude];
}

- (NSString*)woxinID{
	WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
	return [userDefault textValueForKey:D_WXUserdefault_Key_tWoxinID];
}

- (NSString*)user{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Key_tUser];
}
- (NSString*)pwd{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Key_tPWD];
}
- (int)autoLoad{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return (int)[userDefault integerValueForKey:D_WXUserdefault_Key_iLoadType];
}

- (BOOL)remPWD{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bRememberPWD];
}

- (void)removeUserInfo{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault removeObjectForKey:D_WXUserdefault_Key_tUser];
    [userDefault removeObjectForKey:D_WXUserdefault_Key_tPWD];
    [userDefault removeObjectForKey:D_WXUserdefault_Key_iLoadType];
    [userDefault removeObjectForKey:D_WXUserdefault_Key_bRememberPWD];
	[userDefault removeObjectForKey:D_WXUserdefault_Key_tWoxinID];
}

- (void)removeLoginInfo{
    [self setUser:nil];
    [self setPWD:nil];
    [self setAutoLoad:NO];
    [self setSubShopID:kInvalidShopAboutID];
    [self setAreaID:kInvalidShopAboutID];
    [self setSubShopName:nil];
    [self setSubCityName:nil];
}

- (void)setSubShopID:(NSInteger)subShopID{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:subShopID forKey:D_WXUserDefault_Key_iSubShopID];
}

- (NSInteger)subShopID{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
	NSInteger subShopID = [userDefault integerValueForKey:D_WXUserDefault_Key_iSubShopID];
    return subShopID;
}


- (void)setAreaID:(NSInteger)areaID{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:areaID forKey:D_WXUserDefault_Key_iAreaID];

}

- (void)setSubShopName:(NSString*)subShopName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:subShopName forKey:D_WXUserDefault_Key_tSubShopName];
}

- (NSString*)subShopName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserDefault_Key_tSubShopName];
}

- (NSString *)subCityName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Key_iSubCityName];
}

- (NSInteger)areaID{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
	NSInteger areaID = [userDefault integerValueForKey:D_WXUserDefault_Key_iAreaID];
    return areaID;
}

- (NSString*)subAgentAcronymName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Key_tAgentAcronymName];
}

- (NSString*)subAgentName{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Key_tAgentName];
}
- (NSInteger)subAgentID{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault integerValueForKey:D_WXUserdefault_Key_iSubAgentID];
}

- (NSInteger)iAuthority{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault integerValueForKey:D_WXUserdefault_Key_iAuthority];
}

- (BOOL)isGeneralAgency{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bGeneralAgency];
}

-(NSString*)userLocationCity{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Location_City];
}

-(NSString*)userLocationArea{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:D_WXUserdefault_Location_Area];
}

-(CGFloat)userLocationLatitude{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault floatValueForKey:D_WXUserdefault_Location_Latitude];
}

-(CGFloat)userLocationLongitude{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault floatValueForKey:D_WXUserdefault_Location_Longitude];
}

//合并账号信息
- (void)mergeUserInfo{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    
    //账户 D_WXUserdefault_Key_tUser @"UserIDKey"
    BOOL hasNewUserKey = [userDefault hasKey:D_WXUserdefault_Key_tUser];
    //如果没有新的userKey 则需要转移user
    NSString *oldUserKey = @"UserIDKey";
    if(!hasNewUserKey){
        NSString *oldUser = [userDefault textValueForKey:oldUserKey];
        if(oldUser){
            [userDefault setObject:oldUser forKey:D_WXUserdefault_Key_tUser];
        }
    }
    //移除旧的user key
    [userDefault removeObjectForKey:oldUserKey];
    
    //密码 D_WXUserdefault_Key_tPWD  @"Password"
    BOOL hasNewPWDKey = [userDefault hasKey:D_WXUserdefault_Key_tPWD];
    NSString *oldPWDKey = @"Password";
    if(!hasNewPWDKey){
        NSString *oldPWD = [userDefault textValueForKey:oldPWDKey];
        if(oldPWD){
            [userDefault setObject:oldPWD forKey:D_WXUserdefault_Key_tPWD];
        }
    }
    [userDefault removeObjectForKey:oldPWDKey];
    
    //自动登陆 D_WXUserdefault_Key_iLoadType @"Up_ok"
    BOOL hasNewAutoLoadKey = [userDefault hasKey:D_WXUserdefault_Key_iLoadType];
    NSString *oldAutoLoadKey = @"Up_ok";
    if(!hasNewAutoLoadKey){
        NSInteger autoLoad = [userDefault integerValueForKey:oldAutoLoadKey];
        if(autoLoad){
            [userDefault setInteger:autoLoad forKey:D_WXUserdefault_Key_iLoadType];
        }
    }
    [userDefault removeObjectForKey:oldAutoLoadKey];
}
@end
