//
//  WXUIView.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXUIView : UIView
@property (nonatomic,readonly)UIView *backGroundView;
@property (nonatomic,retain)id idTag;

- (void)setBackgroundImage:(UIImage*)image;
@end
