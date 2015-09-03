/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "RoundImageView.h"
@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}


- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder options:options autonDownloadImage:YES];
}
- (void)setImageWithURL:(NSURL *)url autonDownloadImage:(BOOL)autonDownloadImage
{
    [self setImageWithURL:url placeholderImage:nil autonDownloadImage:autonDownloadImage];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder autonDownloadImage:(BOOL)autonDownloadImage
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 autonDownloadImage:autonDownloadImage];
}
//club 无图模式 设置默认视图
- (BOOL)setImageWithClubURL:(NSURL *)url placeholderImage:(ClubNoImgPlaceholderView *)placeholderView autonDownloadImage:(BOOL)autonDownloadImage
{
    [self deletePlaceholderView];
    return [self setImageWithClubURL:url placeholderImage:placeholderView options:0 autonDownloadImage:autonDownloadImage];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options autonDownloadImage:(BOOL)autonDownloadImage
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    if (url)
    {
        UIImage *cachedImage = [manager imageWithURL:url]; // 将需要缓存的图片加载进来
        if (cachedImage) {
            // 如果Cache命中，则直接利用缓存的图片进行有关操作
            // Use the cached image immediatly
            if ([self isKindOfClass:[RoundImageView class]]) {
//                cachedImage = [cachedImage roundCorners];
            }
            self.image = cachedImage;
        } else {
            // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
            // Start an async download
            self.image = placeholder;
            if (!autonDownloadImage) {
                //无图模式不下载图片
                return;
            }
            [manager downloadWithURL:url delegate:self options:options];
        }
        
    }else{
        self.image = placeholder;
    }
}
#pragma mark- 修改使用在Club 无图模式 返回是否有缓存图片
- (BOOL)setImageWithClubURL:(NSURL *)url placeholderImage:(ClubNoImgPlaceholderView *)placeholder options:(SDWebImageOptions)options autonDownloadImage:(BOOL)autonDownloadImage
{
    BOOL hasImg = NO;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (url)
    {
        UIImage *cachedImage = [manager imageWithURL:url]; // 将需要缓存的图片加载进来
        if (cachedImage) {
            // 如果Cache命中，则直接利用缓存的图片进行有关操作
            // Use the cached image immediatly
            if ([self isKindOfClass:[RoundImageView class]]) {
//                cachedImage = [cachedImage roundCorners];
            }
            self.image = cachedImage;
            hasImg = YES;
        } else {
            // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
            // Start an async download
            if (placeholder) {
                [self addSubview:placeholder];
            }
            if (!autonDownloadImage) {
                //无图模式不下载图片
                hasImg = NO;
                return hasImg;
            }
            [manager downloadWithURL:url delegate:self options:options];
            hasImg = YES;
        }
        
    }else{
        hasImg = NO;
        if (placeholder) {
            [self addSubview:placeholder];
        }
    }
    return hasImg;
}

//删除默认子视图
- (void)deletePlaceholderView {
    /**遍历子视图 并删掉默认视图*/
    for (id view in self.subviews) {
        if ([view isKindOfClass:[ClubNoImgPlaceholderView class]]) {
//            [view remove];
        }
    }
}


#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (url)
    {
        UIImage *cachedImage = [manager imageWithURL:url]; // 将需要缓存的图片加载进来
        if (cachedImage) {
            // 如果Cache命中，则直接利用缓存的图片进行有关操作
            // Use the cached image immediatly
            if ([self isKindOfClass:[RoundImageView class]]) {
//                cachedImage = [cachedImage roundCorners];
            }
            self.image = cachedImage;
        } else {
            // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
            // Start an async download
            self.image = placeholder;
           [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
        }
        
    }else{
        self.image = placeholder;
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self deletePlaceholderView];
    if (image) {
        if ([self isKindOfClass:[RoundImageView class]]) {
//            image = [image roundCorners];
        }
        self.image = image;
    }    
}

/** V2.0 拓展 设置本地圆角图片*/
- (void)setRoundImage:(UIImage *)img
{
    if (img) {
        if ([self isKindOfClass:[RoundImageView class]]) {
//            img = [img roundCorners];
        }
        self.image = img;
    }
}

@end
