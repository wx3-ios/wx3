//
//  GoodsInfoImageZoomView.h
//  RKWXT
//
//  Created by SHB on 15/9/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@interface GoodsInfoImageZoomView : UIView <UIScrollViewDelegate,SDWebImageManagerDelegate>{
    CGFloat viewscale;
    NSString *downImgUrl;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isViewing;
@property (nonatomic, strong) UIView *containerView;

- (void)resetViewFrame:(CGRect)newFrame;
- (void)updateImage:(NSString *)imgName;
- (void)uddateImageWithUrl:(NSString *)imgUrl;

@end