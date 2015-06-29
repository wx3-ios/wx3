//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088911857507911"
//收款支付宝账号
#define SellerID  @"liyz@67call.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICXQIBAAKBgQDKJXlBtZeA02MxpJtejgJKHl83+mfjt1bkktFnxEtHrHOGFLf5WZCQLgxrkSz9R36lQs0x6vJ5X9bbix83aSE+eP/ZTFBUlcqG8n584n/YZK3VK+TrMBThMtJh6leqrB0Az5aP1Uj5onWtHnPNE91v9H+Bvlp+ANF8TzwGxQc2BQIDAQABAoGATydJSb+PaXRcfQ3VgLrejqNB6at1jqc1sR8EPDuStqgCPFhUiaDWiH5fgqdAFJUwNAnqS0eSVpB+k0zwlkPmLdvOWyIy+5k3ALcGFmwgRDWF03aX1+vl/1fWswpzaWpwbRNOi7FBb5q8UzZ6guHde7kqO/VfKHJrM9rG5Oj4QMECQQDwCiTecIGgYFlugkPU/KqpHB/+Yv+QCE6HJXW/H94x5Pj41i45xVIyZRBOhJi+T7HltJXR9jMcOXk53AHE7xi5AkEA15ZTjunDEzyMi48Sn6vqqEFuqhKf83fH50AycnX9TPhUaoR018bsK2lwHMp/7Wb6+9bIGBhCLaPwv4P5v70JrQJBAIGh6NFcTxUOk52zqfBfV8cmUjzut/fQFKC14UYLbtLhRngUKzi10LM4kzrkLx0wKvHTucl/PZDzlP1jTG1PdrkCQEUiF7mEjOHmUMuQHdDGOIGsOeigAFr61kf59jNuUsQT/j4KK83mJGXnceRJq6xdka6guZnAbbhlEhbYI4axACECQQDlUm++igQy8w28uD39PIwLWWFN5Msxk4Lq6xN+AI6966zJTLMQA8NWbd3alXy9KsrXipCfrFCno7EeEWMtnQ/v"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKJXlBtZeA02MxpJtejgJKHl83+mfjt1bkktFnxEtHrHOGFLf5WZCQLgxrkSz9R36lQs0x6vJ5X9bbix83aSE+eP/ZTFBUlcqG8n584n/YZK3VK+TrMBThMtJh6leqrB0Az5aP1Uj5onWtHnPNE91v9H+Bvlp+ANF8TzwGxQc2BQIDAQAB"


//账号充值回调
#define D_AliPayCallBackURLForUser @"http://oldyun.67call.com/wx3order/wx3alipay/notify_url.php"

#endif

