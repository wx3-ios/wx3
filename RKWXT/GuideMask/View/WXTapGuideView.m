//
//  WXTapGuideView.m
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXTapGuideView.h"

@interface WXTapGuideView()
{
    WXMaskView *_maskView;
    WXUIImageView *_imgView;
}
@end

@implementation WXTapGuideView
@synthesize delegate = _delegate;

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image{
    if(self = [super initWithFrame:frame]){
        CGSize size = frame.size;
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        _maskView = [[WXMaskView alloc] initWithFrame:rect];
        [self addSubview:_maskView];
        
        _imgView = [[WXUIImageView alloc] initWithFrame:rect];
        [_imgView setImage:image];
        [self addSubview:_imgView];
    }
    return self;
}

- (void)setDelegate:(id<WXMaskViewDelegate>)delegate{
    [_maskView setDelegate:delegate];
}

- (id<WXMaskViewDelegate>)delegate{
    return [_maskView delegate];
}

@end
