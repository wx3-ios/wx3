//
//  ScreenActivityVC.m
//  RKWXT
//
//  Created by SHB on 15/7/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ScreenActivityVC.h"
#import "LoginVC.h"
#import "WXTUITabbarVC.h"
#import "LoginModel.h"
#import "LoginModel.h"
#import "APService.h"
#import "NewWXTLiDB.h"

@interface ScreenActivityVC()<UIWebViewDelegate>{
    NSTimer *timer;
    UIWebView *webView;
    LoginModel *_model;
    WXTUITabbarVC *tabbarVC;
}
@end

@implementation ScreenActivityVC

-(id)init{
    if(self = [super init]){
        tabbarVC = [[WXTUITabbarVC alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor grayColor]];
    
    [self addNotification];
    webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    [webView setDelegate:self];
    [self.view addSubview:webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oldyun.67call.com/wx_html/index.php/Public/anim_r"]];
    [webView loadRequest:request];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

-(void)addNotification{
    [NOTIFY_CENTER addObserver:self selector:@selector(loginSucceed:) name:KNotification_LoginSucceed object:nil];
    [NOTIFY_CENTER addObserver:self selector:@selector(loginFailed:) name:KNotification_LoginFailed object:nil];
}

-(void)removeNotification{
    [NOTIFY_CENTER removeObserver:self];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
}

#pragma mark fade
-(void)fadeScreen{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedFading)];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)finishedFading{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.view.alpha = 1.0;
    [UIView commitAnimations];
    
    for(UIView *my in [self.view subviews]){
        if([my isKindOfClass:[UILabel class]]){
            [my removeFromSuperview];
        }
    }
    [webView removeFromSuperview];
    
//    LoginVC *loginVC = [[LoginVC alloc] init];
//    WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
//    [self.wxNavigationController presentViewController:navigationController animated:YES completion:^{
//        [self.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
//        }];
//    }];
    [self start];
}

-(void)start{
    BOOL userInfo = [self checkUserInfo];
    if(userInfo){
        WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:tabbarVC];
        [self.wxNavigationController presentViewController:navigationController animated:YES completion:^{
            [self.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
            }];
        }];
        
        //自动登录
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        _model = [[LoginModel alloc] init];
        [_model loginWithUser:userDefault.user andPwd:userDefault.pwd];
        
        [APService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"%@",userDefault.user]] alias:nil callbackSelector:nil object:nil];
    }else{
        LoginVC *loginVC = [[LoginVC alloc] init];
        WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
        [self.wxNavigationController presentViewController:navigationController animated:YES completion:^{
            [self.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
            }];
        }];
    }
}

-(BOOL)checkUserInfo{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    if(!userDefault.user || !userDefault.pwd || !userDefault.wxtID){
        return NO;
    }
    return YES;
}

-(void)loginSucceed:(NSNotification*)notification{
    [[NewWXTLiDB sharedWXLibDB] loadData];
    [self removeNotification];
}

-(void)loginFailed:(NSNotification*)notification{
    [self removeNotification];
    LoginVC *loginVC = [[LoginVC alloc] init];
    WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
    [tabbarVC.wxNavigationController presentViewController:navigationController animated:YES completion:^{
        [tabbarVC.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
        }];
    }];
}

#pragma mark 
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
////    NSString *urlString = request.URL.absoluteString;
////    NSDictionary *paramDic = [self parseURL:urlString];
////    return [self jumpToParam:paramDic];
//    return NO;
//}

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
        [self start];
        return NO;
    }else{
        return YES;
    }
}

@end
