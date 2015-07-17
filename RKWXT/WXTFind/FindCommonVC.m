//
//  FindCommonVC.m
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "FindCommonVC.h"

#define Size self.bounds.size

@interface FindCommonVC()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@end

@implementation FindCommonVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    [_webView setDelegate:self];
    [self addSubview:_webView];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oldyun.67call.com/wx_html/index.php/Index/index_comp?sid=7"]];
    if (request){
        [_webView loadRequest:request];
    }
}

#pragma mark webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
}

@end
