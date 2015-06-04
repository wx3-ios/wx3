//
//  OrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderShopCell.h"
#import "WXRemotionImgBtn.h"

@interface OrderShopCell(){
    WXRemotionImgBtn *_shopLogoImg;
    UILabel *_shopNameLabel;
    UIImageView *_nextImg;
    UILabel *_orderPayStatus;
}
@end

@implementation OrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        _shopLogoImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderShopCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_shopLogoImg setUserInteractionEnabled:NO];
        [self.contentView addSubview:_shopLogoImg];
        
        xOffset += imgWidth+6;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 15;
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.frame = CGRectMake(xOffset, (OrderShopCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_shopNameLabel setBackgroundColor:[UIColor clearColor]];
        [_shopNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_shopNameLabel setTextColor:WXColorWithInteger(0x202020)];
        [_shopNameLabel setFont:WXTFont(14.0)];
        [self.contentView addSubview:_shopNameLabel];
        
        xOffset += nameWidth+5;
        CGFloat arrowWidth = 8;
        CGFloat arrowHeight = 6;
        _nextImg = [[UIImageView alloc] init];
        _nextImg.frame = CGRectMake(xOffset, (OrderShopCellHeight-arrowHeight)/2, arrowWidth, arrowHeight);
        [_nextImg setImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:_nextImg];
        
        CGFloat xgap = 15;
        CGFloat statusWidth = 100;
        CGFloat statusHeight = 20;
        _orderPayStatus = [[UILabel alloc] init];
        _orderPayStatus.frame = CGRectMake(size.width-xgap-statusWidth, (OrderShopCellHeight-statusHeight)/2, statusWidth, statusHeight);
        [_orderPayStatus setBackgroundColor:[UIColor clearColor]];
        [_orderPayStatus setTextAlignment:NSTextAlignmentRight];
        [_orderPayStatus setTextColor:WXColorWithInteger(0xdd2726)];
        [_orderPayStatus setFont:WXTFont(11.0)];
        [self.contentView addSubview:_orderPayStatus];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

-(void)load{
    [_shopNameLabel setText:@"我信科技有限公司"];
    [_orderPayStatus setText:@"待付款"];
    [_shopLogoImg setCpxViewInfo:nil];
    [_shopLogoImg load];
}

@end
