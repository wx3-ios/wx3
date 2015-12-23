//
//  LMMakeOrderGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderGoodsCell.h"
#import "WXRemotionImgBtn.h"
#import "LMMakeOrderDef.h"
#import "LMGoodsInfoEntity.h"

@interface LMMakeOrderGoodsCell(){
    WXRemotionImgBtn *_imgView;
    UILabel *_nameLabel;
    UILabel *_stockName;
    UILabel *_numLabel;
    UILabel *_priceLabel;
}
@end

@implementation LMMakeOrderGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat imgWidth = 63;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMMakeOrderGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+13;
        CGFloat yOffset = 17;
        CGFloat nameWidth = IPHONE_SCREEN_WIDTH-xOffset-10;
        CGFloat nameHeight = 18;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHeight+6;
        _stockName = [[UILabel alloc] init];
        _stockName.frame = CGRectMake(xOffset, yOffset, 150, nameHeight);
        [_stockName setBackgroundColor:[UIColor clearColor]];
        [_stockName setTextAlignment:NSTextAlignmentLeft];
        [_stockName setTextColor:WXColorWithInteger(0xc6c6c6)];
        [_stockName setFont:WXFont(10.0)];
        [self.contentView addSubview:_stockName];
        
        yOffset += nameHeight+12;
        CGFloat priceWidth = 100;
        CGFloat priceHeight = 17;
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.frame = CGRectMake(xOffset, yOffset, priceWidth, priceHeight);
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextAlignment:NSTextAlignmentLeft];
        [_priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_priceLabel];
        
        CGFloat numWidth = 35;
        CGFloat numHeight = 14;
        _numLabel = [[UILabel alloc] init];
        _numLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-12-numWidth, yOffset, numWidth, numHeight);
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setFont:WXFont(14.0)];
        [_numLabel setTextColor:WXColorWithInteger(0x42433e)];
        [self.contentView addSubview:_numLabel];
    }
    return self;
}

-(void)load{
    LMGoodsInfoEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goodsImg]];
    [_imgView load];
    [_nameLabel setText:entity.goodsName];
    [_numLabel setText:[NSString stringWithFormat:@"X%ld",(long)entity.stockNum]];
    [_stockName setText:entity.stockName];
    [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.stockPrice/entity.stockNum]];
}

@end
