//
//  WXFindCommonVC.m
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXFindCommonVC.h"

#define Size self.bounds.size

@interface WXFindCommonVC ()<UIWebViewDelegate>
{
   UIWebView *_webView; 
}
@end

@implementation WXFindCommonVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    [_webView setDelegate:self];
    [self addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webURl]];
    if (request){
        [_webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    NSDictionary *paramDic = [self parseURL:urlString];
    return [self jumpToParam:paramDic];
}

-(BOOL)jumpToParam:(NSDictionary*)paramDic{
    NSInteger gotoID = [[paramDic objectForKey:@"goods_id"] integerValue];
    if(gotoID != 0){
        if(gotoID == -1){
            [self.wxNavigationController popViewControllerAnimated:YES completion:^{
            }];
            return YES;
        }
        [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:[[paramDic objectForKey:@"goods_id"] integerValue] animated:YES];
        return NO;
    }else{
        return NO;
    }
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

@end
