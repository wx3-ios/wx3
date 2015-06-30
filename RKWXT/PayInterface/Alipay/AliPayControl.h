//
//  AliPayControl.h
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_Notification_Name_AliPaySucceed @"D_Notification_Name_AliPaySucceed"
#define D_Notification_Name_AliPayFailed @"D_Notification_Name_AliPayFailed"

typedef enum {
    //账号充值
    E_AliPay_RechargeFor_User,
}E_AliPay_RechargeType;


typedef enum {
    //返回失败
    E_AliPay_Error = -1,
    //返回成功
    E_AliPay_Succeed
}E_AliPay_RetVal;

@interface AliPayControl : NSObject

+ (AliPayControl*)sharedAliPayOBJ;
+ (NSString*)aliURLSchemes;
- (void)handleAliPayURL:(NSURL*)url;
- (void)alipayOrderID:(NSString*)orderID title:(NSString*)title amount:(CGFloat)amount phpURL:(NSString*)phpURL payTag:(id)payTag;
@end
