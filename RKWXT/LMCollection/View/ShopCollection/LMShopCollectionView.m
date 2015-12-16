//
//  LMShopCollectionView.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopCollectionView.h"
#import "WXRemotionImgBtn.h"
#import "LMShopCollectionCell.h"

@interface LMShopCollectionView(){
    WXRemotionImgBtn *_imgView;
}
@end

@implementation LMShopCollectionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*10)/3;
        CGFloat bgHeight = LMGoodsCollectionCellheight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(forMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 10;
        CGFloat imgWidth = 92;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMShopCollectionCell class]]);
    if(superView && [superView isKindOfClass:[LMShopCollectionCell class]]){
        LMShopCollectionCell *cell = (LMShopCollectionCell*)superView;
        id<LMShopCollectionCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(lmShopCollectionCellBtnClicked:)]){
            [delegate lmShopCollectionCellBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    [_imgView setCpxViewInfo:@"http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141759_471740.jpeg"];
    [_imgView load];
}

@end
