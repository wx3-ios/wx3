//
//  CompanyVC.m
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CompanyVC.h"
#import "WXWeiXinOBJ.h"
#import "DownSheet.h"
#import <TencentOpenAPI/QQApiInterface.h>

#define Size self.bounds.size
#define kCompanyLoadUrl @"wx_html/index.php/Index/index_comp?sid="

enum{
    Share_Qq,
    Share_Qzone,
    Share_Friends,
    Share_Clrcle,
    
    Share_Invalid,
};

@interface CompanyVC()<UIWebViewDelegate,DownSheetDelegate>{
    WXUIWebView *_webView;
    NSArray *menuList;
    UIView *shellView;
    
    //分享
    NSString *title;
    NSString *desc;
    NSString *shareUrl;
    NSString *imgUrl;
}
@end

@implementation CompanyVC

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
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%d",WXTBaseUrl,kCompanyLoadUrl,kMerchantID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    
    [self initDropList];
    
    shellView = [[UIView alloc] init];
    shellView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [shellView setBackgroundColor:[UIColor clearColor]];
    [shellView setHidden:YES];
    [self addSubview:shellView];
    [self showReloadBaseView];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@%d",WXTBaseUrl,kCompanyLoadUrl,kMerchantID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
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
    [shellView setHidden:YES];
    [webView setHidden:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
    [UtilTool showAlertView:@"数据加载失败"];
    [shellView setHidden:NO];
    [webView setHidden:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    if(urlString){
        shareUrl = urlString;
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
    if([[paramDic objectForKey:@"go"] isEqualToString:@"wx_intr"]){
        title = [[paramDic objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        desc = [[paramDic objectForKey:@"intro"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,[paramDic objectForKey:@"content_ico"]];
        
        DownSheet *sheet = [[DownSheet alloc] initWithlist:menuList height:50];
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
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:title description:desc linkURL:shareUrl thumbImage:image];
    }
    if(index == Share_Clrcle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:title description:desc linkURL:shareUrl thumbImage:image];
    }
    if(index == Share_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:desc previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:desc previewImageData:data];
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
