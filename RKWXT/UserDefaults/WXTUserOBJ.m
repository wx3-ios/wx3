//
//  WXTUserOBJ.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUserOBJ.h"
#import "WXTUserDefault.h"
#import "KeychainItemWrapper.h"
@implementation WXTUserOBJ

-(id)init{
    if (self = [super init]) {
        _userKeyChainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"wxt_user" accessGroup:@"woxin"];
        _passwdKeyChainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"wxt_passwd" accessGroup:@"woxin"];
    }
    return self;
}

+(WXTUserOBJ*)sharedUserOBJ{
    static dispatch_once_t onceToken;
    static WXTUserOBJ *sharedUserOBJ = nil;
    dispatch_once(&onceToken,^{
        sharedUserOBJ = [[WXTUserOBJ alloc] init];
    });
    return sharedUserOBJ;
}

-(void)setWxtID:(NSString *)wxtID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:wxtID forKey:WXT_Userdefault_WxtID];
#if TARGET_IPHONE_SIMULATOR
    [_userKeyChainItem setObject:wxtID forKey:kV_Data];
#endif
}

-(void)setUser:(NSString *)user{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:user forKey:WXT_Userdefault_User];
}

-(void)setPwd:(NSString *)pwd{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:pwd forKey:WXT_Userdefault_Pwd];
#if TARGET_IPHONE_SIMULATOR
    [_passwdKeyChainItem setObject:pwd forKey:kV_Data];
#endif
}

-(void)setToken:(NSString *)token{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:token forKey:WXT_Userdefault_Token];
}

-(void)setSmsID:(int)smsID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setInteger:smsID forKey:WXT_Userdefault_SmsID];
}

-(NSString*)wxtID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_WxtID];
#if TARGET_IPHONE_SIMULATOR
    return [_userKeyChainItem objectForKey:kV_Data];
#endif
}

-(NSString*)user{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_User];
}

-(NSString*)pwd{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_Pwd];
#if TARGET_IPHONE_SIMULATOR
    return [_passwdKeyChainItem objectForKey:kV_Data];
#endif
}

-(NSString*)token{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_Token];
}

-(int)smsID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return (int)[userDefault integerValueForKey:WXT_Userdefault_SmsID];
}

- (void)removeAllUserInfo{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault removeObjectForKey:WXT_Userdefault_WxtID];
    [userDefault removeObjectForKey:WXT_Userdefault_Token];
    [userDefault removeObjectForKey:WXT_Userdefault_User];
    [userDefault removeObjectForKey:WXT_Userdefault_Pwd];
    [userDefault removeObjectForKey:WXT_Userdefault_SmsID];
}

@end
