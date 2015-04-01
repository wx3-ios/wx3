//
//  FindCommonVC.m
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "FindCommonVC.h"

#define Size self.view.bounds.size

@interface FindCommonVC()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@end

@implementation FindCommonVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = _titleName;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height-66)];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webURl]];
    if (request){
        [_webView loadRequest:request];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
}

@end
