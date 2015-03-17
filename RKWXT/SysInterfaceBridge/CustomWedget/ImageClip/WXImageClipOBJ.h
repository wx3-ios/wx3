//
//  WXImageClipeOBJ.h
//  Woxin2.0
//
//  Created by le ting on 6/17/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXImageClipOBJDelegate;
@interface WXImageClipOBJ : NSObject
@property (nonatomic,retain)WXUIViewController *parentVC;
//定位用的~
@property (nonatomic,retain)id tagInfo;
//设置图片的尺寸~
@property (nonatomic,assign)E_Image_Type clipImageType;
@property (nonatomic,assign)id<WXImageClipOBJDelegate>delegate;

//开始选取和裁剪图片
- (void)beginChooseAndClipeImage;
@end

@protocol WXImageClipOBJDelegate <NSObject>
@optional
- (void)imageClipeFinished:(WXImageClipOBJ*)clipOBJ finalImageData:(NSData*)imageData;
- (void)imageClipeCanceled:(WXImageClipOBJ*)clipOBJ;
- (void)imageClipeFailed:(WXImageClipOBJ*)clipOBJ;
@end
