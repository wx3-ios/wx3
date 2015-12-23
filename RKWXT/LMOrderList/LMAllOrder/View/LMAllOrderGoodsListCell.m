//
//  LMAllOrderGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMAllOrderGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "LMOrderListEntity.h"

@interface LMAllOrderGoodsListCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *stockLabel;
    WXUILabel *priceLabel;
    WXUILabel *numLabel;
}
@end

@implementation LMAllOrderGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 62;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMAllOrderGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+5;
        CGFloat yOffset = 10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelHeight = 35;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setNumberOfLines:2];
        [self.contentView addSubview:nameLabel];
        
        CGFloat labelHeight = 20;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset+nameLabelWidth, yOffset, IPHONE_SCREEN_WIDTH-xOffset-nameLabelWidth-10, labelHeight);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentRight];
        [priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [priceLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:priceLabel];
        
        numLabel = [[WXUILabel alloc] init];
        numLabel.frame = CGRectMake(priceLabel.frame.origin.x, yOffset+labelHeight, priceLabel.frame.size.width, labelHeight);
        [numLabel setTextAlignment:NSTextAlignmentRight];
        [numLabel setTextColor:WXColorWithInteger(0x434343)];
        [numLabel setFont:WXFont(13.0)];
        [numLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:numLabel];
        
        yOffset += nameLabelHeight+4;
        stockLabel = [[WXUILabel alloc] init];
        stockLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, labelHeight);
        [stockLabel setBackgroundColor:[UIColor clearColor]];
        [stockLabel setTextAlignment:NSTextAlignmentLeft];
        [stockLabel setTextColor:WXColorWithInteger(0x969696)];
        [stockLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:stockLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.goodsImg];
    [imgView load];
    
    [nameLabel setText:entity.goodsName];
    [stockLabel setText:entity.stockName];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.stockPrice]];
    [numLabel setText:[NSString stringWithFormat:@"X%ld",(long)entity.buyNumber]];
}

@end
