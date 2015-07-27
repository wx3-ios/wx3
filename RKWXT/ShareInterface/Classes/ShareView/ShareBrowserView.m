//
//  ShareBrowserView.m
//  RKWXT
//
//  Created by SHB on 15/7/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ShareBrowserView.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

#define shareViewWidth (240)
#define shareViewHeight (360)

static NSString *shareImgArr[]={
    @"ShareQqImg.png",
    @"ShareQzoneImg.png",
    @"ShareWxFriendImg.png",
    @"ShareWxCircleImg.png",
};

static NSString *shareNameArr[]={
    @"qq好友",
    @"qq空间",
    @"微信好友",
    @"朋友圈",
};

@interface ShareBrowserView(){
    UIView *_maskShell;
    UIView *_shareView;
    UIImageView *_imageView;
    
    CGRect _imageViewDestRect;
    CGRect _imageViewSourceRect;
    
    CGFloat _duration;
    CGFloat _maskAlpha;
}
@property (nonatomic,strong) UIView *thumbView;
@end

@implementation ShareBrowserView

-(id)init{
    self = [super init];
    if(self){
        [self initial];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initial];
    }
    return self;
}

-(void)initial{
    _maskShell = [[UIView alloc] init];
    [_maskShell setFrame:self.bounds];
    [_maskShell setBackgroundColor:[UIColor blackColor]];
    [_maskShell setAlpha:kMaskShellDefaultAlpha];
    [self addSubview:_maskShell];
    
    _shareView = [[UIView alloc] init];
    [_shareView setFrame:CGRectMake((IPHONE_SCREEN_WIDTH-shareViewWidth)/2, (IPHONE_SCREEN_HEIGHT-shareViewHeight)/2, shareViewWidth, shareViewHeight)];
    [_shareView setBackgroundColor:[UIColor whiteColor]];
    [_shareView setBorderRadian:10.0 width:2.0 color:[UIColor clearColor]];
    [self addSubview:_shareView];
    
    
    CGFloat textlabelWidth = 140;
    CGFloat textLabelHeight = 22;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((shareViewWidth-textlabelWidth)/2, 15, textlabelWidth, textLabelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"推荐应用给好友"];
    [textLabel setFont:WXFont(18.0)];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0xd9d9d9)];
    [_shareView addSubview:textLabel];
    
    CGFloat yOffset = textLabelHeight+15+5;
    UILabel *linelabel = [[UILabel alloc] init];
    linelabel.frame = CGRectMake(0, yOffset, shareViewWidth, 0.5);
    [linelabel setBackgroundColor:WXColorWithInteger(0xdedede)];
    [_shareView addSubview:linelabel];
    
    _imageView = [[UIImageView alloc] init];
    [_shareView addSubview:_imageView];
    
    yOffset += 15+200;
    UILabel *textLabel1 = [[UILabel alloc] init];
    textLabel1.frame = CGRectMake((shareViewWidth-textlabelWidth)/2, yOffset, textlabelWidth, textLabelHeight);
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    [textLabel1 setText:kMerchantName];
    [textLabel1 setFont:WXFont(18.0)];
    [textLabel1 setTextAlignment:NSTextAlignmentCenter];
    [textLabel1 setTextColor:WXColorWithInteger(0x000000)];
    [_shareView addSubview:textLabel1];
    
    yOffset += textLabelHeight+12;
    [self createMoreShareBtn:yOffset];
    
    _duration = kAnimateDefaultDuration;
    _maskAlpha = kMaskShellDefaultAlpha;
    
    [self setUserInteractionEnabled:YES];
}

-(void)createMoreShareBtn:(CGFloat)yGap{
    CGFloat imgWidth = 40;
    CGFloat imgHeight = imgWidth;
    CGFloat xOffset = 18;
    CGFloat xGap = (shareViewWidth-2*xOffset-Share_Type_Invalid*imgWidth)/3;
    for(int i = 0; i < Share_Type_Invalid; i++){
        WXUIButton *sharebtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame = CGRectMake(xGap+i*(imgWidth+xGap), yGap, imgWidth, imgHeight);
        sharebtn.tag = i;
        [sharebtn setImage:[UIImage imageNamed:shareImgArr[i]] forState:UIControlStateNormal];
        [sharebtn addTarget:self action:@selector(sharebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:sharebtn];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xGap+i*(imgWidth+xGap), yGap+imgHeight, imgWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:shareNameArr[i]];
        [nameLabel setFont:WXFont(10.0)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_shareView addSubview:nameLabel];
    }
}

-(void)sharebtnClicked:(WXUIButton*)btn{
    if(btn.tag > Share_Type_Invalid){
        return;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(sharebtnClicked:)]){
        [_delegate sharebtnClicked:btn.tag];
    }
    [self unshow];
}

-(void)showShareThumbView:(UIView *)thumbView toDestview:(UIView *)destView withImage:(UIImage *)image{
    self.hidden = NO;
    self.alpha = 0.0;
    
    [self setThumbView:thumbView];
    [_maskShell setFrame:destView.bounds];
    [self setFrame:destView.bounds];
//    UIView *superView = thumbView.superview;
//    NSAssert(superView, @"thumb view has not add to super view");
    _imageViewSourceRect = [destView convertRect:CGRectMake(_shareView.frame.size.width/2, _shareView.frame.size.height/2, 0, 0) fromView:thumbView.superview];
    [_imageView setImage:image];
    [_imageView setFrame:_imageViewSourceRect];
    
    CGSize destViewSize = destView.bounds.size;
    CGSize destThumbSize = image.size;
    _imageViewDestRect = CGRectMake((destViewSize.width-destThumbSize.width)*0.5, (destViewSize.height-destThumbSize.height)*0.5, destThumbSize.width, destThumbSize.height);
    
    [destView addSubview:self];
    
    __block ShareBrowserView *blockSelf = self;
    [UIView animateWithDuration:_duration animations:^{
        [blockSelf show];
    }];
}

- (void)show{
//    CGSize size = CGSizeMake(_imageViewDestRect.size.width, _imageViewDestRect.size.height);
    CGFloat imgWidth = 200;
    CGFloat imgHeight = imgWidth;
    [_imageView setFrame:CGRectMake((shareViewWidth-imgWidth)/2, 50, imgWidth, imgHeight)];
    [self.thumbView setAlpha:0.0];
    [self setAlpha:1.0];
}

- (void)unshow{
    [_imageView setFrame:_imageViewSourceRect];
    [self.thumbView setAlpha:1.0];
    [self setAlpha:0.0];
}

- (void)unshowAnimated:(BOOL)animated{
    if (animated){
        __block ShareBrowserView *blockSelf = self;
        [UIView animateWithDuration:_duration animations:^{
            [blockSelf unshow];
        } completion:^(BOOL finished) {
            [blockSelf removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)isClicked{
    [self unshowAnimated:YES];
}

@end
