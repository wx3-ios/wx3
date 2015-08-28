//
//  WXWeiXinOBJ.m
//  CallTesting
//
//  Created by le ting on 5/27/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXWeiXinOBJ.h"
#import "WXApiObject.h"
#import "WXApi.h"

#define D_WeiXinAppID @"wx6708a2328dc2baa7"
#define kThumbImageFileName @"Icon@2x.png"

@interface WXWeiXinOBJ()<WXApiDelegate>
{
    
}
@end
@implementation WXWeiXinOBJ

+ (WXWeiXinOBJ*)sharedWeiXinOBJ{
    static dispatch_once_t onceToken;
    static WXWeiXinOBJ *sharedOBJ = nil;
    dispatch_once(&onceToken, ^{
        sharedOBJ = [[WXWeiXinOBJ alloc] init];
    });
    return sharedOBJ;
}

//注册App
- (void)registerApp{
    NSArray *arr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    NSDictionary *dic = [arr objectAtIndex:1];
    NSString *appId = [[dic objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
    
    if([WXApi registerApp:appId withDescription:@"woxin"]){
        KFLog_Normal(YES, @"微信注册成功");
    }else{
        KFLog_Normal(YES, @"微信注册失败");
    }
}

- (void)handleOpenURL:(NSURL*)url{
    [WXApi handleOpenURL:url delegate:self];
}

- (enum WXScene)sceneOfMode:(E_WeiXin_Mode)mode{
    enum WXScene scene;
    switch (mode) {
        case E_WeiXin_Mode_Friend:
            scene = WXSceneSession;
            break;
        case E_WeiXin_Mode_FriendGroup:
            scene = WXSceneTimeline;
            break;
        case E_WeiXin_Mode_Fav:
            scene = WXSceneFavorite;
            break;
        default:
            break;
    }
    return scene;
}

- (BOOL)sendMode:(E_WeiXin_Mode)mode title:(NSString*)title description:(NSString*)description
         linkURL:(NSString*)url thumbImage:(UIImage*)image{
    if(![WXApi isWXAppInstalled]){
        [UtilTool showAlertView:nil message:@"您还没有安装微信，暂不支持此功能。" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        return NO;
    }else if(![WXApi isWXAppSupportApi]){
        [UtilTool showAlertView:nil message:@"您的微信版本太低,请下载最新版本。" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        return NO;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    if(title){
        [message setTitle:title];
    }
    if(description){
        [message setDescription:description];
    }
    UIImage *thumbImage = [UIImage imageNamed:kThumbImageFileName];
    if(image){
        thumbImage = image;
    }
    [message setThumbImage:thumbImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = [self sceneOfMode:mode];
    
    return [WXApi sendReq:req];
}

#pragma mark WXApiDelegate
-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSInteger error = resp.errCode;
        if(error != 0){
            NSString *msgError = resp.errStr;
            if(msgError){
                KFLog_Normal(YES, @"%@",msgError);
                [UtilTool showAlertView:nil message:msgError delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        }else{
            [UtilTool showAlertView:nil message:@"微信分享成功" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
}
@end
