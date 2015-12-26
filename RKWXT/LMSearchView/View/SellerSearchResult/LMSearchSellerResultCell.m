//
//  LMSearchSellerResultCell.m
//  RKWXT
//
//  Created by SHB on 15/12/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchSellerResultCell.h"
#import "LMSearchSellerEntity.h"
#import "WXRemotionImgBtn.h"

@interface LMSearchSellerResultCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *addressLabel;
}
@end

@implementation LMSearchSellerResultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 75;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMSearchSellerResultCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+15;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 18;
        CGFloat yOffset = 17;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameHeight+10;
        CGFloat addressWidth = 170;
        CGFloat addressHeight = 35;
        addressLabel = [[WXUILabel alloc] init];
        addressLabel.frame = CGRectMake(xOffset, yOffset, addressWidth, addressHeight);
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [addressLabel setTextAlignment:NSTextAlignmentLeft];
        [addressLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [addressLabel setFont:WXFont(14.0)];
        [addressLabel setNumberOfLines:2];
        [self.contentView addSubview:addressLabel];
    }
    return self;
}

-(void)load{
    LMSearchSellerEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.imgUrl];
    [imgView load];
    [nameLabel setText:entity.sellerName];
    [addressLabel setText:entity.address];
}

@end
