//
//  WXRemotImageView.m
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXBaseRemotImageView.h"
//#import "URLDownloadOBJ.h"

#define kImageInitFileName @"initImage.png"
#define kImageFailedFileName @"failedImage.png"

@interface WXBaseRemotImageView()
{
    WXUIActivityIndicatorView *_activityIndicatorView;
    
    UIImage *_initImage;
    UIImage *_failedImage;
}
@property (nonatomic,assign)BOOL loadFailed;
@end

@implementation WXBaseRemotImageView
@synthesize initiImage = _initImage;
@synthesize failedImage = _failedImage;

//- (void)dealloc{
//    [self removeOBS];
//    RELEASE_SAFELY(_activityIndicatorView);
//    RELEASE_SAFELY(_initImage);
//    RELEASE_SAFELY(_failedImage);
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addOBS];
        _activityIndicatorView = [[WXUIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_activityIndicatorView setHidden:YES];
        CGPoint pt = CGPointMake(CGRectGetWidth(frame)*0.5, CGRectGetHeight(frame)*0.5);
        [_activityIndicatorView setCenter:pt];
        [self addSubview:_activityIndicatorView];
        
        _initImage = [UIImage imageNamed:kImageInitFileName] ;
        _failedImage = [UIImage imageNamed:kImageFailedFileName] ;
    }
    return self;
}

- (void)addOBS{
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self selector:@selector(downloadFailed:) name:kURLDownloadOBJError object:nil];
//    [notificationCenter addObserver:self selector:@selector(downloadSucceed:) name:kURLDownloadOBJFinished object:nil];
}

//- (void)downloadSucceed:(NSNotification*)notification{
//    URLNetNotificationOBJ *obj = notification.object;
//    NSString *urlString = obj.urlString;
//    if([urlString isEqualToString:[self remoteImageURLString]]){
//        NSData *data = obj.object;
//        UIImage *image = [UIImage imageWithData:data];
//        [self fetchImageSucceed:data];
//        [self setImage:image];
//    }
//}

//- (void)downloadFailed:(NSNotification*)notification{
//    URLNetNotificationOBJ *obj = notification.object;
//    NSString *urlString = obj.urlString;
//    if([urlString isEqualToString:[self remoteImageURLString]]){
//        [self fetchImageFailed];
//    }
//}

- (void)removeOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)showAnimate:(BOOL)show{
    [_activityIndicatorView setHidden:!show];
    if(show){
        [_activityIndicatorView startAnimating];
    }else{
        [_activityIndicatorView stopAnimating];
    }
}

- (NSString*)remoteImageURLString{
    return nil;
}

//获取图片失败
- (void)fetchImageFailed{
    [self showAnimate:NO];
    _loadFailed = YES;
}
//获取图片成功
- (void)fetchImageSucceed:(NSData*)imageData{
    //如果图片获取成功了~ 就不需要检测了~
//    [self removeOBS];
    [self showAnimate:NO];
    _loadFailed = NO;
}
//开始获取远程图片
- (void)startFetchImage{
    [self showAnimate:YES];
}

- (UIImage*)remotionImageFromLocal{
    return nil;
}

- (void)load{
    UIImage *img = [self remotionImageFromLocal];
    if(img){
        [self setIcon:nil];
        [self setImage:img];
//        //如果图片获取成功了~ 就不需要检测了~
//        [self removeOBS];
    }else{
        if(_loadFailed){
            img = self.failedImage;
            if(!img){
                img = [UIImage imageNamed:kImageFailedFileName];
            }
        }else{
            img = self.initiImage;
            if(!img){
                img = [UIImage imageNamed:kImageInitFileName];
            }
        }
        [self setImage:nil];
        [self setIcon:img];
//        [self startFetchImage];
//        [[URLDownloadOBJ sharedURLDownloadOBJ] downloadRemotionFile:[self remoteImageURLString] key:self.cpxViewInfo];
    }
}
@end
