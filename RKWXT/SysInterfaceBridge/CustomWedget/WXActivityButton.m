//
//  WXActivityButton.m
//  CallTesting
//
//  Created by le ting on 5/12/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXActivityButton.h"

@interface WXActivityButton()
{
    WXUIButton *_btn;
    WXUIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation WXActivityButton
@synthesize state = _state;

- (void)dealloc{
//    RELEASE_SAFELY(_btn);
//    RELEASE_SAFELY(_activityIndicatorView);
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame buttonType:(UIButtonType)buttonType{
    if(self = [super initWithFrame:frame]){
        CGSize size = frame.size;
        _btn = [WXUIButton buttonWithType:buttonType] ;
        [_btn setFrame:CGRectMake(0, 0, size.width, size.height)];
        [self addSubview:_btn];
        
        _activityIndicatorView = [[WXUIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_activityIndicatorView setHidden:YES];
        [self addSubview:_activityIndicatorView];
    }
    return self;
}

- (void)setTitle:(NSString*)title forState:(UIControlState)state{
    [_btn setTitle:title forState:state];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [_btn setImage:image forState:state];
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    [_btn setBackgroundImage:image forState:state];
}

- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state{
    [_btn setTitleColor:color forState:state];
}
- (void)setTitleFont:(UIFont*)font{
    [_btn.titleLabel setFont:font];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [_btn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setEnable:(BOOL)enable{
    [_btn setEnabled:enable];
}

- (void)startGetBtnStatus{
    [_activityIndicatorView setHidden:NO];
    [_activityIndicatorView startAnimating];
}
- (void)stopGetBtnStatus{
    [_activityIndicatorView setHidden:YES];
    [_activityIndicatorView stopAnimating];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGSize size = frame.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [_btn setFrame:rect];
    [_activityIndicatorView setFrame:rect];
}

@end
