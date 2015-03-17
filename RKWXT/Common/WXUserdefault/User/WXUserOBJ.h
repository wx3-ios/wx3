//
//  WXUserOBJ.h
//  CallTesting
//
//  Created by le ting on 5/9/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

//默认的密码
#define kDefaultPwd @"123456"

#define kInvalidShopAboutID (-1)

#import <Foundation/Foundation.h>

@interface WXUserOBJ : NSObject

+ (WXUserOBJ*)sharedUserOBJ;

- (void)setWoxinID:(NSString*)wxID;//设置我信ID
- (void)setUser:(NSString*)user;//设置账号
- (void)setPWD:(NSString*)pwd;//设置密码
- (void)setAutoLoad:(BOOL)autoLoad;//设置是否自动登陆
- (void)setRemPWD:(BOOL)remPWD;//设置是否记住密码
- (NSString*)woxinID;//我信ID
- (NSString*)user;//用户~
- (NSString*)pwd;//密码~
- (int)autoLoad;//是否自动登陆~
- (BOOL)remPWD;//是否记住密码~

- (void)removeUserInfo;//移除账号信息
- (void)mergeUserInfo;//合并用户信息

#pragma mark 商家属性~
- (void)setSubShopID:(NSInteger)subShopID; //设置分店ID
- (NSInteger)subShopID;//获取分店ID
- (void)setAreaID:(NSInteger)areaID;//设置地区ID
- (NSInteger)areaID; //获取地区ID
- (void)setSubShopName:(NSString*)subShopName;
- (NSString*)subShopName;
- (void)setSubCityName:(NSString *)subCityName;
- (NSString *)subCityName;

//清楚登陆消息
- (void)removeLoginInfo;

#pragma 功能待定~
#pragma mark 商家用户set方法
- (void)setSubAgentAcronymName:(NSString*)subAgentAcronymName;
- (void)setSubAgentName:(NSString*)subAgentName;
- (void)setSubAgentID:(NSInteger)subAgentID;
- (void)setAuthority:(NSInteger)iAuthority;
- (void)setGeneralAgency:(BOOL)bGeneralAgency;

#pragma mark 商家用户 get方法
//商家缩写
- (NSString*)subAgentAcronymName;
- (NSString*)subAgentName;
- (NSInteger)subAgentID;
- (NSInteger)iAuthority;
- (BOOL)isGeneralAgency;
@end
