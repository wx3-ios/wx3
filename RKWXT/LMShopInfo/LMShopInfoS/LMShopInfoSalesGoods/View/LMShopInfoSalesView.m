//
//  LMShopInfoSalesView.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoSalesView.h"
#import "WXRemotionImgBtn.h"
#import "LMShopInfoSalesCell.h"

@interface LMShopInfoSalesView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_pricelabel;
}
@end

@implementation LMShopInfoSalesView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-3*10)/2;
        CGFloat bgHeight = LMShopInfoSalesViewHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(shopInfoSalesClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat yOffset = 10;
        CGFloat imgWidth = bgWidth;
        CGFloat imgHeight = 145;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+10;
        CGFloat nameLabelWidth = imgWidth;
        CGFloat nameLabelHeight = 32;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, yOffset, nameLabelWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setNumberOfLines:0];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += nameLabelHeight+10;
        _pricelabel = [[WXUILabel alloc] init];
        _pricelabel.frame = CGRectMake(0, yOffset, 120, 16);
        [_pricelabel setBackgroundColor:[UIColor clearColor]];
        [_pricelabel setTextAlignment:NSTextAlignmentLeft];
        [_pricelabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_pricelabel setFont:WXFont(15.0)];
        [bgBtn addSubview:_pricelabel];
    }
    return self;
}

-(void)shopInfoSalesClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMShopInfoSalesCell class]]);
    if(superView && [superView isKindOfClass:[LMShopInfoSalesCell class]]){
        LMShopInfoSalesCell *cell = (LMShopInfoSalesCell*)superView;
        id<LMShopInfoSalesCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(lmShopInfoSaleGoodsBtnClicked:)]){
            [delegate lmShopInfoSaleGoodsBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    [_imgView setCpxViewInfo:@"http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141759_471740.jpeg"];
    [_imgView load];
    [_nameLabel setText:self.cpxViewInfo];
}

@end
