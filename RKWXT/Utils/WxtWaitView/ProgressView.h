//
//  ProgressView.h
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic,retain)UIColor *onColor;
@property (nonatomic,retain)UIColor *unOnColor;
@property (nonatomic,assign)CGFloat arcLineWidth;

- (id)initWithCenter:(CGPoint)center radius:(CGFloat)radius;
- (void)setNodeNumber:(NSInteger)nodeNumber spaceNodePersent:(CGFloat)spaceNodePersent;

- (void)startAnimating;
- (void)stopAnimating;

@end
