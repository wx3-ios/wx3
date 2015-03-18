//
//  WXUINavigationController.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUINavigationController.h"
#import <QuartzCore/QuartzCore.h>


#define kAnimationDuration 0.2
#define kAnimationDelay 0.0f
#define kMaxBlackMaskAlpha 0.1f

typedef enum {
    PanDirectionNone = 0,
    PanDirectionLeft = 1,
    PanDirectionRight = 2
} PanDirection;

@interface WXUINavigationController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *_gestures;
    UIView *_blackMask;
    CGPoint _panOrigin;
    BOOL _animationInProgress;
    CGFloat _percentageOffsetFromLeft;
}

- (void) addPanGestureToView:(UIView*)view;
- (void) rollBackViewController;

- (UIViewController *)currentViewController;
- (UIViewController *)previousViewController;

- (void) transformAtPercentage:(CGFloat)percentage ;
- (void) completeSlidingAnimationWithDirection:(PanDirection)direction;
- (void) completeSlidingAnimationWithOffset:(CGFloat)offset;
- (CGRect) getSlidingRectWithPercentageOffset:(CGFloat)percentage orientation:(UIInterfaceOrientation)orientation ;
- (CGRect) viewBoundsWithOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation WXUINavigationController

- (id) initWithRootViewController:(UIViewController*)rootViewController {
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray arrayWithObject:rootViewController];
    }
    return self;
}

- (void) dealloc {
    self.viewControllers = nil;
    _gestures  = nil;
    _blackMask = nil;
//    [super dealloc];
}

#pragma mark - Load View
- (void) loadView {
    [super loadView];
    CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
    
    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
    [rootViewController willMoveToParentViewController:self];
    [self addChildViewController:rootViewController];
    
    UIView * rootView = rootViewController.view;
    rootView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    rootView.frame = viewRect;
    [self.view addSubview:rootView];
    [rootViewController didMoveToParentViewController:self];
    _blackMask = [[UIView alloc] initWithFrame:viewRect];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_blackMask atIndex:0];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (UIViewController*)rootViewController{
    return [self.childViewControllers firstObject];
}

#pragma mark - PushViewController With Completion Block
- (void) pushViewController:(UIViewController *)viewController completion:(WXUINavigationControllerCompletionBlock)handler {
    _animationInProgress = YES;
    UIViewController *topVC = [self currentViewController];
    [topVC viewWillDisappear:YES];
    
    [self addChildViewController:viewController];
    viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
    viewController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _blackMask.alpha = 0.0;
    [viewController willMoveToParentViewController:self];
    [self.view bringSubviewToFront:_blackMask];
    [self.view addSubview:viewController.view];
    CGRect rect = self.view.bounds;
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        CGAffineTransform transf = CGAffineTransformIdentity;
        [self currentViewController].view.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);
        viewController.view.frame = rect;
        _blackMask.alpha = kMaxBlackMaskAlpha;
    }   completion:^(BOOL finished) {
        [topVC viewDidDisappear:YES];
        if (finished) {
            [self.viewControllers addObject:viewController];
            [viewController didMoveToParentViewController:self];
            _animationInProgress = NO;
            _gestures = [[NSMutableArray alloc] init];
            [self addPanGestureToView:[self currentViewController].view];
            if(handler){
                handler();
            }
        }
    }];
    if([viewController isKindOfClass:[WXUIViewController class]]){
        WXUIViewController *wxVC = (WXUIViewController*)viewController;
        [wxVC setBackNavigationBarItem];
    }
}

- (void) pushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController completion:^{}];
}

#pragma mark - PopViewController With Completion Block

- (void)popToRootViewControllerAnimated:(BOOL)animated Completion:(WXUINavigationControllerCompletionBlock)handler{
    [self popToViewController:self.rootViewController animated:animated Completion:handler];
}

