//
//  WXPopAlertView.m
//  CallTesting
//
//  Created by le ting on 5/12/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXPopAlertView.h"
#import "UIImage+Render.h"
#import "WXColorConfig.h"

#define kTipWidth (150.0)
#define kTipXGap (5.0)
#define kTipYGap (10.0)

#define kTipUnfadeDur (0.5)
#define kTipFadeDur (0.3)
//展示时间
#define kTipShowTime (3.0)

@interface WXPopAlertView()
{
    WXUIView *_baseView;
    WXUILabel *_tipLabel;
    UITapGestureRecognizer *_tap;
}
@end

@implementation WXPopAlertView
@synthesize direction = _direction;
@synthesize tipFont = _tipFont;
@synthesize tipColor = _tipColor;
@synthesize showTime = _showTime;

- (void)dealloc{
    RELEASE_SAFELY(_tipLabel);
    RELEASE_SAFELY(_baseView);
    RELEASE_SAFELY(_tap);
    [super dealloc];
}

- (id)initWithTip:(NSString*)tip{
    if(self = [super init]){
        _direction = WXPopAlertDirection_Center;
        
        UIWindow *window = [self keyWindow];
        CGSize sizeKeyWindow = window.frame.size;
        [self setFrame:CGRectMake(0, 0, sizeKeyWindow.width, sizeKeyWindow.height)];
        
        _baseView = [[WXUIView alloc] initWithFrame:CGRectMake(0, 0, 200, 10)];
		UIImage *bgImage = [UIImage imageFromColor:kOtherColor(E_App_Other_Color_NavBar)];
        [_baseView setBackgroundImage:bgImage];
        [self addSubview:_baseView];
        
        _tipLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(kTipXGap, kTipYGap, kTipWidth, 20)];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipLabel setMutiLine];
        [_tipLabel setText:tip];
        [_baseView addSubview:_tipLabel];
        
        [self setAlpha:0.0];
    }
    return self;
}

+ (NSMutableArray*)sharedTipViewArray{
    static dispatch_once_t onceToken;
    static NSMutableArray *tipViewArray = nil;
    dispatch_once(&onceToken, ^{
        tipViewArray = [[NSMutableArray alloc] init];
    });
    return tipViewArray;
}

- (UIFont*)defaultTipFont{
    return [UIFont systemFontOfSize:12.0];
}

- (UIColor*)defaultTipColor{
    return [UIColor blackColor];
}


- (UIColor*)tipColor{
    UIColor *aTipColor = _tipColor;
    if(!aTipColor){
        aTipColor = [self defaultTipColor];
    }
    return aTipColor;
}

- (UIFont*)tipFont{
    UIFont *aTipFont = _tipFont;
    if(!aTipFont){
        aTipFont = [self defaultTipFont];
    }
    return aTipFont;
}

- (CGFloat)showTime{
    CGFloat aShowTime = _showTime;
    if(aShowTime <= 0.01){
        aShowTime = kTipShowTime;
    }
    return aShowTime;
}

- (CGRect)baseViewRect:(CGSize)baseViewSize{
    CGRect rect = CGRectMake(0, 0, baseViewSize.width, baseViewSize.height);
    CGFloat x = (self.bounds.size.width - baseViewSize.width)*0.5;
    rect.origin.x = x;
    switch (_direction) {
        case WXPopAlertDirection_Up:
            break;
        case WXPopAlertDirection_Center:
            rect.origin.y = (self.bounds.size.height - baseViewSize.height)*0.5;
            break;
        default:
            break;
    }
    return rect;
}

- (UIWindow*)keyWindow{
    return [[[UIApplication sharedApplication] windows] lastObject];
//    return [[UIApplication sharedApplication] keyWindow];
}

- (void)show{
    UIFont *aTipFont = [self tipFont];
    CGFloat tipWidth = kTipWidth;
    CGFloat tipHeight = [_tipLabel.text stringHeight:aTipFont width:tipWidth];
    CGSize tipSize = CGSizeMake(tipWidth, tipHeight);
    
    CGRect tipRect = CGRectMake(kTipXGap, kTipYGap, tipSize.width, tipSize.height);
    [_tipLabel setFrame:tipRect];
    [_tipLabel setTextColor:[self tipColor]];
    [_tipLabel setFont:[self tipFont]];
    
    CGSize baseViewSize = CGSizeMake(tipSize.width +kTipXGap*2, kTipYGap*2 + tipSize.height);
    [_baseView setFrame:[self baseViewRect:baseViewSize]];
    
    UIWindow *keyWindow = [self keyWindow];
    [keyWindow addSubview:self];
    [self unfadeToKeyWindowAnimation];
}

- (void)unfadeToKeyWindowAnimation{
    [UIView animateWithDuration:kTipUnfadeDur animations:^{
        [self setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self addTap];
        [self addTimeoutAction];
    }];
}

- (void)addTap{
    if(_tap){
        [self removeGestureRecognizer:_tap];
        RELEASE_SAFELY(_tap);
    }
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:_tap];
}

- (void)tapAction{
    [self fadeFromKeyWindowAnimation];
}

- (void)removeTap{
    if(_tap){
        [self removeGestureRecognizer:_tap];
        RELEASE_SAFELY(_tap)
    }
}

- (void)fadeFromKeyWindowAnimation{
    [self removeTimeOutAction];
    [self removeTap];
    
    [UIView animateWithDuration:kTipFadeDur animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)addTimeoutAction{
    [self performSelector:@selector(fadeFromKeyWindowAnimation) withObject:self afterDelay:kTipShowTime];
}

- (void)removeTimeOutAction{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
@end
