//
//  WXUIView.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"

@interface WXUIView()
{
    WXUIImageView *_bgImageView;
}
@end

@implementation WXUIView
@synthesize backGroundView = _bgImageView;

- (void)dealloc{
    RELEASE_SAFELY(_bgImageView);
	RELEASE_SAFELY(_idTag);
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[WXUIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_bgImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_bgImageView];
    }
    return self;
}


- (id)init{
    if(self = [super init]){
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage*)image{
    [_bgImageView setImage:image];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [_bgImageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

@end
