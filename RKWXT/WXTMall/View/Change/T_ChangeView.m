//
//  T_ChangeView.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_ChangeView.h"
#import "NewHomePageCommonDef.h"
#import "T_ChangeCell.h"
#import "WXRemotionImgBtn.h"
//#import "T_HomePageSurpEntity.h"

@interface T_ChangeView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_moneylabel;
    WXUILabel *_descLabel;
}
@end

@implementation T_ChangeView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*xGap)/2;
        CGFloat bgHeight = T_HomePageChangeInfoHeight-yGap;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(changeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat xOffset = 7;
        CGFloat yOffset = xOffset;
        CGFloat imgHeight = bgWidth;
        _imgView = [[WXRemotionImgBtn alloc] init];
        _imgView.frame = CGRectMake(xOffset, yOffset, bgWidth-2*xOffset, imgHeight-2*yOffset);
        [_imgView setUserInteractionEnabled:NO];
        [self addSubview:_imgView];
        
        yOffset = imgHeight;
        CGFloat moneyWidth = 80;
        CGFloat moneyHeight = 12;
        _moneylabel = [[WXUILabel alloc] init];
        _moneylabel.frame = CGRectMake(8, yOffset, moneyWidth, moneyHeight);
        [_moneylabel setBackgroundColor:[UIColor clearColor]];
        [_moneylabel setTextAlignment:NSTextAlignmentLeft];
        [_moneylabel setTextColor:WXColorWithInteger(0xc00000)];
        [_moneylabel setFont:[UIFont systemFontOfSize:12.0]];
        [bgBtn addSubview:_moneylabel];
        
        yOffset += moneyHeight;
        CGFloat descHeight = bgHeight-yOffset;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(8, yOffset, bgWidth-2*xGap, descHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextColor:WXColorWithInteger(0x323232)];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setNumberOfLines:0];
        [_descLabel setFont:[UIFont systemFontOfSize:8.0]];
        [bgBtn addSubview:_descLabel];
    }
    return self;
}

-(void)changeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[T_ChangeCell class]]);
    if(superView && [superView isKindOfClass:[T_ChangeCell class]]){
        T_ChangeCell *cell = (T_ChangeCell*)superView;
        id<ChangeCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(changeCellClicked:)]){
            [delegate changeCellClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
//    T_HomePageSurpEntity *entity = self.cpxViewInfo;
//    [_imgView setCpxViewInfo:entity.home_img];
//    [_imgView load];
//    NSString *shopPrice = [NSString stringWithFormat:@"￥%f",entity.shop_price];
//    [_moneylabel setText:shopPrice];
//    [_descLabel setText:entity.goods_intro];
    [_imgView setCpxViewInfo:@"http://gz.67call.com/wx/Public/Uploads/20140929/20140929111809_9365271.jpeg"];
    [_imgView load];
    
    NSString *shopPrice = [NSString stringWithFormat:@"￥100.00"];
    [_moneylabel setText:shopPrice];
    [_descLabel setText:@"联想一体机电脑"];
}

@end
