//
//  WXCommonWebView.m
//  RKWXT
//
//  Created by SHB on 15/8/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXCommonWebView.h"
#import "WXTURLFeedOBJ.h"

@interface WXCommonWebView()<UIWebViewDelegate>{
    WXUIWebView *_webView;
}
@property (nonatomic,strong) NSDictionary *paramDictionary;
@end

@implementation WXCommonWebView

-(id)initCommonWebviewWithFeedType:(WebView_Type)urlType paramDictionary:(NSDictionary *)paramDictionary{
    if(self = [super init]){
        [self setUrlType:urlType];
        if(urlType == WebView_Type_JointUrl){
            [self setParamDictionary:paramDictionary];
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(_titleName){
        [self setCSTTitle:_titleName];
    }
    [self setCSTTitleColor:[UIColor blackColor]];
    
    _webView = [[WXUIWebView alloc] initWithFrame:self.bounds];
    [_webView setDelegate:self];
    [self addSubview:_webView];
    [self loadRootUrl:_urlType paramDictionary:_paramDictionary];
}

-(void)loadRootUrl:(WebView_Type)urlFeedType paramDictionary:(NSDictionary*)paramDictionary{
    WXTURLFeedOBJ *feedOBJ = [WXTURLFeedOBJ sharedURLFeedOBJ];
    NSString *boay = nil;
    if(paramDictionary && urlFeedType == WebView_Type_JointUrl){
        boay = [feedOBJ urlRequestParamFrom:paramDictionary];
    }
    if(urlFeedType == WebView_Type_SingleUrl){
        boay = _webUrlString;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:boay]];
    if (request){
        [_webView loadRequest:request];
    }
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
    if(gotoID != 0){
        if(gotoID == -1){
            [self.wxNavigationController popViewControllerAnimated:YES completion:^{
            }];
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}

@end