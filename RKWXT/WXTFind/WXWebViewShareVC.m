//
//  WXWebViewShareVC.m
//  RKWXT
//
//  Created by app on 15/11/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXWebViewShareVC.h"
#import "WXWeiXinOBJ.h"
#import "DownSheet.h"
#import <TencentOpenAPI/QQApiInterface.h>

enum{
    Share_Qq,
    Share_Qzone,
    Share_Friends,
    Share_Clrcle,
    
    Share_Invalid,
};

@interface WXWebViewShareVC()<UIWebViewDelegate,DownSheetDelegate>{
    UIWebView *_webView;
    NSArray *menuList;
    
    //分享
    NSString *abstract;
    NSString *imgUrl;
    NSString *title;
    NSString *webUrl;
}
@end

@implementation WXWebViewShareVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitleColor:[UIColor blackColor]];
    
    _webView = [[WXUIWebView alloc] initWithFrame:self.bounds];
    [_webView setDelegate:self];
    [self addSubview:_webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@wx_html/index.php/Vcard/index",WXTWebBaseUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    [self initDropList];
}

-(void)initDropList{
    DownSheetModel *model_1 = [[DownSheetModel alloc] init];
    model_1.icon = @"ShareQqImg.png";
    model_1.icon_on = @"ShareQqImg.png";
    model_1.title = @"分享到qq好友";
    
    DownSheetModel *model_2 = [[DownSheetModel alloc] init];
    model_2.icon = @"ShareQzoneImg.png";
    model_2.icon_on = @"ShareQzoneImg.png";
    model_2.title = @"分享到qq空间";
    
    DownSheetModel *model_3 = [[DownSheetModel alloc] init];
    model_3.icon = @"ShareWxFriendImg.png";
    model_3.icon_on = @"ShareWxFriendImg.png";
    model_3.title = @"分享到微信好友";
    
    DownSheetModel *model_4 = [[DownSheetModel alloc] init];
    model_4.icon = @"ShareWxCircleImg.png";
    model_4.icon_on = @"ShareWxCircleImg.png";
    model_4.title = @"分享到朋友圈";
    
    DownSheetModel *model_5 = [[DownSheetModel alloc] init];
    model_5.icon = @"Icon.png";
    model_5.icon_on = @"Icon.png";
    model_5.title = @"取消";
    
    menuList = @[model_1,model_2,model_3,model_4,model_5];
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
    if(urlString){
        WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
        webUrl = [NSString stringWithFormat:@"%@&phone=%@&woxin_id=%@",urlString,userObj.user,userObj.wxtID];
    }
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
    NSInteger gotoID = [[paramDic objectForKey:@"vcard_id"] integerValue];
    if(gotoID == -1){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return NO;
    }
    if([[paramDic objectForKey:@"go"] isEqualToString:@"vcard"]){
        title = [[paramDic objectForKey:@"vcard_title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        abstract = [[paramDic objectForKey:@"abstract"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        imgUrl = [[NSString alloc] initWithFormat:@"%@%@",AllImgPrefixUrlString,[paramDic objectForKey:@"vcard_home_img"]];
        
        DownSheet *sheet = [[DownSheet alloc] initWithlist:menuList height:0];
        sheet.delegate = self;
        [sheet showInView:self];
        
        return NO;
    }
    return YES;
}

#pragma mark 分享
-(void)didSelectIndex:(NSInteger)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data){
        image = [UIImage imageWithData:data];
    }
    if(index == Share_Friends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:title description:abstract linkURL:webUrl thumbImage:image];
    }
    if(index == Share_Clrcle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:title description:abstract linkURL:webUrl thumbImage:image];
    }
    if(index == Share_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webUrl] title:title description:abstract previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webUrl] title:title description:abstract previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
    if(index == Share_Invalid){
        NSLog(@"取消");
    }
}

@end
