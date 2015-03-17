//
//  WXTipMaskOBJ.m
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXTipMaskOBJ.h"

@implementation WXTipMaskOBJ

+ (WXTipMaskOBJ*)sharedTipMaskOBJ{
    static dispatch_once_t onceToken;
    static WXTipMaskOBJ *sharedOBJ = nil;
    dispatch_once(&onceToken, ^{
        sharedOBJ = [[WXTipMaskOBJ alloc] init];
    });
    return sharedOBJ;
}

- (BOOL)isHomePageTipMaskRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bMaskHomePage];
}
- (BOOL)isSliderSettingTipMaskRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bMaskSliderSetting];
}
- (BOOL)isKeyPadTipMaskRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bMaskKeyPad];
}
- (BOOL)isContacteTipMaskRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bMaskResent];
}
- (BOOL)isResentTipMaskRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault boolValueForKey:D_WXUserdefault_Key_bMaskContacter];
}

- (void)setHomepageTipMaskRead:(BOOL)isRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:isRead forKey:D_WXUserdefault_Key_bMaskHomePage];
}
- (void)setSliderSettingTipMaskRead:(BOOL)isRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:isRead forKey:D_WXUserdefault_Key_bMaskSliderSetting];
}
- (void)setKeyPadTipMaskRead:(BOOL)isRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:isRead forKey:D_WXUserdefault_Key_bMaskKeyPad];
}
- (void)setContacteTipMaskRead:(BOOL)isRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:isRead forKey:D_WXUserdefault_Key_bMaskResent];
}
- (void)setResentTipMaskRead:(BOOL)isRead{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setBool:isRead forKey:D_WXUserdefault_Key_bMaskContacter];
}

@end
