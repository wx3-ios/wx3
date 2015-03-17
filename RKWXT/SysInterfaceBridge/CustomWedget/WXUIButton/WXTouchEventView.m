//
//  WXTouchEventView.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXTouchEventView.h"

@interface WXTouchEventView(){
    SEL _touchDownAction;
    id  _touchDownActionTarget;
    SEL _dragInsideAction;
    id  _dragInsideActionTarget;
    SEL _dragOutsideAction;
    id  _dragOutsideActionTarget;
    SEL _upInsideAction;
    id  _upInsideActionTarget;
    SEL _upOutsideAction;
    id  _upOutsideActionTarget;
    SEL _touchCanceledAction;
    id  _touchCanceledActionTarget;
    
    BOOL _enabled;
}

@property (nonatomic,assign)BOOL isInside;
@end

@implementation WXTouchEventView
@synthesize enabled = _enabled;

- (void)dealloc{
    
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _enabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enabled = YES;
    }
    return self;
}

- (void)addtarget:(id)target action:(SEL)action forControlEvent:(UITouchControlEvent)controlEvent{
    if(controlEvent < UITouchControl_TouchDown || UITouchControl_Invalid <=controlEvent){
        KFLog_Normal(YES, @"无效的controlEvent");
        return;
    }
    switch (controlEvent) {
        case UITouchControl_TouchDown:
            _touchDownAction = action;
            _touchCanceledActionTarget = target;
            break;
        case UITouchControl_DragInside:
            _dragInsideAction = action;
            _dragInsideActionTarget = target;
            break;
        case UITouchControl_DragOutside:
            _dragOutsideAction = action;
            _dragOutsideActionTarget = target;
            break;
        case UITouchControl_UpInside:
            _upInsideAction = action;
            _upInsideActionTarget = target;
            break;
        case UITouchControl_UpOutSide:
            _upOutsideAction = action;
            _upOutsideActionTarget = target;
            break;
        case UITouchControl_Canceled:
            _touchCanceledAction = action;
            _touchCanceledActionTarget = target;
            break;
        default:
            break;
    }
}

- (BOOL)isTouchesInside:(NSSet*)touches{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    CGRect rect = self.bounds;
    if(CGRectContainsPoint(rect, pt)){
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setIsInside:[self isTouchesInside:touches]];
    if(self.isInside){
        [self touchDown];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchCanceled];
    [self setIsInside:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([self isInside]){
        [self touchUpInside];
    }else{
        [self touchUpOutside];
    }
    [self setIsInside:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL inside = [self isTouchesInside:touches];
    if(inside != [self isInside]){
        if(inside){
            [self touchDragInside];
        }else{
            [self touchDragOutside];
        }
        [self setIsInside:inside];
    }
}

- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    [self setUserInteractionEnabled:enabled];
}

- (BOOL)isEnabled{
    return [self isUserInteractionEnabled];
}

#pragma mark touch action
- (void)touchDown{
    if(_touchDownAction){
        [_touchDownActionTarget performSelector:_touchDownAction withObject:self];
    }
}

- (void)touchDragInside{
    if(_dragInsideAction){
        [_dragInsideActionTarget performSelector:_dragInsideAction withObject:self];
    }
}

- (void)touchDragOutside{
    if(_dragOutsideAction){
        [_dragOutsideActionTarget performSelector:_dragOutsideAction withObject:self];
    }
}

- (void)touchUpInside{
    if(_upInsideAction){
        [_upInsideActionTarget performSelector:_upInsideAction withObject:self];
    }
}

- (void)touchUpOutside{
    if(_upOutsideAction){
        [_upOutsideActionTarget performSelector:_upOutsideAction withObject:self];
    }
}

- (void)touchCanceled{
    if(_touchCanceledAction){
        [_touchCanceledActionTarget performSelector:_touchCanceledAction withObject:self];
    }
}

- (BOOL)onlyTouchUpInside{
    return NO;
}
@end