- (void)popToViewController:(UIViewController*)viewController animated:(BOOL)animated Completion:(WXUINavigationControllerCompletionBlock)handler{
    if(!viewController){
        return;
    }
    NSArray *childrenControllers = self.childViewControllers;
    NSInteger index = [childrenControllers indexOfObject:viewController];
    if(index == NSNotFound){
        return;
    }
    NSInteger count = [childrenControllers count];
    //如果是最顶端的viewcontroller
    if(index == count - 1){
        return;
    }
    
    NSArray *spareVCArray = [childrenControllers subarrayWithRange:NSMakeRange(index+1, count-index-1)];
    
    _animationInProgress = YES;
    UIViewController *currentVC = [self currentViewController];
    [viewController viewWillAppear:NO];
    if(animated){
        for(WXUIViewController *vc in spareVCArray){
            if(![vc isEqual:currentVC]){
                [vc.view removeFromSuperview];
            }
        }
        [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
            currentVC.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
            CGAffineTransform transf = CGAffineTransformIdentity;
            viewController.view.transform = CGAffineTransformScale(transf, 1.0, 1.0);
            viewController.view.frame = self.view.bounds;
            _blackMask.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [currentVC.view removeFromSuperview];
                [self.view bringSubviewToFront:viewController.view];
                for(UIViewController *vc in spareVCArray){
                    [vc removeFromParentViewController];
                    [vc didMoveToParentViewController:nil];
                }
                [self.viewControllers removeObjectsInArray:spareVCArray];
                _animationInProgress = NO;
                [viewController viewDidAppear:NO];
                handler();
            }
        }];
    }else{
        currentVC.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
        CGAffineTransform transf = CGAffineTransformIdentity;
        viewController.view.transform = CGAffineTransformScale(transf, 1.0, 1.0);
        viewController.view.frame = self.view.bounds;
        _blackMask.alpha = 0.0;
        
        
        [currentVC.view removeFromSuperview];
        [self.view bringSubviewToFront:viewController.view];
        for(UIViewController *vc in spareVCArray){
            [vc removeFromParentViewController];
            [vc didMoveToParentViewController:nil];
        }
        [self.viewControllers removeObjectsInArray:spareVCArray];
        _animationInProgress = NO;
        [viewController viewDidAppear:NO];
        handler();
    }
}

- (void)popViewControllerAnimated:(BOOL)animated completion:(WXUINavigationControllerCompletionBlock)handler{
    [self popToViewController:[self previousViewController] animated:animated Completion:handler];
}

- (void) popViewController {
    [self popViewControllerAnimated:YES completion:^{
    }];
}

- (void) rollBackViewController {
    _animationInProgress = YES;
    
    UIViewController * vc = [self currentViewController];
    UIViewController * nvc = [self previousViewController];
    CGRect rect = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:kAnimationDelay options:0 animations:^{
        CGAffineTransform transf = CGAffineTransformIdentity;
        nvc.view.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);
        vc.view.frame = rect;
        _blackMask.alpha = kMaxBlackMaskAlpha;
    }   completion:^(BOOL finished) {
        if (finished) {
            _animationInProgress = NO;
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

#pragma mark - ChildViewController
- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

#pragma mark - ParentViewController
- (UIViewController *)previousViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}

#pragma mark - Add Pan Gesture
- (void) addPanGestureToView:(UIView*)view
{
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(gestureRecognizerDidPan:)];
    panGesture.cancelsTouchesInView = YES;
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];
    [_gestures addObject:panGesture];
    panGesture = nil;
}

# pragma mark - Avoid Unwanted Vertical Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
	BOOL xBigY = fabs(translation.x) > fabs(translation.y);
	return xBigY && translation.x > 0;
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIViewController * vc =  [self.viewControllers lastObject];
    _panOrigin = vc.view.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_animationInProgress;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

#pragma mark - Handle Panning Activity

