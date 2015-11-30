//
//  MakeOrderGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "MakeOrderDef.h"
#import "GoodsInfoEntity.h"

@interface MakeOrderGoodsListCell(){
    WXRemotionImgBtn *_imgView;
    UILabel *_nameLabel;
    UILabel *_stockName;
    UILabel *_numLabel;
    UILabel *_priceLabel;
}
@end

@implementation MakeOrderGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat imgWidth = 63;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (Order_Section_Height_GoodsList-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+13;
        CGFloat yOffset = (Order_Section_Height_GoodsList-imgHeight)/2+2;
        CGFloat nameWidth = 135;
        CGFloat nameHeight = 45;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setNumberOfLines:0];
        [_nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_nameLabel];
        
        CGFloat yGap = Order_Section_Height_GoodsList-(Order_Section_Height_GoodsList-imgHeight)/2-16;
        _stockName = [[UILabel alloc] init];
        _stockName.frame = CGRectMake(xOffset, yGap, 100, 18);
        [_stockName setBackgroundColor:[UIColor clearColor]];
        [_stockName setTextAlignment:NSTextAlignmentLeft];
        [_stockName setTextColor:WXColorWithInteger(0x000000)];
        [_stockName setNumberOfLines:0];
        [_stockName setFont:WXFont(13.0)];
        [self.contentView addSubview:_stockName];
        
        
        CGFloat priceWidth = 80;
        CGFloat priceHeight = 17;
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-priceWidth-10, yOffset, priceWidth, priceHeight);
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [_priceLabel setTextColor:WXColorWithInteger(0x000000)];
        [_priceLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_priceLabel];
        
        CGFloat numWidth = 35;
        CGFloat numHeight = 14;
        _numLabel = [[UILabel alloc] init];
        _numLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-12-numWidth, yOffset+priceHeight+10, numWidth, numHeight);
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setFont:WXFont(13.0)];
        [_numLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:_numLabel];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.smallImg];
    [_imgView load];
    [_nameLabel setText:entity.intro];
    [_numLabel setText:[NSString stringWithFormat:@"X%ld",(long)entity.buyNumber]];
    [_stockName setText:entity.stockName];
    [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.stockPrice]];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

@end
