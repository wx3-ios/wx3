//
//  WXFileManager.m
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXFileManager.h"

#define kWebCacheFile @"webCache"
#define kSysMsgPushCacheFile @"sysMsg"
#define kIM @"IM"
#define kIMImage @"Image"
#define kIMAudio @"Audio"

@interface WXFileManager()

@end

@implementation WXFileManager

- (void)dealloc{
//    [super dealloc];
}

+ (WXFileManager*)sharedWXFileManager{
    static dispatch_once_t onceToken;
    static WXFileManager*sharedFileManager = nil;
    dispatch_once(&onceToken, ^{
        sharedFileManager = [[WXFileManager alloc] init];
    });
    return sharedFileManager;
}

- (id)init{
    if(self = [super init]){
        _cache = [[NSCache alloc] init];
    }
    return self;
}

- (NSString*)rootPathForCacheType:(E_WXFileCacheType)type{
    NSString *rootPath = [UtilTool documentPath];
    switch (type) {
        case E_WXFileCache_WebFile:
            rootPath = [rootPath stringByAppendingPathComponent:kWebCacheFile];
            break;
        case E_WXFileCache_SysPushMsgFile:
            rootPath = [rootPath stringByAppendingPathComponent:kSysMsgPushCacheFile];
            break;
        case E_WXFileCache_IMImage:
        {
            NSString *imImageSubPath = [NSString stringWithFormat:@"%@",kIM];
            imImageSubPath = [imImageSubPath stringByAppendingPathComponent:kIMImage];
            rootPath = [rootPath stringByAppendingPathComponent:imImageSubPath];
        }
            break;
        case E_WXFileCache_IMAudio:
        {
            NSString *imImageSubPath = [NSString stringWithFormat:@"%@",kIM];
            imImageSubPath = [imImageSubPath stringByAppendingPathComponent:kIMAudio];
            rootPath = [rootPath stringByAppendingPathComponent:imImageSubPath];
        }
            break;
        default:
            break;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exist = [fileManager fileExistsAtPath:rootPath isDirectory:&isDir];
    BOOL dirExist = NO;
    if(exist){
        if(isDir){
            dirExist = YES;
        }
    }
    if(!dirExist){
        NSError *error;
        if(![fileManager createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:&error]){
            KFLog_Normal(YES, @"创建缓存路径失败 error = %@",error);
        }
    }
    return rootPath;
}

- (NSString*)cacheKeyFrom:(NSString*)str{
    return [NSString stringWithFormat:@"%lu",(unsigned long)[str hash]];
}

- (BOOL)dataExistInCache:(NSString*)key{
    return [_cache objectForKey:key] != nil;
}

- (void)cacheData:(NSData*)data cacheType:(E_WXFileCacheType)cacheType forString:(NSString*)str{
    if(!data){
        KFLog_Normal(YES, @"cache nil data");
        return;
    }
    NSString *key = [self cacheKeyFrom:str];
    [_cache setObject:data forKey:key];
    
    //将数据写入到本地
    NSString *path = [self rootPathForCacheType:cacheType];
    path = [path stringByAppendingPathComponent:key];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        KFLog_Normal(YES, @"文件已经存在于本地 不需要再次保存~");
        return;
    }
    [data writeToFile:path atomically:YES];
}
- (NSData*)cacheDataType:(E_WXFileCacheType)type forString:(NSString*)str{
    NSString *key = [self cacheKeyFrom:str];
    NSData *data = [_cache objectForKey:key];
    
    //如果本地缓存没有则从本地硬盘中找~
    if(!data){
        NSString *path = [self rootPathForCacheType:type];
        path = [path stringByAppendingPathComponent:key];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //如果在本地有这个数据~ 则取出来 并且保存在本地缓存上~
        if([fileManager fileExistsAtPath:path]){
            data = [NSData dataWithContentsOfFile:path];
            [_cache setObject:data forKey:key];
        }
    }
    return data;
}

@end
