//
//  OrderGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderGoodsCell.h"
#import "WXRemotionImgBtn.h"

@interface OrderGoodsCell(){
    WXRemotionImgBtn *_goodsImg;
    UILabel *_goodsInfo;
    UILabel *_goodsPrice;
    UILabel *_goodsNum;
}
@end

@implementation OrderGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 65;
        CGFloat imgHeight = imgWidth;
        _goodsImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderGoodsCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_goodsImg setUserInteractionEnabled:NO];
        [self.contentView addSubview:_goodsImg];
        
        xOffset += imgWidth+12;
        CGFloat yOffset = 16;
        CGFloat infoWidth = 170;
        CGFloat infoHeight = 40;
        _goodsInfo = [[UILabel alloc] init];
        _goodsInfo.frame = CGRectMake(xOffset, yOffset, infoWidth, infoHeight);
        [_goodsInfo setBackgroundColor:[UIColor clearColor]];
        [_goodsInfo setTextAlignment:NSTextAlignmentLeft];
        [_goodsInfo setTextColor:WXColorWithInteger(0x000000)];
        [_goodsInfo setFont:WXTFont(15.0)];
        [_goodsInfo setNumberOfLines:0];
        [self.contentView addSubview:_goodsInfo];
        
        CGFloat xGap = 15;
        CGFloat priceWidth = 60;
        CGFloat priceHeight = 20;
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.frame = CGRectMake(size.width-xGap-priceWidth, yOffset, priceWidth, priceHeight);
        [_goodsPrice setBackgroundColor:[UIColor clearColor]];
        [_goodsPrice setTextAlignment:NSTextAlignmentRight];
        [_goodsPrice setTextColor:WXColorWithInteger(0x000000)];
        [_goodsPrice setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsPrice];
        
        yOffset += priceHeight+2;
        _goodsNum = [[UILabel alloc] init];
        _goodsNum.frame = CGRectMake(size.width-xGap-priceWidth, yOffset, priceWidth, priceHeight);
        [_goodsNum setBackgroundColor:[UIColor clearColor]];
        [_goodsNum setTextAlignment:NSTextAlignmentRight];
        [_goodsNum setTextColor:WXColorWithInteger(0x646464)];
        [_goodsNum setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsNum];
    }
    return self;
}

-(void)load{
    [_goodsImg setCpxViewInfo:@"http://gz.67call.com/wx/Public/Uploads/20140929/20140929111809_9365271.jpeg"];
    [_goodsImg load];
    [_goodsInfo setText:@"夏威夷果218g 1袋 奶油味干果炒货"];
    [_goodsPrice setText:@"￥29.00"];
    [_goodsNum setText:@"*1"];
}

@end
