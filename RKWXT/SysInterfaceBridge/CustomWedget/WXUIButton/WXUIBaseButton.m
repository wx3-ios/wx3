//
//  WXUIBaseButton.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIBaseButton.h"

@interface WXUIBaseButton()
{
    BOOL _isSelected;
}
@end

@implementation WXUIBaseButton
@synthesize selected = _isSelected;

//先改变状态再执行action~
- (void)touchDown{
    if([self UIShouldChangedWhenTouchDown]){
        [self showSelected:!_isSelected];
    }
    [super touchDown];
}

- (void)touchDragInside{
    if([self UIShouldChangedWhenTouchDown]){
        [self showSelected:!_isSelected];
    }
    [super touchDragInside];
}

- (void)touchDragOutside{
    if([self UIShouldChangedWhenTouchDown]){
        [self showSelected:_isSelected];
    }
    [super touchDragOutside];
}
- (void)touchUpInside{
    if(_isPingpong){
        _isSelected = !_isSelected;
    }
    [self showSelected:_isSelected];
    [super touchUpInside];
}

- (void)touchUpOutside{
    if([self UIShouldChangedWhenTouchDown]){
        [self showSelected:_isSelected];
    }
    [super touchUpOutside];
}
- (void)touchCanceled{
    [self showSelected:_isSelected];
    [super touchCanceled];
}

- (void)showSelected:(BOOL)selected{
    WXButtonControlState state = WXButtonControlState_Normal;
    if(selected){
        state = WXButtonControlState_Selected;
    }
    [self showControlState:state];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if(enabled){
        [self showSelected:_isSelected];
    }else{
        [self showControlState:WXButtonControlState_Disable];
    }
}

//手动设置是否select
- (void)setSelected:(BOOL)selected{
    if(self.enabled){
        _isSelected = selected;
        [self showSelected:selected];
    }
}

- (void)showControlState:(WXButtonControlState)state{
    
}

- (BOOL)UIShouldChangedWhenTouchDown{
    return YES;
}

@end
