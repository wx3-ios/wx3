//
//  AliPayControl.m
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "AliPayControl.h"
#import "PartnerConfig.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#define kAliPayScheme @"AliMobilePay"
@implementation AliPayControl

+(AliPayControl*)sharedAliPayOBJ{
    static dispatch_once_t onceToken;
    static AliPayControl *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AliPayControl alloc] init];
    });
    return sharedInstance;
}

+ (NSString*)aliURLSchemes{
	return [NSString stringWithFormat:@"%@%d",kAliPayScheme,kMerchantID];
}

//-(void)handleAliPayResult:(AlixPayResult*)result{
//    if(result){
//        if(result.statusCode == 9000){
//            /**用公钥验证签名 严格验证请使用result.resultString与result.signString验签*/
//            //交易成功
//            NSString *key = AlipayPubKey;  //签约账户后获取到的支付宝公钥
//            id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            if([verifier verifyString:result.resultString withSign:result.signString]){
//                [UtilTool showAlertView:nil message:@"恭喜您,支付成功" delegate:self tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            }
//        }else{
//            NSString *message = [NSString stringWithFormat:@"支付失败,%@",result.statusMessage];
//            [UtilTool showAlertView:nil message:message delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        }
//    }else{
//        KFLog_Normal(YES, @"其他的回调");
//    }
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_AliPaySucceed object:nil];
}

- (void)alipayOrderID:(NSString*)orderID title:(NSString*)title amount:(CGFloat)amount phpURL:(NSString*)phpURL payTag:(id)payTa{
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = orderID;
    order.productName = title;
    order.productDescription = kMerchantName;
    order.amount = [NSString stringWithFormat:@"%.2f",amount];
    order.notifyURL = D_AliPayCallBackURLForUser;
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    NSString *appScheme = [NSString stringWithFormat:@"%@%d",kAliPayScheme,kMerchantID];
    
    NSString *orderSpec = [order description];
    
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式转化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if(signedString != nil){
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
                [UtilTool showAlertView:nil message:@"恭喜您,支付成功" delegate:self tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }else{
                NSString *message = [NSString stringWithFormat:@"支付失败,%@",[resultDic objectForKey:@"memo"]];
                [UtilTool showAlertView:nil message:message delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        }];
    }
}

@end
