//
//  LMOrderInfoGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoGoodsListCell.h"
#import "WXRemotionImgBtn.h"

@interface LMOrderInfoGoodsListCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *stockLabel;
    WXUILabel *priceLabel;
    WXUILabel *numberLabel;
}
@end

@implementation LMOrderInfoGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 4;
        CGFloat imgWidth = 82;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMOrderInfoGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        CGFloat yOffset = 20;
        xOffset += imgWidth+3;
        CGFloat nameLabelWidth = 200;
        CGFloat namelabelHieght = 38;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHieght);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += namelabelHieght+5;
        stockLabel = [[WXUILabel alloc] init];
        stockLabel.frame = CGRectMake(xOffset, yOffset, 150, namelabelHieght);
        [stockLabel setBackgroundColor:[UIColor clearColor]];
        [stockLabel setTextAlignment:NSTextAlignmentLeft];
        [stockLabel setFont:WXFont(10.0)];
        [stockLabel setTextColor:WXColorWithInteger(0xc6c6c6)];
        [self.contentView addSubview:stockLabel];
        
        yOffset += namelabelHieght+5;
        priceLabel = [[WXUILabel alloc] init];
        priceLabel.frame = CGRectMake(xOffset, yOffset, 150, namelabelHieght);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        [priceLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [priceLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:priceLabel];
        
        numberLabel = [[WXUILabel alloc] init];
        numberLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-50, yOffset, 50, namelabelHieght);
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextAlignment:NSTextAlignmentRight];
        [numberLabel setFont:WXFont(14.0)];
        [numberLabel setTextColor:WXColorWithInteger(0x434343)];
        [self.contentView addSubview:numberLabel];
    }
    return self;
}

-(void)load{
    
}

@end
