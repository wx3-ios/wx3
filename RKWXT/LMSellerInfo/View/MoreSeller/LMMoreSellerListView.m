//
//  LMMoreSellerListView.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMoreSellerListView.h"
#import "WXRemotionImgBtn.h"
#import "LMMoreSellerListCell.h"
#import "LMSellerInfoEntity.h"

@interface LMMoreSellerListView(){
    WXRemotionImgBtn *_imgView;
}
@end

@implementation LMMoreSellerListView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat width = (IPHONE_SCREEN_WIDTH-4*8)/3;
        CGFloat height = LMMoreSellerListCellHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0.5, width, height);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(moreSellerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [_imgView setUserInteractionEnabled:NO];
        [self addSubview:_imgView];
    }
    return self;
}

-(void)moreSellerBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMMoreSellerListCell class]]);
    if(superView && [superView isKindOfClass:[LMMoreSellerListCell class]]){
        LMMoreSellerListCell *cell = (LMMoreSellerListCell*)superView;
        id<LMMoreSellerListCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(moreSellerListBtnClicked:)]){
            [delegate moreSellerListBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    LMSellerInfoEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.goodsImg];
    [_imgView load];
}

@end
