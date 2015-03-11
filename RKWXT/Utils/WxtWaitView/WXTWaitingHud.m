//
//  WXTWaitingHud.m
//  GjtCall
//
//  Created by SHB on 15/2/7.
//  Copyright (c) 2015年 jjyo.kwan. All rights reserved.
//

#import "WXTWaitingHud.h"
#import "ProgressView.h"
#import "LoadLabel.h"
#import "UIColor+WXT.h"
#import "NSString+Size.h"

#define kTipFontSize (10.0)
@interface WXTWaitingHud()
{
    ProgressView *_progressView;
    LoadLabel *_tipLabel;
    UIView *_shell;
}
@end

@implementation WXTWaitingHud

- (id)initWithParentView:(UIView*)parentView{
    if(self = [super init]){
        CGSize size = parentView.bounds.size;
        [self setFrame:parentView.bounds];
        
        CGFloat progressViewRadius = 60.0;
        CGFloat length = progressViewRadius;
        CGFloat tipHeight = 15.0;
        CGSize shellSize = CGSizeMake(length,length);
        CGRect shellRect = CGRectMake((size.width - length)*0.5, (size.height - shellSize.height)*0.5, shellSize.width, shellSize.height);
        _shell = [[UIView alloc] initWithFrame:shellRect];
        [_shell setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_shell];
        
        CGPoint center = CGPointMake(progressViewRadius/2.0 + (length-progressViewRadius)*0.5, progressViewRadius/2.0);
        _progressView = [[ProgressView alloc] initWithCenter:center radius:progressViewRadius*0.5];
        [_progressView setArcLineWidth:5.0];
        [_progressView setOnColor:WXColorWithInteger(0x3faf98)];
        [_progressView setUnOnColor:WXColorWithInteger(0xd1c7be)];
        [_progressView setNodeNumber:20 spaceNodePersent:0.2];
        [_progressView setAlpha:0.6];
        [_shell addSubview:_progressView];
        
        UIImage *wxtIcon = [UIImage imageNamed:@"wxtHidIcon.png"];
        CGSize wxIconSize = wxtIcon.size;
        UIImageView *wxImgView = [[UIImageView alloc] initWithImage:wxtIcon];
        [wxImgView setFrame:CGRectMake((progressViewRadius-wxIconSize.width)*0.5, (progressViewRadius-wxIconSize.height)*0.5, wxIconSize.width, wxIconSize.height)];
        [_progressView addSubview:wxImgView];
        
        
        _tipLabel = [[LoadLabel alloc] initWithFrame:CGRectMake(10, shellRect.origin.y + shellRect.size.height + 2, 10, tipHeight)];
        [_tipLabel setFont:[UIFont systemFontOfSize:kTipFontSize]];
        [_tipLabel setDotCount:4];
        [self addSubview:_tipLabel];
    }
    return self;
}

- (void)setText:(NSString*)text{
    if (!text){
        text = @"努力加载中";
    }
    [_tipLabel setLoadText:text];
    UIFont *font = [UIFont systemFontOfSize:kTipFontSize];
    CGSize size = [text stringSize:font];
    CGFloat xOffset = (self.bounds.size.width - size.width)*0.5;
    CGRect rect = _tipLabel.frame;
    rect.origin.x = xOffset;
    CGFloat dotWidth = 15.0;
    rect.size.width = size.width + dotWidth;
    [_tipLabel setFrame:rect];
}

- (void)startAnimate{
    [_progressView startAnimating];
    [_tipLabel startAnimate];
}

- (void)stopAniamte{
    [_progressView stopAnimating];
    [_tipLabel stopAnimate];
}


@end
