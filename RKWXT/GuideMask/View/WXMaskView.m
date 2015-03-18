//
//  WXMaskView.m
//  CallTesting
//
//  Created by le ting on 5/17/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXMaskView.h"

@interface WXMaskView()
{
    WXUIImageView *_imageView;
}
@end

@implementation WXMaskView
@synthesize delegate = _delegate;

- (void)dealloc{
    RELEASE_SAFELY(_imageView);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        _imageView = [[WXUIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)isClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(maskViewIsClicked)]){
        [_delegate maskViewIsClicked];
    }
}

@end
