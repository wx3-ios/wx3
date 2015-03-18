//
//  WXGuidMaskView.h
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"
#import "WXGuideCommon.h"

@interface WXGuidMaskView : WXUIView
@property (nonatomic,assign)E_GuideMaskPage eGuideMaskPage;

- (id)initWithFrame:(CGRect)frame guidMaskViewArray:(NSArray*)imageArray;
@end
