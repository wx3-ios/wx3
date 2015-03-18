//
//  WXMaskView.h
//  CallTesting
//
//  Created by le ting on 5/17/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"

@protocol WXMaskViewDelegate;
@interface WXMaskView : WXUIView
@property(nonatomic,assign)id<WXMaskViewDelegate>delegate;

@end

@protocol WXMaskViewDelegate <NSObject>
- (void)maskViewIsClicked;
@end
