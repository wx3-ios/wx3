//
//  LMShopInfoTrendsCell.m
//  RKWXT
//
//  Created by SHB on 15/12/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoTrendsCell.h"
#import "WXRemotionImgBtn.h"
#import "LMShopInfoAllGoodsEntity.h"

@interface LMShopInfoTrendsCell(){
    WXUILabel *titleLabel;
    WXUILabel *timeLabel;
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *priceLabel;
}
@end

@implementation LMShopInfoTrendsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat smImgWidth = 30;
        CGFloat smImgHeight = 14;
        WXUIImageView *smImgView = [[WXUIImageView alloc] init];
        smImgView.frame = CGRectMake(xOffset, yOffset, smImgWidth, smImgHeight);
        [smImgView setImage:[UIImage imageNamed:@"LMShopInfoNewGoodsBackImg.png"]];
        [self.contentView addSubview:smImgView];
        
        WXUILabel *staticLabel = [[WXUILabel alloc] init];
        staticLabel.frame = CGRectMake(0, 0, smImgWidth, smImgHeight);
        [staticLabel setText:@"动态"];
        [staticLabel setBackgroundColor:[UIColor clearColor]];
        [staticLabel setTextAlignment:NSTextAlignmentCenter];
        [staticLabel setTextColor:WXColorWithInteger(0xffffff)];
        [staticLabel setFont:WXFont(10.0)];
        [smImgView addSubview:staticLabel];
        
        xOffset += smImgWidth+11;
        CGFloat titleLabelWidth = IPHONE_SCREEN_WIDTH/2;
        titleLabel = [[WXUILabel alloc] init];
        titleLabel.frame = CGRectMake(xOffset, yOffset, titleLabelWidth, smImgHeight);
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setText:@"小店新品，欢迎选购"];
        [titleLabel setTextColor:WXColorWithInteger(0x000000)];
        [titleLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:titleLabel];
        
        CGFloat timeLabelWidth = 95;
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-timeLabelWidth, yOffset, timeLabelWidth, smImgHeight);
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setTextColor:WXColorWithInteger(0xc6c6c6)];
        [timeLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:timeLabel];
        
        yOffset += smImgHeight;
        CGFloat imgViewWidth = 95;
        CGFloat imgViewHeight = imgViewWidth;
        yOffset += (LMShopInfoTrendsCellHeight-imgViewHeight-yOffset)/2;
        xOffset = 10;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgViewWidth, imgViewHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgViewWidth+10;
        yOffset = imgView.frame.origin.y+imgViewHeight/4;
        CGFloat nameWidth = 180;
        CGFloat nameHeight = 28;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(12.0)];
        [nameLabel setNumberOfLines:2];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameHeight+15;
        CGFloat priceLabelWidth = 100;
        CGFloat priceLabelHeight = 17;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset, yOffset, priceLabelWidth, priceLabelHeight);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:priceLabel];
    }
    return self;
}

-(void)load{
    LMShopInfoAllGoodsEntity *entity = self.cellInfo;
    [timeLabel setText:[UtilTool getDateTimeFor:entity.addTime type:2]];
    [imgView setCpxViewInfo:entity.imgUrl];
    [imgView load];
    [nameLabel setText:entity.goodsName];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
}

@end
