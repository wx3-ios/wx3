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
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMoleUG1l4DTYzGkm16OAkoeXzf6Z+O3VuSS0WfES0esc4YUt/lZkJAuDGuRLP1HfqVCzTHq8nlf1tuLHzdpIT54/9lMUFSVyobyfnzif9hkrdUr5OswFOEy0mHqV6qsHQDPlo/VSPmida0ec80T3W/0f4G+Wn4A0XxPPAbFBzYFAgMBAAECgYBPJ0lJv49pdFx9DdWAut6Oo0Hpq3WOpzWxHwQ8O5K2qAI8WFSJoNaIfl+Cp0AUlTA0CepLR5JWkH6TTPCWQ+Yt285bIjL7mTcAtwYWbCBENYXTdpfX6+X/V9azCnNpanBtE06LsUFvmrxTNnqC4d17uSo79V8ocmsz2sbk6PhAwQJBAPAKJN5wgaBgWW6CQ9T8qqkcH/5i/5AITocldb8f3jHk+PjWLjnFUjJlEE6EmL5PseW0ldH2Mxw5eTncAcTvGLkCQQDXllOO6cMTPIyLjxKfq+qoQW6qEp/zd8fnQDJydf1M+FRqhHTXxuwraXAcyn/tZvr71sgYGEIto/C/g/m/vQmtAkEAgaHo0VxPFQ6TnbOp8F9XxyZSPO6399AUoLXhRgtu0uFGeBQrOLXQsziTOuQvHTAq8dO5yX89kPOU/WNMbU92uQJARSIXuYSM4eZQy5Ad0MY4gaw56KAAWvrWR/n2M25SxBP+PgorzeYkZedx5EmrrF2RrqC5mcBtuGUSFtgjhrEAIQJBAOVSb76KBDLzDby4Pf08jAtZYU3kyzGTgurrE34Ajr3rrMlMsxADw1Zt3dqVfL0qyteKkJ+sUKejsR4RYy2dD+8="

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

//账号充值回调
#define D_AliPayCallBackURLForUser @"http://wx3.67call.com/wx3order/wx3alipay/notify_url.php"

#endif

