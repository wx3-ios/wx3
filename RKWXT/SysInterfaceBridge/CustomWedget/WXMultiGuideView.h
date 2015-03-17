//
//  WXMultiGuideView.h
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"

@protocol WXMultiGuideViewDelegate;
@interface WXMultiGuideView : WXUIView
@property (nonatomic,assign)id<WXMultiGuideViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame guideArray:(NSArray*)guideArray;
@end

@protocol WXMultiGuideViewDelegate <NSObject>
- (void)guideDidScrollToEnd;
@end
