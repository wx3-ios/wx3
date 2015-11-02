//
//  ClassifyGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "ClassiftGoodsEntity.h"

@interface ClassifyGoodsListCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_marketPrice;
    WXUILabel *_shopPrice;
    WXUILabel *_lineLabel;
}

@end

@implementation ClassifyGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat imgWidth = 98;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (ClassifyGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+14;
        CGFloat yOffset = 16;
        CGFloat labelHeight = 35;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset-12, labelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setNumberOfLines:2];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += labelHeight+5;
        CGFloat shopPriceWidth = 130;
        CGFloat priceHeight = 25;
        _shopPrice = [[WXUILabel alloc] init];
        _shopPrice.frame = CGRectMake(xOffset, yOffset, shopPriceWidth, priceHeight);
        [_shopPrice setBackgroundColor:[UIColor clearColor]];
        [_shopPrice setTextAlignment:NSTextAlignmentLeft];
        [_shopPrice setTextColor:WXColorWithInteger(0xdd2726)];
        [_shopPrice setFont:WXFont(13.0)];
        [self.contentView addSubview:_shopPrice];
        
        yOffset += priceHeight;
        _marketPrice = [[WXUILabel alloc] init];
        _marketPrice.frame = CGRectMake(xOffset, yOffset, 0, priceHeight);
        [_marketPrice setBackgroundColor:[UIColor clearColor]];
        [_marketPrice setTextAlignment:NSTextAlignmentLeft];
        [_marketPrice setTextColor:[UIColor grayColor]];
        [_marketPrice setFont:WXFont(11.0)];
        [self.contentView addSubview:_marketPrice];
        
        _lineLabel = [[WXUILabel alloc] init];
        _lineLabel.frame = CGRectMake(xOffset, yOffset+_marketPrice.frame.size.height/2, 0, 0.4);
        [_lineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:_lineLabel];
    }
    return self;
}

-(void)load{
    ClassiftGoodsEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@",entity.goodsImg]];
    [_imgView load];
    [_nameLabel setText:entity.goodsName];
    
    NSString *shopPrice = [NSString stringWithFormat:@"￥%.2f",entity.shop_price];
    [_shopPrice setText:shopPrice];
    
    NSString *marketPrice = [NSString stringWithFormat:@"市场价:￥%.2f",entity.market_price];
    [_marketPrice setText:marketPrice];
    
    CGSize size = [self sizeOfString:marketPrice font:WXFont(11.0)];
    CGRect rect = _marketPrice.frame;
    rect.size.width = size.width;
    [_marketPrice setFrame:rect];
    
    CGRect rect1 = _lineLabel.frame;
    rect1.size.width = rect.size.width;
    [_lineLabel setFrame:rect1];
}

- (CGSize)sizeOfString:(NSString*)txt font:(UIFont*)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
}

@end
