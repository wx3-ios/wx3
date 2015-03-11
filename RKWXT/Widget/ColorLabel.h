//
//  ColorLabel.h
//  Okboo
//
//  Created by jjyo.kwan on 12-8-20.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RANGE_NONE  NSMakeRange(0, 0)

@interface ColorLabel : UILabel


@property (assign) BOOL colorMode;
//@property (assign) NSRange range;
@property (nonatomic, strong) UIColor *rangeColor;
@property (nonatomic, strong) UIColor *rangeHighlightedColor;
@property (nonatomic, strong) NSArray *ranges;

@end
