//
//  WXImageClipVC.h
//  Woxin2.0
//
//  Created by le ting on 6/17/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIViewController.h"

@protocol WXImageClipVCDelegate;
@interface WXImageClipVC : WXUIViewController
@property (nonatomic,retain)UIImage *image;
@property (nonatomic,assign)CGSize clipSize;
@property (nonatomic,assign)id<WXImageClipVCDelegate>delegate;

@end

@protocol WXImageClipVCDelegate <NSObject>

- (void)imageClipFinshed:(WXImageClipVC*)imageClipVC image:(UIImage*)image;
- (void)imageClipCanceled:(WXImageClipVC*)imageClipVC;
- (void)imageClipFailed:(WXImageClipVC*)imageClipVC;
@end
