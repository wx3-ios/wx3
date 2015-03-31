//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "WXTMallModel.h"
#import "MallEntity.h"

#define ShopURL @"http://wxt.haoxueyou.com/mobile/"

@interface WXTMallViewController ()<UIWebViewDelegate/*,wxtMallDelegate*/>{
    UIWebView * _webView;
    //    WXTMallModel *_model;
}

@end

@implementation WXTMallViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self createTopView:@"商城"];
    //    [self createTopStatusView:[UIColor redColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ShopURL]];
    if (request){
        [_webView loadRequest:request];
    }
    
    //    _model = [[WXTMallModel alloc] init];
    //    [_model setMallDelegate:self];
    //    [_model loadMallData];
}

#pragma mark delegate
//-(void)initMalldataSucceed{
//    if([_model.mallDataArr count]>0){
//        MallEntity *entity = [_model.mallDataArr objectAtIndex:0];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:entity.mall_url]];
//        if (request){
//            [_webView loadRequest:request];
//        }
//    }
//}

//-(void)initMalldataFailed:(NSString *)errorMsg{
//    if(!errorMsg){
//        errorMsg = @"商城加载失败";
//    }
//    [UtilTool showAlertView:errorMsg];
//}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [_model setMallDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
