//
//  HomeLimitBuyView.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "HomeLimitBuyView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "HomeLimitBuyCell.h"
#import "TimeShopData.h"

@interface HomeLimitBuyView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_newPriceLabel;
    WXUILabel *_oldPriceLabel;
    WXUILabel *_nameLabel;
}
@end

@implementation HomeLimitBuyView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*xGap)/3;
        CGFloat bgHeight = T_HomePageLimitBuyHeight;
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(forMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        

        CGFloat yOffset = 8;
        CGFloat imgWidth = 80;
        CGFloat imgHeight = imgWidth;
        CGFloat xOffset = (bgWidth-imgWidth)/2;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+7;
        CGFloat nameLabelHeight = 10;
        _newPriceLabel = [[WXUILabel alloc] init];
        _newPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_newPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_newPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [_newPriceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_newPriceLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_newPriceLabel];
        
        yOffset += nameLabelHeight+5;
        _oldPriceLabel = [[WXUILabel alloc] init];
        _oldPriceLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_oldPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_oldPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [_oldPriceLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [_oldPriceLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_oldPriceLabel];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset+5, yOffset+nameLabelHeight/2, imgWidth-2*10, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [bgBtn addSubview:lineLabel];
        
        yOffset += nameLabelHeight+5;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, imgWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:10.0]];
        [bgBtn addSubview:_nameLabel];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[HomeLimitBuyCell class]]);
    if(superView && [superView isKindOfClass:[HomeLimitBuyCell class]]){
        HomeLimitBuyCell *cell = (HomeLimitBuyCell*)superView;
        id<HomeLimitBuyCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(HomeLimitBuyCellBtnClicked:)]){
            [delegate HomeLimitBuyCellBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    TimeShopData *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.goods_home_img];
    [_imgView load];
    [_newPriceLabel setText:[NSString stringWithFormat:@"抢购价:￥%.2f",[entity.scare_buying_price floatValue]]];
    [_oldPriceLabel setText:[NSString stringWithFormat:@"原价:￥%.2f",[entity.goods_price floatValue]]];
    [_nameLabel setText:entity.goods_name];
}

@end