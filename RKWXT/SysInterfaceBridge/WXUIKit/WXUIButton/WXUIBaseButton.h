//
//  WXUIBaseButton.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"
#import "WXTouchEventView.h"

typedef enum {
    WXButtonControlState_Normal = 0,
    WXButtonControlState_Selected,
    WXButtonControlState_Disable,
}WXButtonControlState;

@protocol WXUIBaseButtonMark <NSObject>
- (BOOL)UIShouldChangedWhenTouchDown;
@end

@interface WXUIBaseButton :WXTouchEventView<WXUIBaseButtonMark>
@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)BOOL isPingpong;

#pragma mark private
- (void)showControlState:(WXButtonControlState)state;
@end
