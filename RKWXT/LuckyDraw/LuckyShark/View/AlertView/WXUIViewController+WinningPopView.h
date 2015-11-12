//
//  WXUIViewController+WinningPopView.h
//  RKWXT
//
//  Created by SHB on 15/11/12.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

@protocol WinningPopupAnimation<NSObject>
@required
-(void)showViewL:(UIView*)popupView overlayView:(UIView*)overlayView;
-(void)dismissView:(UIView*)popupView overlayView:(UIView*)overlayView completion:(void (^)(void))completion;

@end

@interface WXUIViewController (WinningPopView)
@property (nonatomic,strong,readonly) UIView *popupView;
@property (nonatomic,strong,readonly) UIView *overlayView;
@property (nonatomic,assign,readonly) id<WinningPopupAnimation>popupAnimation;

-(void)presentPopupView:(UIView*)popupView animation:(id<WinningPopupAnimation>)animation;
-(void)presentPopupView:(UIView*)popupView animation:(id<WinningPopupAnimation>)animation dismissed:(void(^)(void))dismissed;

- (void)dismissPopupView;
- (void)dismissPopupViewWithanimation:(id<WinningPopupAnimation>)animation;

@end
