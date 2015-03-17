//
//  WXRemotionImgBtn.m
//  CallTesting
//
//  Created by le ting on 5/16/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXRemotionImgBtn.h"
#import "WXFileManager.h"

@implementation WXRemotionImgBtn
@synthesize cacheType = _cacheType;
@synthesize delegate = _delegate;

//远程图片的地址
- (NSString*)remoteImageURLString{
    return self.cpxViewInfo;
}

//获取图片失败
- (void)fetchImageFailed{
    [super fetchImageFailed];
    [self setIcon:self.failedImage];
}

//获取图片成功
- (void)fetchImageSucceed:(NSData*)imageData{
    [super fetchImageSucceed:imageData];
    [self setIcon:nil];
    
    //缓存图片
    [[WXFileManager sharedWXFileManager] cacheData:imageData cacheType:_cacheType forString:[self remoteImageURLString]];
}

//开始获取远程图片
- (void)startFetchImage{
    [super startFetchImage];
}
//远程图片
- (UIImage*)remotionImageFromLocal{
    //从缓存中获取图片
    NSString *remoteImageURLString = [self remoteImageURLString];
    if(remoteImageURLString){
        NSData *data = [[WXFileManager sharedWXFileManager] cacheDataType:_cacheType forString:[self remoteImageURLString]];
        if(data){
            return [UIImage imageWithData:data];
        }
    }
    return nil;
}

- (void)buttonClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(buttonImageClicked:)]){
        [_delegate buttonImageClicked:self];
    }
}

@end
