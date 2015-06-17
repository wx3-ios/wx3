//
//  WXRemotImageView.h
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXCpxBtnImgView.h"

@interface WXBaseRemotImageView : WXCpxBtnImgView
@property (nonatomic,readonly)UIImage *initiImage;
@property (nonatomic,readonly)UIImage *failedImage;

#pragma mark 虚函数 在子类执行
//远程图片的地址
- (NSString*)remoteImageURLString;
//获取图片失败
- (void)fetchImageFailed;
//获取图片成功
- (void)fetchImageSucceed:(NSData*)imageDate;
//开始获取远程图片
- (void)startFetchImage;
//从本地获取远程图片
- (UIImage*)remotionImageFromLocal;
@end
