//
//  LMGoodsOtherSellerCell.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsOtherSellerCell.h"
#import "LMGoodsInfoEntity.h"

@interface LMGoodsOtherSellerCell(){
    WXUILabel *sellerNameLabel;
    WXUILabel *sellerDesLabel;
    WXUIImageView *imgView;
    WXUILabel *distanceLabel;
}
@end

@implementation LMGoodsOtherSellerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 13;
        CGFloat yOffset = 10;
        CGFloat rightViewWidth = 90;
        CGFloat nameLabelWidth = IPHONE_SCREEN_WIDTH-rightViewWidth-xOffset;
        CGFloat namelabelHeight = 16;
        sellerNameLabel = [[WXUILabel alloc] init];
        sellerNameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [sellerNameLabel setBackgroundColor:[UIColor clearColor]];
        [sellerNameLabel setTextAlignment:NSTextAlignmentLeft];
        [sellerNameLabel setTextColor:WXColorWithInteger(0x000000)];
        [sellerNameLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:sellerNameLabel];
        
        yOffset += namelabelHeight;
        sellerDesLabel = [[WXUILabel alloc] init];
        sellerDesLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [sellerDesLabel setBackgroundColor:[UIColor clearColor]];
        [sellerDesLabel setTextAlignment:NSTextAlignmentLeft];
        [sellerDesLabel setTextColor:WXColorWithInteger(0xb2b2b2)];
        [sellerDesLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:sellerDesLabel];
        
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth+4;
        imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-rightViewWidth, yOffset, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"LMGoodsInfoLocationImg.png"]];
        [self.contentView addSubview:imgView];
        
        distanceLabel = [[WXUILabel alloc] init];
        distanceLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-rightViewWidth+imgWidth+4, yOffset, rightViewWidth-imgWidth-4, namelabelHeight);
        [distanceLabel setBackgroundColor:[UIColor clearColor]];
        [distanceLabel setTextAlignment:NSTextAlignmentLeft];
        [distanceLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [distanceLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:distanceLabel];
    }
    return self;
}

-(void)load{
    LMGoodsInfoEntity *entity = self.cellInfo;
    [sellerNameLabel setText:entity.shopName];
    [sellerDesLabel setText:entity.shopAddress];
    CGFloat distance = entity.shopDistance;
    if(entity.shopDistance > 1000){
        distance = entity.shopDistance/1000;
    }
    [distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",distance]];
}

@end
