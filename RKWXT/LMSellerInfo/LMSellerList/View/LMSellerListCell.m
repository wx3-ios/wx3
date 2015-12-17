//
//  LMSellerListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerListCell.h"
#import "WXRemotionImgBtn.h"
#import "LMSellerListEntity.h"

@interface LMSellerListCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *addressLabel;
    WXUILabel *distancelabel;
}
@end

@implementation LMSellerListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 75;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMSellerListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 15;
        CGFloat nameLabelWidth = 150;
        CGFloat namelabelHeight = 18;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        CGFloat rightWidth = 50;
        distancelabel = [[WXUILabel alloc] init];
        distancelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-rightWidth, yOffset, rightWidth, namelabelHeight);
        [distancelabel setBackgroundColor:[UIColor clearColor]];
        [distancelabel setTextAlignment:NSTextAlignmentLeft];
        [distancelabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [distancelabel setFont:WXFont(10.0)];
        [self.contentView addSubview:distancelabel];
        
        yOffset += namelabelHeight+6;
        CGFloat disLabelWidth = IPHONE_SCREEN_WIDTH-xOffset-rightWidth;
        CGFloat disLabelHeight = 32;
        addressLabel = [[WXUILabel alloc] init];
        addressLabel.frame = CGRectMake(xOffset, yOffset, disLabelWidth, disLabelHeight);
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [addressLabel setTextAlignment:NSTextAlignmentLeft];
        [addressLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [addressLabel setFont:WXFont(12.0)];
        [addressLabel setNumberOfLines:2];
        [self.contentView addSubview:addressLabel];
    }
    return self;
}

-(void)load{
    LMSellerListEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.sellerImg];
    [imgView load];
    [nameLabel setText:entity.sellerName];
    [addressLabel setText:entity.address];
    [distancelabel setText:[NSString stringWithFormat:@"%.2f",entity.distance]];
}

@end
