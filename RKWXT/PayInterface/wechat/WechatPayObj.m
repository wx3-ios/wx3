//
//  WechatPayObj.m
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WechatPayObj.h"
#import "payRequsestHandler.h"
#import "WXApi.h"

@interface WechatPayObj(){
    long token_time;
    NSString *Token;
}
@end

@implementation WechatPayObj

-(id)init{
    if(self = [super init]){
        token_time = 0;
    }
    return self;
}

-(void)sendPay2{
    //商户号
    NSString *PARTENR_ID = @"1900000109";
    //商户密钥
    NSString *PARTENR_KEY = @"8934e7d15453e97507ef794cf7b0519d";
    //APPID
    NSString *APPI_ID = @"wxd930ea5d5a258f4f";
    //appsecret
    NSString *APP_SECRET = @"db426a9829e4b49a0dcac7b4162da6b6";
    //支付密钥
    NSString *APP_KEY = @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K";
    //支付结果回调页面
    NSString *NOTIFY_URL = @"http://localhost/wepay/notify_url.php";
    //订单标题
    NSString *ORDER_NAME = @"Ios客户端签名支付 测试";
    //订单金额,单位(分)
    NSString *ORDER_PRICE = @"1";
    
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APPI_ID app_secret:APP_SECRET partner_key:PARTENR_KEY app_key:APP_KEY];
    //判断Token过期时间,10分钟内不能重复获取，测试帐号多个使用，可能造成其他地方获取后不能用，需要即时获取
    time_t now;
    time(&now);
    if((now-token_time) > 0){
        //获取Token
        Token = [req GetToken];
        //设置Token有效期为10分钟
        token_time = now+600;
        //日志输出
        NSLog(@"获取Token: %@\n",[req getDebugifo]);
    }
    if(Token != nil){
        //==============
        //预付单参数订单设置
        //==============
        NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
        [packageParams setObject: @"WX"                                             forKey:@"bank_type"];
        [packageParams setObject: ORDER_NAME                                        forKey:@"body"];
        [packageParams setObject: @"1"                                              forKey:@"fee_type"];
        [packageParams setObject: @"UTF-8"                                          forKey:@"input_charset"];
        [packageParams setObject: NOTIFY_URL                                        forKey:@"notify_url"];
        [packageParams setObject: [NSString stringWithFormat:@"%ld",time(0)]        forKey:@"out_trade_no"];
        [packageParams setObject: PARTENR_ID                                        forKey:@"partner"];
        [packageParams setObject: @"196.168.1.1"                                    forKey:@"spbill_create_ip"];
        [packageParams setObject: ORDER_PRICE                                       forKey:@"total_fee"];
        
        NSString *package, *time_stamp, *nonce_str, *traceid;
        //获取package包
        package = [req genPackage:packageParams];
        
        //输出debug info
        NSString *debug = [req getDebugifo];
        NSLog(@"gen package: %@\n",package);
        NSLog(@"生成package: %@\n",debug);
        
        //设置支付参数
        time_stamp = [NSString stringWithFormat:@"%ld", now];
        nonce_str = [TenpayUtil md5:time_stamp];
        traceid = @"mytestid_001";
        
        NSMutableDictionary *prePayParams = [NSMutableDictionary dictionary];
        [prePayParams setObject: APPI_ID                                            forKey:@"appid"];
        [prePayParams setObject: APP_KEY                                            forKey:@"appkey"];
        [prePayParams setObject: nonce_str                                          forKey:@"noncestr"];
        [prePayParams setObject: package                                            forKey:@"package"];
        [prePayParams setObject: time_stamp                                         forKey:@"timestamp"];
        [prePayParams setObject: traceid                                            forKey:@"traceid"];
        
        //生成支付签名
        NSString    *sign;
        sign		= [req createSHA1Sign:prePayParams];
        //增加非参与签名的额外参数
        [prePayParams setObject: @"sha1"                                            forKey:@"sign_method"];
        [prePayParams setObject: sign                                               forKey:@"app_signature"];
        
        //获取prepayId
        NSString *prePayid;
        prePayid            = [req sendPrepay:prePayParams];
        //输出debug info
        debug               = [req getDebugifo];
        NSLog(@"提交预付单： %@\n",debug);
        
        if ( prePayid != nil) {
            //重新按提交格式组包，微信客户端5.0.3以前版本只支持package=Sign=***格式，须考虑升级后支持携带package具体参数的情况
            //package       = [NSString stringWithFormat:@"Sign=%@",package];
            package         = @"Sign=WXPay";
            //签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: APPI_ID                                          forKey:@"appid"];
            [signParams setObject: APP_KEY                                          forKey:@"appkey"];
            [signParams setObject: nonce_str                                        forKey:@"noncestr"];
            [signParams setObject: package                                          forKey:@"package"];
            [signParams setObject: PARTENR_ID                                       forKey:@"partnerid"];
            [signParams setObject: time_stamp                                       forKey:@"timestamp"];
            [signParams setObject: prePayid                                         forKey:@"prepayid"];
            
            //生成签名
            sign		= [req createSHA1Sign:signParams];
            
            //输出debug info
            debug     = [req getDebugifo];
            NSLog(@"调起支付签名： %@\n",debug);
            
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.openID      = APPI_ID;
            req.partnerId   = PARTENR_ID;
            req.prepayId    = prePayid;
            req.nonceStr    = nonce_str;
            req.timeStamp   = now;
            req.package     = package;
            req.sign        = sign;
            [WXApi sendReq:req];
        }else{
            /*long errcode = [req getLasterrCode];
             if ( errcode == 40001 )
             {//Token实效，重新获取
             Token                   = [req GetToken];
             token_time              = now + 600;
             NSLog(@"获取Token： %@\n",[req getDebugifo]);
             };*/
            NSLog(@"获取prepayid失败\n");
            [self alert:@"提示信息" msg:debug];
        }
    }else{
        NSLog(@"获取Token失败\n");
        [self alert:@"提示信息" msg:@"获取Token失败"];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

-(void)onResp:(BaseResp*)resp{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d",resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果:成功!";
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果:失败"];
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
