//
//  AboutShopVC.m
//  RKWXT
//
//  Created by SHB on 15/7/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutShopVC.h"

#define NormaleMessageUrl @"wx_html/index.php/Public/shop_detail"

@interface AboutShopVC()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@end

@implementation AboutShopVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitleColor:[UIColor blackColor]];
    
    _webView = [[WXUIWebView alloc] initWithFrame:self.bounds];
    [_webView setDelegate:self];
    [self addSubview:_webView];
    
    NSInteger companyID = kMerchantID;
    if(_shopID>0){
        companyID = _shopID;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?sid=%d&phone=%@",WXTWebBaseUrl,NormaleMessageUrl,companyID,userObj.user];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitViewMode:E_WaiteView_Mode_Unblock title:@"正在加载数据"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
    [UtilTool showAlertView:@"数据加载失败"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    NSDictionary *paramDic = [self parseURL:urlString];
    return [self jumpToParam:paramDic];
}

-(NSDictionary*)parseURL:(NSString*)url{
    NSArray *paramList = [url componentsSeparatedByString:@"?"];
    if([paramList count] < 2){
        return nil;
    }
    NSString *paramString = [paramList objectAtIndex:1];
    paramList = [paramString componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    for(NSString *paramString in paramList){
        NSArray *keyAndValue = [paramString componentsSeparatedByString:@"="];
        if([keyAndValue count] != 2){
            continue;
        }
        [paramDic setObject:[keyAndValue objectAtIndex:1] forKey:[keyAndValue objectAtIndex:0]];
    }
    if([paramDic allKeys] == 0){
        return nil;
    }
    return paramDic;
}

-(BOOL)jumpToParam:(NSDictionary*)paramDic{
    NSInteger gotoID = [[paramDic objectForKey:@"goods_id"] integerValue];
    if(gotoID == -1){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return NO;
    }else{
        return YES;
    }
}

@end
