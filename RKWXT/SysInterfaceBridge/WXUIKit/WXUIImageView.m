//
//  WXUIImageView.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIImageView.h"

@implementation WXUIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WXUIImageView*)imageViewWithImage:(UIImage*)image{
    WXUIImageView *imageView = [[WXUIImageView alloc] initWithImage:image];
    return imageView ;
}
@end
