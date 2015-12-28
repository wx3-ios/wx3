//
//  LMShopInfoTopImgCell.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoTopImgCell.h"
#import "WXRemotionImgBtn.h"
#import "LMShopInfoDef.h"
#import "LMShopInfoEntity.h"

@interface LMShopInfoTopImgCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_addressLabel;
    WXRemotionImgBtn *homeImgView;
}
@end

@implementation LMShopInfoTopImgCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, LMShopInfoTopImgHeight)];
//        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        CGFloat bgViewHeight = 65;
        WXUIImageView *bgImgView = [[WXUIImageView alloc] init];
        bgImgView.frame = CGRectMake(0, LMShopInfoTopImgHeight-bgViewHeight, IPHONE_SCREEN_WIDTH, bgViewHeight);
        [bgImgView setImage:[UIImage imageNamed:@"LMShopInfoSmallImg.png"]];
        [self.contentView addSubview:bgImgView];
        
        CGFloat xOffset = 8;
        CGFloat imgWidth = 47;
        CGFloat imgHeight = imgWidth;
        homeImgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (bgViewHeight-imgHeight)/2, imgWidth, imgHeight)];
        [homeImgView setUserInteractionEnabled:NO];
        [bgImgView addSubview:homeImgView];
        
        CGFloat rightViewWidth = 50;
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 10;
        CGFloat nameLabelWidth = IPHONE_SCREEN_WIDTH-xOffset-rightViewWidth-10;
        CGFloat nameLabelHeight =  16;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXFont(12.0)];
        [_nameLabel setTextColor:WXColorWithInteger(0xffffff)];
        [bgImgView addSubview:_nameLabel];
        
        yOffset += nameLabelHeight+5;
        _addressLabel = [[WXUILabel alloc] init];
        _addressLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, 2*nameLabelHeight);
        [_addressLabel setTextAlignment:NSTextAlignmentLeft];
        [_addressLabel setBackgroundColor:[UIColor clearColor]];
        [_addressLabel setTextColor:WXColorWithInteger(0xe0e2e1)];
        [_addressLabel setFont:WXFont(10.0)];
        [_addressLabel setNumberOfLines:2];
        [bgImgView addSubview:_addressLabel];
        
        CGFloat lineHeight = 50;
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-rightViewWidth, (bgViewHeight-lineHeight)/2, 0.5, lineHeight);
        [lineLabel setBackgroundColor:WXColorWithInteger(0xffffff)];
        [bgImgView addSubview:lineLabel];
        
        CGFloat callBtnWidth = 25;
        CGFloat callBtnHeight = 35;
        WXUIButton *callBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-rightViewWidth+(rightViewWidth-callBtnWidth)/2, (bgViewHeight-callBtnHeight)/2+LMShopInfoTopImgHeight-bgViewHeight, callBtnWidth, callBtnHeight);
        [callBtn setImage:[UIImage imageNamed:@"LMWhiteCallImg.png"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
    }
    return self;
}

-(void)load{
    LMShopInfoEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.topImg];
    [imgView load];
    
    [homeImgView setCpxViewInfo:entity.homeImg];
    [homeImgView load];
    
    [_nameLabel setText:entity.shopName];
    [_addressLabel setText:entity.address];
}

-(void)callBtnClicked{
    LMShopInfoEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(shopCallBtnClicked:)]){
        [_delegate shopCallBtnClicked:entity.shopPhone];
    }
}

@end
