//
//  SysMsgDetailVC.m
//  Woxin2.0
//
//  Created by le ting on 8/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgDetailVC.h"
#import "SysMsgItem.h"
#import "WXMFMessageComposeVC.h"

@interface SysMsgDetailVC ()<UIWebViewDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
{
    WXUIWebView *_webView;
    WXUIButton *_sharedButton;
}
@end

@implementation SysMsgDetailVC

- (void)dealloc{
//    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    SysMsgItem *item = _sysMsgDetailInfo;
    NSString *urlStr = item.messageURL;
    [self setCSTTitle:item.msgTitle];
    if(urlStr){
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        _webView = [[WXUIWebView alloc] initWithFrame:self.bounds];
        [_webView setDelegate:self];
        [_webView loadRequest:request];
        [self addSubview:_webView];
    }
    _sharedButton = [WXUIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sharedImg = [UIImage imageNamed:@"sharedSysMessage.png"];
    [_sharedButton setImage:sharedImg forState:UIControlStateNormal];
    [_sharedButton setFrame:CGRectMake(0, 0, sharedImg.size.width, sharedImg.size.height)];
    [_sharedButton addTarget:self action:@selector(sharedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sharedButton];
    [self setRightNavigationItem:_sharedButton];
}

- (void)sharedButtonClicked{
    WXUIActionSheet *actionSheet = [[WXUIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制",@"短信分享",nil];
    [actionSheet showInView:self.view];
}

- (NSString*)sysMessageBody{
    SysMsgItem *item = self.sysMsgDetailInfo;
    return item.messageURL;
}

- (void)copySysMessage{
    [UtilTool copy:[self sysMessageBody]];
    [UtilTool showAlertView:@"消息链接复制成功"];
}

- (void)sendSysMessage{
    if(![MFMessageComposeViewController canSendText]){
        [UtilTool showAlertView:@"当前设备没有短信功能"];
        return;
    }
    
    WXMFMessageComposeVC *picker = [[WXMFMessageComposeVC alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.body = [self sysMessageBody];
    [self showWaitViewMode:E_WaiteView_Mode_FullScreenBlock title:@"正在准备分享"];
    [self presentViewController:picker animated:YES completion:^{
        [self unShowWaitView];
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitViewMode:E_WaiteView_Mode_Unblock title:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
    [UtilTool showAlertView:@"加载信息失败"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self copySysMessage];
            break;
        case 1:
            [self sendSysMessage];
            break;
            
        default:
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
