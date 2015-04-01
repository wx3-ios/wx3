//
//  WXService.m
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXService.h"
#import "WXServiceParse.h"
#import "ServiceMonitor.h"
//#import "OpenUDID.h"

#define D_ServiceLog_Open

@interface WXService()
{
    BOOL _bInLogOut;
}
@end

@implementation WXService

+ (WXService*)sharedService{
    static dispatch_once_t onceToken;
    static WXService *sharedService = nil;
    dispatch_once(&onceToken, ^{
        sharedService = [[WXService alloc] init];
    });
    return sharedService;
}

- (BOOL)initServerLib{
    NSString *logPath = [self logPath];
    SS_SHORT ret = IT_InitConfig("2", (char *)[logPath cStringUsingEncoding:NSUTF8StringEncoding]);
    if(SS_SUCCESS != ret){
        KFLog_Normal(YES, @"it_initConfig failed");
        return NO;
    }else{
        KFLog_Normal(YES, @"it_initConfig succeed");
    }
    
    ret = IT_Init();
    if (SS_SUCCESS != ret){
        KFLog_Normal(YES, @"it_init failed");
        return NO;
    }else{
        KFLog_Normal(YES,@"it_init succeed");
    }
    
    ret = IT_SetCallBack(IT_CallBack);
    if(SS_SUCCESS != ret){
        KFLog_Normal(YES, @"IT_SetCallBack failed");
        return NO;
    }else{
        KFLog_Normal(YES, @"IT_SetCallBack succeed");
    }
	
	KFLog_Normal(YES, @"service address = %@",D_ServerAddress);
#ifndef D_ServerAddressUseDefault
    [self setServerIp:D_ServerAddress];
#endif
	
	NSString *woxinID = [WXUserOBJ sharedUserOBJ].woxinID;
	if (woxinID != nil){
		IT_SetWoXinID([woxinID UTF8String]);
		IT_ConnectDB((char*)[[self dbPath] UTF8String]);
	}
	IT_SetSellerID(kMerchantID);
	
    if (SS_SUCCESS != IT_Start()){
        KFLog_Normal(YES, @"it start failed")
        return NO;
    }else{
        KFLog_Normal(YES, @"it start succeed");
    }
    
    if([self updateDBDir]){
        KFLog_Normal(YES, @"update dir succeed");
    }else{
        KFLog_Normal(YES, @"update dir failed");
    }
    
    NSString *iconDir = [self iconDir];
    
    if(IT_SetIconPath((char*)[iconDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0){
        KFLog_Normal(YES, @"设置图片位置失败");
    }else{
        KFLog_Normal(YES, @"设置图片位置成功");
    }
    
    return YES;
}

- (void)setLogOpen:(BOOL)bOpen{
    if(bOpen){
        IT_LogScreenDisplay(SS_TRUE);
    }else{
        IT_LogScreenDisplay(SS_FALSE);
    }
}

- (void)setServerIp:(NSString*)serverIP{
    IT_SetServerIP([serverIP UTF8String]);
}

- (NSString*)logPath{
    NSString *docDir = [UtilTool documentPath];
    NSString *logPath = [NSString stringWithFormat:@"%@/itlog",docDir];
    return logPath;
}

- (NSString*)dbDir{
    NSString *docDir = [UtilTool documentPath];
    NSString *dbDir = [NSString stringWithFormat:@"%@/DB",docDir];
    return dbDir;
}

- (NSString*)dbPath{
	NSString *dbDir = [self dbDir];
	NSString *woxinID = [WXUserOBJ sharedUserOBJ].woxinID;
	return [NSString stringWithFormat:@"%@/%@.db",dbDir,woxinID];
}

- (BOOL)updateDBDir{
    NSString *dbDir = [self dbDir];
    SS_SHORT ret = IT_UpdateDBPath((char*)[dbDir UTF8String]);
    if(ret != SS_SUCCESS){
        return NO;
    }
    return YES;
}

#pragma mark InterfaceOut
//获取验证码
- (NSInteger)fetchAuthCode:(NSString*)user error:(WXError**)error{
    SS_SHORT ret = IT_GetPhoneCheckCode([user UTF8String]);
	return ret;
}

//注册
- (NSInteger)registerUser:(NSString*)user merchantID:(NSInteger)merchantID password:(NSString*)password authCode:(NSString*)authCode error:(WXError**)error{
    SS_SHORT ret = IT_Register((SS_UINT32)merchantID,[user UTF8String], [password UTF8String], [authCode UTF8String]);
    return ret;
}
//注销
- (NSInteger)unRegisterUser:(NSString*)user merchantID:(NSInteger)merchantID password:(NSString*)password error:(WXError**)errror{
    if(![[ServiceMonitor sharedServiceMonitor] canUnregister]){
        return 0;
    }
    SS_SHORT ret = IT_Unregister((SS_UINT32)merchantID,[user UTF8String], [password UTF8String]);
	if(ret == 0){
		[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_UnRegisterBegin object:nil];
	}
	return ret;
}

//登陆
- (NSInteger)login:(NSString*)user password:(NSString*)password erorr:(WXError**)error{
    if(![[ServiceMonitor sharedServiceMonitor] canLoginNow]){
        return 0;
    }
    
//    NSString *openUDID = [OpenUDID value];
//    KFLog_Normal(YES, @"openUDID = %@",openUDID);
//    SS_SHORT ret = IT_Login(kMerchantID, E_DeviceType_IOS, [user UTF8String], [password UTF8String], [openUDID cStringUsingEncoding:NSUTF8StringEncoding]);
//    if(ret == 0){
//        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoginBegin object:nil];
//    }
//	[self setHasCalledLogin:YES];
    return 1;
}

//退出登陆
- (NSInteger)logout:(NSString*)user password:(NSString*)password error:(WXError**)error{
    SS_SHORT ret = IT_Logout(kMerchantID,[user UTF8String], [password UTF8String]);
    if(ret == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LogoutBegin object:nil];
		[self setHasCalledLogin:NO];
    }
    return ret;
}

//修改密码
- (NSInteger)updateUser:(NSString*)user oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword error:(WXError**)erorr{
    SS_SHORT ret = IT_UpdatePassword([user UTF8String], [oldPassword UTF8String], [newPassword UTF8String]);
	return ret;
}
//找回密码
- (NSInteger)findPassword:(NSString*)user phoneNumber:(NSString*)phoneNumber error:(WXError**)erorr{
    SS_SHORT ret =  IT_FindPassword(kMerchantID, [user UTF8String], [phoneNumber UTF8String]);
	return ret;
}

#pragma mark CallBack
SS_SHORT IT_CallBack(
         IN SS_UINT32 const un32MSGID,
         IN SS_CHAR **pParam,
         IN SS_UINT32 const un32ParamNumber){
	SS_UINT32 un32=0;
	for (un32=0;un32<un32ParamNumber;un32++){
		printf("%s",pParam[un32]);
//        KFLog_Normal(YES, @"====== MSGID=%u,Param[%u]=%s",un32MSGID,un32,pParam[un32]);
	}
    if(un32ParamNumber <= 0){
        KFLog_Normal(YES, @"cell back 返回一个空值");
        return SS_SUCCESS;
    }
    
    NSString *notificationName = nil;
    id object = nil;
    [[WXServiceParse sharedWXServiceParse] parseMessageID:un32MSGID pParam:pParam paramNumber:un32ParamNumber notificationName:&notificationName notificationObject:&object];
    if(notificationName){
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:notificationName object:object userInfo:nil];
    }
    return  SS_SUCCESS;
}
@end
