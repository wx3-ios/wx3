//
//  AliPayControl.m
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "AliPayControl.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"

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

- (id)init{
	if (self = [super init]){
	}
	return self;
}

+ (NSString*)aliURLSchemes{
	return [NSString stringWithFormat:@"%@%d",kAliPayScheme,(int)kMerchantID];
}

-(void)handleAliPayResult:(AlixPayResult*)result{
    if(result){
        if(result.statusCode == 9000){
            /**用公钥验证签名 严格验证请使用result.resultString与result.signString验签*/
            //交易成功
            NSString *key = AlipayPubKey;  //签约账户后获取到的支付宝公钥
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            if([verifier verifyString:result.resultString withSign:result.signString]){
                [UtilTool showAlertView:nil message:@"恭喜您,支付成功" delegate:self tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        }else{
            NSString *message = [NSString stringWithFormat:@"支付失败,%@",result.statusMessage];
            [UtilTool showAlertView:nil message:message delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }else{
        KFLog_Normal(YES, @"其他的回调");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_AliPaySucceed object:nil];
}

-(void)paymentResult:(NSString *)resulted{
    //处理结果
    AlixPayResult *result = [[AlixPayResult alloc] initWithString:resulted];
    [self handleAliPayResult:result];
}

- (void)alipayOrderID:(NSString*)orderID title:(NSString*)title amount:(CGFloat)amount phpURL:(NSString*)phpURL payTag:(id)payTag{
	AlixPayOrder *aliPayOrder = [[AlixPayOrder alloc] init];
	aliPayOrder.partner = PartnerID;
	aliPayOrder.seller = SellerID;
	
	aliPayOrder.productName = title; //商品标题
	aliPayOrder.productDescription = [WXUserOBJ sharedUserOBJ].user; //商品描述
	aliPayOrder.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
	aliPayOrder.notifyURL =  phpURL; //回调URL
	aliPayOrder.tradeNO = orderID;
	
	NSString* orderInfo = [aliPayOrder description];
	NSString* signedStr = [self doRsa:orderInfo];
	NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
							 orderInfo, signedStr, @"RSA"];
	NSString *appScheme = [AliPayControl aliURLSchemes];
	[AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

#pragma mark 程序切换到后台的时候,对支付宝的处理回调
-(AlixPayResult*)resultFromUrl:(NSURL*)url{
    NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[AlixPayResult alloc] initWithString:query];
}

//后台的回调
-(void)handleAliPayURL:(NSURL *)url{
    AlixPayResult *result = nil;
    if(url != nil && [[url host] compare:@"safepay"] == 0){
        result = [self resultFromUrl:url];
    }
    [self handleAliPayResult:result];
}


-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

@end
