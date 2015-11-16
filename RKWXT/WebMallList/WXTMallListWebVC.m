//
//  WXTMallListWebVC.m
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallListWebVC.h"
#import "NewGoodsInfoVC.h"

#define MallCatagaryListUrl @"wx_html/index.php/Public/"

typedef enum{
    Web_Goto_Type_GoodsInfo = 1, //商品详情
}Web_Goto_Type;

@interface WXTMallListWebVC()<UIWebViewDelegate>{
    WXUIWebView *_webView;
}
@property (nonatomic,assign) WXT_UrlFeed_Type urlFeedType;
@property (nonatomic,strong) NSDictionary *paramDictionary;
@end

@implementation WXTMallListWebVC

-(id)initWithFeedType:(WXT_UrlFeed_Type)urlFeedType paramDictionary:(NSDictionary *)paramDictionary{
    if(self = [super init]){
        [self setUrlFeedType:urlFeedType];
        [self setParamDictionary:paramDictionary];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(_cstTitle){
        [self setCstTitle:_cstTitle];
    }
    [self setCSTTitleColor:[UIColor blackColor]];
    
    _webView = [[WXUIWebView alloc] initWithFrame:self.bounds];
    [_webView setDelegate:self];
    [self addSubview:_webView];
    [self loadRootUrl:_urlFeedType paramDictionary:_paramDictionary];
}

-(void)loadRootUrl:(WXT_UrlFeed_Type)urlFeedType paramDictionary:(NSDictionary*)paramDictionary{
    WXTURLFeedOBJ *feedOBJ = [WXTURLFeedOBJ sharedURLFeedOBJ];
    NSString *typeStr = nil;
    if(urlFeedType == WXT_UrlFeed_Type_NewMall_CatagaryList){
        typeStr = @"sort_list";
    }
    if(urlFeedType == WXT_UrlFeed_Type_NewMall_ImgAndText){
        typeStr = @"good_info";
    }
    NSString *urlString = [NSString stringWithFormat:@"http://wx3.67call.com/%@%@",MallCatagaryListUrl,typeStr];
    NSString *boay = nil;
    if(paramDictionary){
        boay = [feedOBJ urlRequestParamFrom:paramDictionary];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[boay dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    if([self respondsToSelector:@selector(dataLoadedStarted)]){
        [self dataLoadedStarted];
    }else{
        [self showWaitViewMode:E_WaiteView_Mode_Unblock title:@"正在加载数据"];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
    if([self respondsToSelector:@selector(dataLoadedSucceed)]){
        [self dataLoadedSucceed];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
    if([self respondsToSelector:@selector(dataLoadedFailed)]){
        [self dataLoadedFailed];
    }else{
        [UtilTool showAlertView:@"数据加载失败"];
    }
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

//？&
//goto_id   是否跳转 如果存在且等于1 则需要客户端跳转
//goto_type   跳转的类型 1.商品详情 2.
-(BOOL)jumpToParam:(NSDictionary*)paramDic{
    NSInteger gotoID = [[paramDic objectForKey:@"goods_id"] integerValue];
    if(gotoID != 0){
        if(gotoID == -1){
            [self.wxNavigationController popViewControllerAnimated:YES completion:^{
            }];
            return NO;
        }
        [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:[[paramDic objectForKey:@"goods_id"] integerValue] animated:YES];
        return NO;
    }else{
        return YES;
    }
}

@end
