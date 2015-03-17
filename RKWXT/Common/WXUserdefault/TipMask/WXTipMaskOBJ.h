//
//  WXTipMaskOBJ.h
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXTipMaskOBJ : NSObject

+ (WXTipMaskOBJ*)sharedTipMaskOBJ;

- (BOOL)isHomePageTipMaskRead;
- (BOOL)isSliderSettingTipMaskRead;
- (BOOL)isKeyPadTipMaskRead;
- (BOOL)isContacteTipMaskRead;
- (BOOL)isResentTipMaskRead;

- (void)setHomepageTipMaskRead:(BOOL)isRead;
- (void)setSliderSettingTipMaskRead:(BOOL)isRead;
- (void)setKeyPadTipMaskRead:(BOOL)isRead;
- (void)setContacteTipMaskRead:(BOOL)isRead;
- (void)setResentTipMaskRead:(BOOL)isRead;
@end
