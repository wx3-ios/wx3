//
//  JPushMessageInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/7/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushMessageInfoVC.h"
#import "JPushInfoModel.h"

@interface JPushMessageInfoVC()<UIWebViewDelegate,JPushMessageDelegate>{
    UIWebView *_webView;
    JPushInfoModel *_model;
}
@end

@implementation JPushMessageInfoVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[JPushInfoModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"消息详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_webView setDelegate:self];
    [self addSubview:_webView];
    
    [_model loadJPushMessageInfoWit:_messageID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)loadJPushMessageSucceed{
    [self unShowWaitView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:nil]];
    if (request){
        [_webView loadRequest:request];
    }
}

-(void)loadJPushMessageFailed:(NSString *)errorMsg{
    [self unShowWaitView];
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

@end
