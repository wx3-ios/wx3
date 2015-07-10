//
//  OrderInfoCompanyCell.m
//  RKWXT
//
//  Created by SHB on 15/7/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderInfoCompanyCell.h"
#import "WXRemotionImgBtn.h"

@interface OrderInfoCompanyCell(){
    WXRemotionImgBtn *_shopLogoImg;
    UILabel *_shopNameLabel;
    UIImageView *_nextImg;
}
@end

@implementation OrderInfoCompanyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        _shopLogoImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderInfoCompanyCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_shopLogoImg setUserInteractionEnabled:NO];
        [_shopLogoImg setImage:[UIImage imageNamed:@"Icon.png"]];
        [self.contentView addSubview:_shopLogoImg];
        
        xOffset += imgWidth+6;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 15;
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.frame = CGRectMake(xOffset, (OrderInfoCompanyCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_shopNameLabel setBackgroundColor:[UIColor clearColor]];
        [_shopNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_shopNameLabel setTextColor:WXColorWithInteger(0x202020)];
        [_shopNameLabel setFont:WXTFont(14.0)];
        [self.contentView addSubview:_shopNameLabel];
        
        xOffset += nameWidth+5;
        CGFloat arrowWidth = 8;
        CGFloat arrowHeight = 6;
        _nextImg = [[UIImageView alloc] init];
        _nextImg.frame = CGRectMake(IPHONE_SCREEN_WIDTH-arrowWidth-8, (OrderInfoCompanyCellHeight-arrowHeight)/2, arrowWidth, arrowHeight);
        [_nextImg setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:_nextImg];
    }
    return self;
}

-(void)load{
    [_shopNameLabel setText:[NSString stringWithFormat:@"%@",kMerchantName]];
}

@end
