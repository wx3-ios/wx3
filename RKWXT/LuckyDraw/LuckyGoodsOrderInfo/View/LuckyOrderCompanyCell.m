//
//  LuckyOrderCompanyCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderCompanyCell.h"

@interface LuckyOrderCompanyCell(){
    WXUIImageView *_shopLogoImg;
    UILabel *_shopNameLabel;
    UIImageView *_nextImg;
}
@end

@implementation LuckyOrderCompanyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        _shopLogoImg = [[WXUIImageView alloc] initWithFrame:CGRectMake(xOffset, (LuckyOrderCompanyCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_shopLogoImg setUserInteractionEnabled:NO];
        [_shopLogoImg setImage:[UIImage imageNamed:@"Icon.png"]];
        [self.contentView addSubview:_shopLogoImg];
        
        xOffset += imgWidth+6;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 15;
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.frame = CGRectMake(xOffset, (LuckyOrderCompanyCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_shopNameLabel setBackgroundColor:[UIColor clearColor]];
        [_shopNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_shopNameLabel setTextColor:WXColorWithInteger(0x202020)];
        [_shopNameLabel setFont:WXTFont(14.0)];
        [self.contentView addSubview:_shopNameLabel];
        
        xOffset += nameWidth+5;
        CGFloat arrowWidth = 8;
        CGFloat arrowHeight = 12;
        _nextImg = [[UIImageView alloc] init];
        _nextImg.frame = CGRectMake(IPHONE_SCREEN_WIDTH-arrowWidth-8, (LuckyOrderCompanyCellHeight-arrowHeight)/2, arrowWidth, arrowHeight);
        [_nextImg setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:_nextImg];
    }
    return self;
}

-(void)load{
    [_shopNameLabel setText:kMerchantName];
}

@end
