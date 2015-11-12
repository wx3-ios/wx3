//
//  WinningView.m
//  RKWXT
//
//  Created by SHB on 15/11/12.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WinningView.h"
#import "WXRemotionImgBtn.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

#define WinningViewWidth (200)
#define WinningViewHeight (300)

@interface WinningView(){
    WXUIImageView *_shellImgView;
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
}
@end

@implementation WinningView

-(void)initial{
    CGFloat xOffset = 10;
    _shellImgView = [[WXUIImageView alloc] init];
    _shellImgView.frame = CGRectMake(xOffset, 0, WinningViewWidth-2*xOffset, 230);
    [_shellImgView setImage:[UIImage imageNamed:@"SharkShellImg.png"]];
    [self addSubview:_shellImgView];
    
    CGFloat closeBtnWidth = 30;
    CGFloat closeBtnHeight = closeBtnWidth;
    WXUIButton *closeBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_shellImgView.frame.origin.x+_shellImgView.frame.size.width-20, 15, closeBtnWidth, closeBtnHeight);
    [closeBtn setImage:[UIImage imageNamed:@"SharkCloseBtnImg.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeWinningView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    
    xOffset = 40;
    CGFloat yOffset = 45;
    CGFloat imgWidth = _shellImgView.frame.size.width-2*xOffset;
    _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgWidth)];
    [_imgView setCpxViewInfo:_imgUrl];
    [_imgView load];
    [_imgView setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_shellImgView addSubview:_imgView];
    
    yOffset += imgWidth+30;
    _nameLabel = [[WXUILabel alloc] init];
    _nameLabel.frame = CGRectMake(5, yOffset, _shellImgView.frame.size.width-2*5, 25);
    [_nameLabel setText:_name];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setFont:WXFont(13.0)];
    [_shellImgView addSubview:_nameLabel];
    
    yOffset = _shellImgView.frame.size.height+15;
    CGFloat btnWidth = 110;
    CGFloat btnHeight = 40;
    WXUIButton *goodsBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    goodsBtn.frame = CGRectMake((WinningViewWidth-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [goodsBtn setImage:[UIImage imageNamed:@"SharkGoodsBtnImg.png"] forState:UIControlStateNormal];
    [goodsBtn addTarget:self action:@selector(gotoWinningGoodsInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goodsBtn];
}

+(instancetype)defaultPopupView{
    return [[WinningView alloc] initWithFrame:CGRectMake(0, 0, WinningViewWidth, WinningViewHeight)];
}

-(void)closeWinningView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeWinningViewNoti" object:nil];
}

-(void)gotoWinningGoodsInfoVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoWinningGoodsInfoVC" object:nil];
}

@end
