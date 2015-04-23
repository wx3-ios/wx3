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

//#define ShopURL @"http://wxt.haoxueyou.com/mobile/"
#define Size self.bounds.size

@interface WXTMallViewController ()<UIWebViewDelegate,wxtMallDelegate>{
    UIWebView * _webView;
    WXTMallModel *_model;
    UIView *shellView;
}

@end

@implementation WXTMallViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self addSubview:_webView];
    
    shellView = [[UIView alloc] init];
    shellView.frame = CGRectMake(0, 66, Size.width, Size.height-50-66);
    [shellView setBackgroundColor:[UIColor clearColor]];
    [shellView setHidden:YES];
    [self addSubview:shellView];
    [self showReloadBaseView];
    
    _model = [[WXTMallModel alloc] init];
    [_model setMallDelegate:self];
    [_model loadMallData];
    
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

#pragma mark showBaseView
-(void)showReloadBaseView{
    CGFloat yOffset = 100;
    UIImage *wifiImg = [UIImage imageNamed:@"NoWifi.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((Size.width-wifiImg.size.width)/2, yOffset, wifiImg.size.width, wifiImg.size.height);
    [imgView setImage:wifiImg];
    [shellView addSubview:imgView];
    
    yOffset += wifiImg.size.height+10;
    CGFloat labelWidth = 200;
    CGFloat labelheight = 30;
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelheight);
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:WXTFont(14.0)];
    [label1 setText:@"世界上最遥远的距离就是"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:[UIColor grayColor]];
    [shellView addSubview:label1];
    
    yOffset += labelheight;
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelheight);
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:WXTFont(14.0)];
    [label2 setText:@"没有网络连接"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:[UIColor grayColor]];
    [shellView addSubview:label2];
    
    yOffset += labelheight+20;
    CGFloat btnWidth = 200;
    CGFloat btnHeight = 35;
    WXTUIButton *btn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [btn setBorderRadian:10.0 width:0.5 color:[UIColor clearColor]];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x0c8bdf) controlState:UIControlStateNormal];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [btn setTitle:@"刷新重试" forState:UIControlStateNormal];
    [btn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reloadFindData) forControlEvents:UIControlEventTouchUpInside];
    [shellView addSubview:btn];
}

//无网络情况下二次加载
-(void)reloadFindData{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model loadMallData];
}

#pragma mark delegate
-(void)initMalldataSucceed{
    [shellView setHidden:YES];
    [self unShowWaitView];
    [_model setMallDelegate:nil];
    
    if([_model.mallDataArr count]>0){
        MallEntity *entity = [_model.mallDataArr objectAtIndex:0];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:entity.mall_url]];
        if (request){
            [_webView loadRequest:request];
        }
    }
}

-(void)initMalldataFailed:(NSString *)errorMsg{
    [shellView setHidden:NO];
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"商城加载失败";
    }
    [UtilTool showAlertView:errorMsg];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
