//
//  JPushMessageInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/7/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushMessageInfoVC.h"

#define NormaleMessageUrl @"http://oldyun.67call.com/wx_html/index.php/Public/messages"

@interface JPushMessageInfoVC()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@end

@implementation JPushMessageInfoVC

-(id)initWithData{
    if(self = [super init]){
    }
    return self;
}

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
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *urlStr = [NSString stringWithFormat:@"%@?phone=%@&msg_id=%ld",NormaleMessageUrl,userObj.user,(long)107];
    
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
    NSInteger gotoID = [[paramDic objectForKey:@"msg_id"] integerValue];
    if(gotoID == -1){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return NO;
    }else{
        return YES;
    }
}

@end
