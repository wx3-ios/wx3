//
//  WXUIViewController+WinningPopView.m
//  RKWXT
//
//  Created by SHB on 15/11/12.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIViewController+WinningPopView.h"
#import <objc/runtime.h>
#import "WinningBackgroundView.h"

#define KWXPopupView  @"KWXPopupView"
#define KWXOverlayView @"KWXOverlayView"
#define KWXPopupViewDismissedBlock @"KWXPopupViewDismissedBlock"
#define KWXPopupViewAnimation @"KWXPopupViewAnimation"

#define KWXPopupViewTag 8002
#define KWXOverlayViewTag 8003

@interface WXUIViewController ()
@property (nonatomic,strong) UIView *popupView;
@property (nonatomic,strong) UIView *overlayView;
@property (nonatomic,strong) void (^dismissCallback)(void);
@property (nonatomic,assign) id<WinningPopupAnimation>popupAnimation;
-(UIView*)topView;

@end

@implementation WXUIViewController (WinningPopView)

#pragma mark method
-(void)presentPopupView:(UIView *)popupView animation:(id<WinningPopupAnimation>)animation{
    [self _presentPopupView:popupView animation:animation dismissed:nil];
}

-(void)presentPopupView:(UIView *)popupView animation:(id<WinningPopupAnimation>)animation dismissed:(void (^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation dismissed:dismissed];
}

-(void)dismissPopupViewWithanimation:(id<WinningPopupAnimation>)animation{
    [self _dismissPopupViewWithAnimation:animation];
}

-(void)dismissPopupView{
    [self _dismissPopupViewWithAnimation:self.popupAnimation];
}

#pragma mark - inline property
- (UIView *)popupView {
    return objc_getAssociatedObject(self, KWXPopupView);
}

- (void)setPopupView:(UIViewController *)popupView {
    objc_setAssociatedObject(self, KWXPopupView, popupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlayView{
    return objc_getAssociatedObject(self, KWXOverlayView);
}

- (void)setOverlayView:(UIView *)overlayView {
    objc_setAssociatedObject(self, KWXOverlayView, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(void))dismissCallback{
    return objc_getAssociatedObject(self, KWXPopupViewDismissedBlock);
}

- (void)setDismissCallback:(void (^)(void))dismissCallback{
    objc_setAssociatedObject(self, KWXPopupViewDismissedBlock, dismissCallback, OBJC_ASSOCIATION_COPY);
}

- (id<WinningPopupAnimation>)popupAnimation{
    return objc_getAssociatedObject(self, KWXPopupViewAnimation);
}

- (void)setPopupAnimation:(id<WinningPopupAnimation>)popupAnimation{
    objc_setAssociatedObject(self, KWXPopupViewAnimation, popupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - view handle
-(void)_presentPopupView:(UIView *)popupView animation:(id<WinningPopupAnimation>)animation dismissed:(void (^)(void))dismissed{
    if ([self.overlayView.subviews containsObject:popupView]){
        return;
    }
    
    if (self.overlayView && self.overlayView.subviews.count > 1) {
        [self _dismissPopupViewWithAnimation:nil];
    }
    
    self.popupView = nil;
    self.popupView = popupView;
    self.popupAnimation = nil;
    self.popupAnimation = animation;
    
    UIView *sourceView = [self topView];
    
    // customize popupView
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = KWXPopupViewTag;
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
//    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add overlay
    if (self.overlayView == nil) {
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.tag = KWXPopupViewTag;
        overlayView.backgroundColor = [UIColor clearColor];
        
        // BackgroundView
        UIView *backgroundView = [[WinningBackgroundView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor clearColor];
        [overlayView addSubview:backgroundView];
        
        // Make the Background Clickable
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPopupView)];
//        [backgroundView addGestureRecognizer:tap];
        self.overlayView = overlayView;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPopupView) name:@"closeWinningViewNoti" object:nil];
    
    [self.overlayView addSubview:popupView];
    [sourceView addSubview:self.overlayView];
    
    self.overlayView.alpha = 1.0f;
    popupView.center = self.overlayView.center;
    if (animation) {
        [animation showViewL:popupView overlayView:self.overlayView];
    }
    
    [self setDismissCallback:dismissed];
    
}

- (void)_dismissPopupViewWithAnimation:(id<WinningPopupAnimation>)animation{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (animation) {
        [animation dismissView:self.popupView overlayView:self.overlayView completion:^(void) {
            [self.overlayView removeFromSuperview];
            [self.popupView removeFromSuperview];
            self.popupView = nil;
            self.popupAnimation = nil;
            
            id dismissed = [self dismissCallback];
            if (dismissed != nil){
                ((void(^)(void))dismissed)();
                [self setDismissCallback:nil];
            }
        }];
    }else{
        [self.overlayView removeFromSuperview];
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        self.popupAnimation = nil;
        
        id dismissed = [self dismissCallback];
        if (dismissed != nil){
            ((void(^)(void))dismissed)();
            [self setDismissCallback:nil];
        }
    }
}

-(UIView*)topView{
    UIViewController *recentView = self;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end
