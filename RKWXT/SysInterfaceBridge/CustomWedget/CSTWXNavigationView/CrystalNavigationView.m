//
//  CrystalNavigationView.m
//  Woxin2.0
//
//  Created by le ting on 6/17/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CrystalNavigationView.h"

#define kAnimationDur (0.3)

@interface CrystalNavigationView()
{
    UIView *_maskView;
    
    BOOL _isShow;
    BOOL _isInAnimation;
}
@end

@implementation CrystalNavigationView

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundImage:nil];
        [self.backGroundView setBackgroundColor:[UIColor blackColor]];
        [self.backGroundView setAlpha:0.6];
    }
    return self;
}

- (void)changeShown{
    [self setShown:!_isShow];
}

- (void)setShown:(BOOL)shown{
    if(_isInAnimation){
        return;
    }
    
    if(shown == _isShow){
        return;
    }
    
    CGFloat alpha = 0.0;
    if(shown){
        alpha = 1.0;
    }
    
    _isInAnimation = YES;
    [UIView animateWithDuration:kAnimationDur animations:^{
        [self setAlpha:alpha];
    } completion:^(BOOL finished) {
        _isShow = shown;
        _isInAnimation = NO;
    }];
}

@end
