//
//  LuckyGoodsShowCell.m
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsShowCell.h"
#import "WXRemotionImgBtn.h"
#import "LuckyGoodsEntity.h"

@interface LuckyGoodsShowCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_name;
    WXUILabel *_price;
}

@end

@implementation LuckyGoodsShowCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 70;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LuckyGoodsShowCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 13;
        CGFloat nameWidth = IPHONE_SCREEN_WIDTH-xOffset-10;
        CGFloat nameHeight = 38;
        _name = [[WXUILabel alloc] init];
        _name.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_name setBackgroundColor:[UIColor clearColor]];
        [_name setTextAlignment:NSTextAlignmentLeft];
        [_name setTextColor:WXColorWithInteger(0x000000)];
        [_name setNumberOfLines:0];
        [_name setFont:WXFont(14.0)];
        [self.contentView addSubview:_name];
        
        yOffset += nameHeight+5;
        CGFloat priceWidth = 100;
        CGFloat priceHeight = 20;
        _price = [[WXUILabel alloc] init];
        _price.frame = CGRectMake(xOffset, yOffset, priceWidth, priceHeight);
        [_price setBackgroundColor:[UIColor clearColor]];
        [_price setTextAlignment:NSTextAlignmentLeft];
        [_price setTextColor:WXColorWithInteger(0xdd2726)];
        [_price setFont:WXFont(16.0)];
        [self.contentView addSubview:_price];
    }
    return self;
}

-(void)load{
    LuckyGoodsEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.imgUrl];
    [_imgView load];
    [_name setText:entity.name];
    [_price setText:[NSString stringWithFormat:@"%.2f",entity.market_price]];
}

@end
