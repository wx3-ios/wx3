//
//  WXCpxBtnImgView.m
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXCpxBtnImgView.h"

@interface WXCpxBtnImgView()
{
    WXUIButton *_imgBtn;
}
@end

@implementation WXCpxBtnImgView

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        [_imgBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_imgBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight];
        [_imgBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imgBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_imgBtn setFrame:self.bounds];
}

- (void)setButtonEnable:(BOOL)enable{
    self.userInteractionEnabled = enable;
}

- (void)setImage:(UIImage*)image{
    [_imgBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setIcon:(UIImage*)icon{
    [_imgBtn setImage:icon forState:UIControlStateNormal];
}

- (void)buttonClicked{
    
}

@end
