//
//  LMSearchGoodsResultView.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchGoodsResultView.h"
#import "WXRemotionImgBtn.h"
#import "LMSearchGoodsResultCell.h"

@interface LMSearchGoodsResultView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *priceLabel;
}
@end

@implementation LMSearchGoodsResultView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*10)/2;
        CGFloat bgHeight = 215;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(forMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 10;
        CGFloat imgWidth = 145;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+10;
        CGFloat nameLabelHieght = 32;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, yOffset, imgWidth, nameLabelHieght);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setNumberOfLines:2];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += nameLabelHieght+10;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(0, yOffset, imgWidth, 16);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [priceLabel setFont:WXFont(15.0)];
        [bgBtn addSubview:priceLabel];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMSearchGoodsResultCell class]]);
    if(superView && [superView isKindOfClass:[LMSearchGoodsResultCell class]]){
        LMSearchGoodsResultCell *cell = (LMSearchGoodsResultCell*)superView;
        id<LMSearchGoodsResultCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(lmSearchGoodsBtnClicked:)]){
            [delegate lmSearchGoodsBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    [_imgView setCpxViewInfo:@"http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141759_471740.jpeg"];
    [_imgView load];
    [_nameLabel setText:self.cpxViewInfo];
    [priceLabel setText:@"100.00"];
}

@end
