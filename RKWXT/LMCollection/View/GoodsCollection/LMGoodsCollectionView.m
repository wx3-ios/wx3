//
//  LMGoodsCollectionView.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsCollectionView.h"
#import "WXRemotionImgBtn.h"
#import "LMGoodsCollectionCell.h"
#import "LMGoodsCollectionEntity.h"

@interface LMGoodsCollectionView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *pricelabel;
}
@end

@implementation LMGoodsCollectionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*10)/2;
        CGFloat bgHeight = LMGoodsCollectionCellheight;
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
        CGFloat nameHeight = 32;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, yOffset, imgWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x595757)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setNumberOfLines:2];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += nameHeight+10;
        pricelabel = [[WXUILabel alloc] init];
        pricelabel.frame = CGRectMake(0, yOffset, imgWidth, 20);
        [pricelabel setBackgroundColor:[UIColor clearColor]];
        [pricelabel setTextAlignment:NSTextAlignmentLeft];
        [pricelabel setTextColor:WXColorWithInteger(0xdd2726)];
        [pricelabel setFont:WXFont(15.0)];
        [bgBtn addSubview:pricelabel];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMGoodsCollectionCell class]]);
    if(superView && [superView isKindOfClass:[LMGoodsCollectionCell class]]){
        LMGoodsCollectionCell *cell = (LMGoodsCollectionCell*)superView;
        id<LMGoodsCollectionCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(lmGoodsCollectionCellBtnClicked:)]){
            [delegate lmGoodsCollectionCellBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    LMGoodsCollectionEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.homeImg];
    [_imgView load];
    [_nameLabel setText:entity.goodsName];
    [pricelabel setText:[NSString stringWithFormat:@"￥%.2f",entity.marketPrice]];
}

@end
