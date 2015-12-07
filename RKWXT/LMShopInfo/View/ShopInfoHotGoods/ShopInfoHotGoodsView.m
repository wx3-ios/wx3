//
//  ShopInfoHotGoodsView.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopInfoHotGoodsView.h"
#import "LMShopInfoDef.h"
#import "WXRemotionImgBtn.h"
#import "ShopInfoHotGoodsCell.h"

@interface ShopInfoHotGoodsView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_priceLabel;
}
@end

@implementation ShopInfoHotGoodsView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*10)/2;
        CGFloat bgHeight = LMShopInfoHotGoodsHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(hotGoodsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 10;
        CGFloat imgWidth = 145;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+10;
        CGFloat nameLabelHeight = 32;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, yOffset, imgWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setNumberOfLines:2];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += nameLabelHeight+10;
        _priceLabel = [[WXUILabel alloc] init];
        _priceLabel.frame = CGRectMake(0, yOffset, imgWidth, 18);
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextAlignment:NSTextAlignmentLeft];
        [_priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_priceLabel setFont:WXFont(15.0)];
        [bgBtn addSubview:_priceLabel];
    }
    return self;
}

-(void)hotGoodsBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[ShopInfoHotGoodsCell class]]);
    if(superView && [superView isKindOfClass:[ShopInfoHotGoodsCell class]]){
        ShopInfoHotGoodsCell *cell = (ShopInfoHotGoodsCell*)superView;
        id<ShopInfoHotGoodsCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(shopInfoHotGoodsCellBtnClicked:)]){
            [delegate shopInfoHotGoodsCellBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
}

@end
