//
//  WXTWaitingHud.h
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTWaitingHud : UIView

- (void)setText:(NSString*)text;
- (id)initWithParentView:(UIView*)parentView;

- (void)startAnimate;
- (void)stopAniamte;

@end
