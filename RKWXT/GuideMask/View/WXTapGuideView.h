//
//  WXTapGuideView.h
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"
#import "WXMaskView.h"

@interface WXTapGuideView : WXUIView
@property (nonatomic,assign)id<WXMaskViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;
@end