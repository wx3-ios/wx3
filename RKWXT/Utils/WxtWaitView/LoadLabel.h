//
//  LoadLabel.h
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadLabel : UILabel
@property (nonatomic,assign)NSInteger dotCount;

- (void)setLoadText:(NSString*)loadText;

- (void)startAnimate;
- (void)stopAnimate;

@end
