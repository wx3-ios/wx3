//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"

@interface WXTMallViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView * _activityIndicatorView;
    UIWebView * _webView;
}

@end

@implementation WXTMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 50 - 64)];
    _webView.scalesPageToFit =YES;
    _webView.delegate = self;
    _activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [_activityIndicatorView setCenter: self.view.center] ;
    [_activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wxt.haoxueyou.com/mobile/"]]];
    [self.view addSubview:_activityIndicatorView];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

@end
