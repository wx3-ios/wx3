//
//  WXTUserOBJ.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KeychainItemWrapper;
@interface WXTUserOBJ : NSObject
@property (nonatomic, strong) KeychainItemWrapper * passwdKeyChainItem;
@property (nonatomic, strong) KeychainItemWrapper * userKeyChainItem;
+(WXTUserOBJ*)sharedUserOBJ;

-(void)setWxtID:(NSString*)wxtID;  //设置我信通ID
-(void)setUser:(NSString*)user;    //设置帐号
-(void)setPwd:(NSString*)pwd;      //设置密码
-(void)setToken:(NSString*)token;  //设置令牌
-(void)setSmsID:(int)smsID;        //验证码ID
-(void)setNickname:(NSString*)nickname; //昵称
-(void)setSellerID:(NSString*)sellerID; //商家主键ID
-(void)SetUserLoginFirst:(BOOL)first; //升级新商家临时记录

-(NSString*)wxtID;
-(NSString*)user;
-(NSString*)pwd;
-(NSString*)token;
-(int)smsID;
-(NSString*)nickname;
-(NSString*)sellerID;
-(BOOL)userFirstLogin;

-(void)removeAllUserInfo;

@end