- (void) gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    if(_animationInProgress) return;
    
    CGPoint currentPoint = [panGesture translationInView:self.view];
    CGFloat x = currentPoint.x + _panOrigin.x;
    
    PanDirection panDirection = PanDirectionNone;
    CGPoint vel = [panGesture velocityInView:self.view];
    
    if (vel.x > 0) {
        panDirection = PanDirectionRight;
    } else {
        panDirection = PanDirectionLeft;
    }
    
    CGFloat offset = 0;
    UIViewController * vc = [self currentViewController];
    offset = CGRectGetWidth(vc.view.frame) - x;
    
    CGFloat limiteVel = 100;
    if([vc isKindOfClass:[WXUIViewController class]]){
        WXUIViewController *wxVC = (WXUIViewController*)vc;
        limiteVel = [wxVC currentLimitXVelocity];
        if((wxVC.dexterity == E_Slide_Dexterity_None)){
            return;
        }
    }
    
    _percentageOffsetFromLeft = offset/[self viewBoundsWithOrientation:self.interfaceOrientation].size.width;
    vc.view.frame = [self getSlidingRectWithPercentageOffset:_percentageOffsetFromLeft orientation:self.interfaceOrientation];
    [self transformAtPercentage:_percentageOffsetFromLeft];
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        // If velocity is greater than 100 the Execute the Completion base on pan direction
        if(abs(vel.x) > limiteVel) {
            [self completeSlidingAnimationWithDirection:panDirection];
        }else {
            [self completeSlidingAnimationWithOffset:offset];
        }
    }
}

#pragma mark - Set the required transformation based on percentage
- (void) transformAtPercentage:(CGFloat)percentage {
    CGAffineTransform transf = CGAffineTransformIdentity;
    CGFloat newTransformValue =  1 - (percentage*10)/100;
    CGFloat newAlphaValue = percentage* kMaxBlackMaskAlpha;
    [self previousViewController].view.transform = CGAffineTransformScale(transf,newTransformValue,newTransformValue);
    _blackMask.alpha = newAlphaValue;
}

#pragma mark - This will complete the animation base on pan direction
- (void) completeSlidingAnimationWithDirection:(PanDirection)direction {
    if(direction==PanDirectionRight){
        [self popViewController];
    }else {
        [self rollBackViewController];
    }
}

#pragma mark - This will complete the animation base on offset
- (void) completeSlidingAnimationWithOffset:(CGFloat)offset{
    
    if(offset<[self viewBoundsWithOrientation:self.interfaceOrientation].size.width/2) {
        [self popViewController];
    }else {
        [self rollBackViewController];
    }
}

#pragma mark - Get the origin and size of the visible viewcontrollers(child)
- (CGRect) getSlidingRectWithPercentageOffset:(CGFloat)percentage orientation:(UIInterfaceOrientation)orientation {
    CGRect viewRect = [self viewBoundsWithOrientation:orientation];
    CGRect rectToReturn = CGRectZero;
    UIViewController * vc;
    vc = [self currentViewController];
    rectToReturn.size = viewRect.size;
    rectToReturn.origin = CGPointMake(MAX(0,(1-percentage)*viewRect.size.width), 0.0);
    return rectToReturn;
}

#pragma mark - Get the size of view in the main screen
- (CGRect) viewBoundsWithOrientation:(UIInterfaceOrientation)orientation{
	CGRect bounds = [UIScreen mainScreen].bounds;
    if([[UIApplication sharedApplication]isStatusBarHidden]){
        return bounds;
    } else if(UIInterfaceOrientationIsLandscape(orientation)){
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
        if (!isIOS7)  {
            bounds.size.height = width - IPHONE_STATUS_BAR_HEIGHT;
        }else {
            bounds.size.height = width;
        }
        return bounds;
	}else{
        if (!isIOS7)  {
            bounds.size.height-=IPHONE_STATUS_BAR_HEIGHT;
        }
        return bounds;
    }
}
@end
