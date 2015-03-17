//
//  WXImageClipVC.m
//  Woxin2.0
//
//  Created by le ting on 6/17/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXImageClipVC.h"
#import "KICropImageView.h"
#import "CrystalNavigationView.h"

@interface WXImageClipVC ()
{
    KICropImageView *_clipView;
    CrystalNavigationView *_navBar;
}
@end

@implementation WXImageClipVC
@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize clipSize = _clipSize;

- (void)dealloc{
    _delegate = nil;
    RELEASE_SAFELY(_navBar);
    RELEASE_SAFELY(_clipView);
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _clipView = [[KICropImageView alloc] initWithFrame:self.bounds];
    [_clipView setCropSize:_clipSize];
    [_clipView setImage:_image];
    [self addSubview:_clipView];
    
    _navBar = [[CrystalNavigationView cstWXNavigationView] retain];
    [self addSubview:_navBar];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClip) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_navBar setLeftNavigationItem:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [confirmBtn setTitle:@"使用" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(finishClip) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_navBar setRightNavigationItem:confirmBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_clipView addGestureRecognizer:tap];
    RELEASE_SAFELY(tap);
}

- (void)tap{
    [_navBar changeShown];
}

- (void)cancelClip{
    if(_delegate && [_delegate respondsToSelector:@selector(imageClipCanceled:)]){
        [_delegate imageClipCanceled:self];
    }
}

- (void)finishClip{
    UIImage *img = _clipView.cropImage;
    if(img){
        if(_delegate && [_delegate respondsToSelector:@selector(imageClipFinshed:image:)]){
            [_delegate imageClipFinshed:self image:img];
        }
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(imageClipFailed:)]){
            [_delegate imageClipFailed:self];
        }
    }
}

@end

