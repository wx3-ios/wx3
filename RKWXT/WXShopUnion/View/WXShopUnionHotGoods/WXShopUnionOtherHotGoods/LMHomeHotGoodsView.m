//
//  LMHomeHotGoodsView.m
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMHomeHotGoodsView.h"
#import "WXShopUnionDef.h"
#import "WXRemotionImgBtn.h"
#import "LMHomeHotGoodsCell.h"
#import "ShopUnionHotGoodsEntity.h"

@interface LMHomeHotGoodsView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_priceLabel;
}
@end

@implementation LMHomeHotGoodsView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*10)/2;
        CGFloat bgHeight = ShopUnionHotGoodsListHeight;
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
        CGFloat nameHeight = 30;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, yOffset, imgWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setNumberOfLines:2];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += nameHeight+7;
        _priceLabel = [[WXUILabel alloc] init];
        _priceLabel.frame = CGRectMake(0, yOffset, imgWidth, nameHeight/2);
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextAlignment:NSTextAlignmentLeft];
        [_priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_priceLabel setFont:WXFont(15.0)];
        [bgBtn addSubview:_priceLabel];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMHomeHotGoodsCell class]]);
    if(superView && [superView isKindOfClass:[LMHomeHotGoodsCell class]]){
        LMHomeHotGoodsCell *cell = (LMHomeHotGoodsCell*)superView;
        id<LMHomeHotGoodsCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(lmHomeHotShopCellBtnClicked:)]){
            [delegate lmHomeHotShopCellBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    ShopUnionHotGoodsEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.goodsImg];
    [_imgView load];
    [_nameLabel setText:entity.goodsName];
    [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
}

@end
