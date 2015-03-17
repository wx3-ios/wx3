//
//  WXFileManager.h
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    //web页的图片之类的缓存
    E_WXFileCache_WebFile = 0,
    //系统推送上面的图片的缓存
    E_WXFileCache_SysPushMsgFile,
    //IM上的图片
    E_WXFileCache_IMImage,
    //IM上的语音
    E_WXFileCache_IMAudio,
    
    E_WXFileCache_Invalid,
}E_WXFileCacheType;

@interface WXFileManager : NSObject
{
    //缓存
    NSCache *_cache;
}

+ (WXFileManager*)sharedWXFileManager;

#pragma mark 缓存图片语音之类的~ 以后可能要存在本地
- (void)cacheData:(NSData*)data cacheType:(E_WXFileCacheType)cacheType forString:(NSString*)str;
- (NSData*)cacheDataType:(E_WXFileCacheType)type forString:(NSString*)str;
@end
