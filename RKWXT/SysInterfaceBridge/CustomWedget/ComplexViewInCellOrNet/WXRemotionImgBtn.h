//
//  WXRemotionImgBtn.h
//  CallTesting
//
//  Created by le ting on 5/16/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXBaseRemotImageView.h"

/*cpxViewInfo 是一个URL 图片的地址*/
enum E_WXFileCacheType;
@protocol WXRemotionImgBtnDelegate;
@interface WXRemotionImgBtn : WXBaseRemotImageView
@property (nonatomic,assign)E_WXFileCacheType cacheType;
@property (nonatomic,assign)id<WXRemotionImgBtnDelegate>delegate;

@end

@protocol WXRemotionImgBtnDelegate <NSObject>
- (void)buttonImageClicked:(id)sender;
@end
