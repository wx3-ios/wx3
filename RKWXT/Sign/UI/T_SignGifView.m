//
//  T_SignGifView.m
//  Woxin3.0
//
//  Created by SHB on 15/1/23.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_SignGifView.h"

@interface T_SignGifView(){
    UIImageView *_animateImgView;
}

@end

@implementation T_SignGifView

-(void)dealloc{
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _animateImgView= [[UIImageView alloc] initWithFrame:self.frame];
        NSArray *imgArray = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"sign1.png"],
                             [UIImage imageNamed:@"sign2.png"],
                             [UIImage imageNamed:@"sign3.png"],
                             [UIImage imageNamed:@"sign4.png"],
                             [UIImage imageNamed:@"sign5.png"],
                             [UIImage imageNamed:@"sign6.png"],
                             [UIImage imageNamed:@"sign7.png"],
                             [UIImage imageNamed:@"sign8.png"],
                             [UIImage imageNamed:@"sign9.png"],
                             [UIImage imageNamed:@"sign10.png"],
                             [UIImage imageNamed:@"sign11.png"],
                             [UIImage imageNamed:@"sign12.png"],
                             [UIImage imageNamed:@"sign13.png"],
                             [UIImage imageNamed:@"sign14.png"],
                             [UIImage imageNamed:@"sign15.png"],
                             [UIImage imageNamed:@"sign17.png"],
                             [UIImage imageNamed:@"sign18.png"],
                             [UIImage imageNamed:@"sign19.png"],
                             [UIImage imageNamed:@"sign20.png"],
                             [UIImage imageNamed:@"sign21.png"],
                             [UIImage imageNamed:@"sign22.png"],
                             [UIImage imageNamed:@"sign23.png"],
                             [UIImage imageNamed:@"sign24.png"],
                             [UIImage imageNamed:@"sign25.png"],
                             [UIImage imageNamed:@"sign26.png"],
                             [UIImage imageNamed:@"sign27.png"],
                             [UIImage imageNamed:@"sign28.png"],
                             [UIImage imageNamed:@"sign29.png"],
                             [UIImage imageNamed:@"sign30.png"],
                             [UIImage imageNamed:@"sign31.png"],
                             [UIImage imageNamed:@"sign32.png"],
                             [UIImage imageNamed:@"sign33.png"],
                             [UIImage imageNamed:@"sign34.png"],
                             nil, nil];
        [_animateImgView setAnimationImages:imgArray];
        _animateImgView.animationDuration = kAnimateDuration;
        _animateImgView.animationRepeatCount = 1;
        [_animateImgView startAnimating];
        [self addSubview:_animateImgView];
        [self performSelector:@selector(animateDidFinished) withObject:nil afterDelay:kAnimateDuration+0.3];
    }
    return self;
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    _delegate = nil;
}

- (void)animateDidFinished{
    [_animateImgView stopAnimating];
    if (_delegate && [_delegate respondsToSelector:@selector(animationDidFinised)]){
        [_delegate animationDidFinised];
    }
    if ([self superview]){
        [self removeFromSuperview];
    }
}

@end
