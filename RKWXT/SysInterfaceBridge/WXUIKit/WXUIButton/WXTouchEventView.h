//
//  WXTouchEventView.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"

typedef enum {
    UITouchControl_TouchDown = 0,
    UITouchControl_DragInside,
    UITouchControl_DragOutside,
    UITouchControl_UpInside,
    UITouchControl_UpOutSide,
    UITouchControl_Canceled,
    
    UITouchControl_Invalid,
}UITouchControlEvent;

@interface WXTouchEventView : WXUIView
@property (nonatomic,assign)BOOL enabled;

- (void)addtarget:(id)target action:(SEL)action forControlEvent:(UITouchControlEvent)controlEvent;

#pragma mark private methode
- (void)touchDown;
- (void)touchDragInside;
- (void)touchDragOutside;
- (void)touchUpInside;
- (void)touchUpOutside;
- (void)touchCanceled;
@end
