//
//  WXShopUnionHotShopView.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionHotShopView.h"
#import "WXShopUnionDef.h"
#import "WXRemotionImgBtn.h"
#import "WXShopUnionHotShopCell.h"
#import "ShopUnionHotShopEntity.h"

@interface WXShopUnionHotShopView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
}
@end

@implementation WXShopUnionHotShopView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*10)/3;
        CGFloat bgHeight = ShopUnionHotShopListHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(forMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 10;
        CGFloat imgWidth = 85;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+10;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, yOffset, imgWidth, 15);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x595757)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [bgBtn addSubview:_nameLabel];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[WXShopUnionHotShopCell class]]);
    if(superView && [superView isKindOfClass:[WXShopUnionHotShopCell class]]){
        WXShopUnionHotShopCell *cell = (WXShopUnionHotShopCell*)superView;
        id<WXShopUnionHotShopCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(shopUnionHotShopCellBtnClicked:)]){
            [delegate shopUnionHotShopCellBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    ShopUnionHotShopEntity *entity = self.cpxViewInfo;
    [_imgView setCpxViewInfo:entity.sellerLogo];
    [_imgView load];
    [_nameLabel setText:entity.sellerName];
}

@end
