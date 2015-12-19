//
//  LMShopInfoALlGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoALlGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "LMShopInfoAllGoodsEntity.h"

@interface LMShopInfoALlGoodsListCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *goodsName;
    WXUILabel *priceLabel;
}
@end

@implementation LMShopInfoALlGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat imgWidth = 98;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMShopInfoALlGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+15;
        CGFloat yOffset = 18;
        CGFloat nameLabelHeight = 30;
        goodsName = [[WXUILabel alloc] init];
        goodsName.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset-10, nameLabelHeight);
        [goodsName setBackgroundColor:[UIColor clearColor]];
        [goodsName setTextAlignment:NSTextAlignmentLeft];
        [goodsName setTextColor:WXColorWithInteger(0x000000)];
        [goodsName setFont:WXFont(12.0)];
        [goodsName setNumberOfLines:0];
        [self.contentView addSubview:goodsName];
        
        yOffset += nameLabelHeight+30;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset, yOffset, 120, 18);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [priceLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:priceLabel];
    }
    return self;
}

-(void)load{
    LMShopInfoAllGoodsEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.imgUrl];
    [imgView load];
    
    [goodsName setText:entity.goodsName];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
}

@end
