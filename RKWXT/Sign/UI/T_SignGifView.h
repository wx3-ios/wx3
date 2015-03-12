//
//  T_SignGifView.h
//  Woxin3.0
//
//  Created by SHB on 15/1/23.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnimateDuration (3.0f)
@protocol SignGifViewDelegate;
@interface T_SignGifView : UIView
@property (nonatomic,assign)id<SignGifViewDelegate>delegate;

@end

@protocol SignGifViewDelegate <NSObject>
- (void)animationDidFinised;
@end
