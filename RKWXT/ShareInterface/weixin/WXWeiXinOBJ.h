//
//  WXWeiXinOBJ.h
//  CallTesting
//
//  Created by le ting on 5/27/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    //好友分享
    E_WeiXin_Mode_Friend = 0,
    //朋友圈
    E_WeiXin_Mode_FriendGroup,
    //收藏
    E_WeiXin_Mode_Fav,
    
}E_WeiXin_Mode;

@interface WXWeiXinOBJ : NSObject

+ (WXWeiXinOBJ*)sharedWeiXinOBJ;
//注册App
- (void)registerApp;
//处理微信通过URL启动App时传递的数据
- (void)handleOpenURL:(NSURL*)url;

//发送链接
- (BOOL)sendMode:(E_WeiXin_Mode)mode title:(NSString*)title description:(NSString*)description
         linkURL:(NSString*)url thumbImage:(UIImage*)image;
@end
