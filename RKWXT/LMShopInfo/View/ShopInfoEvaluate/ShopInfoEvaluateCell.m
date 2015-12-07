//
//  ShopInfoEvaluateCell.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopInfoEvaluateCell.h"
#import "LMShopInfoDef.h"
#import "WXRemotionImgBtn.h"

@interface ShopInfoEvaluateCell(){
    WXRemotionImgBtn *headImg;
    WXUILabel *nameLabel;
    WXUILabel *timeLabel;
    WXUILabel *infoLabel;
}
@end

@implementation ShopInfoEvaluateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat imgWidth = 40;
        CGFloat imgHeight = imgWidth;
        headImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [headImg setBorderRadian:imgWidth/2 width:imgWidth/2 color:[UIColor clearColor]];
        [headImg setUserInteractionEnabled:NO];
        [self.contentView addSubview:headImg];
        
        xOffset += 10;
        yOffset += 6;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelHeight = 17;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += 4;
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTextColor:WXColorWithInteger(0xb2b2b2)];
        [timeLabel setFont:WXFont(12.0)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:timeLabel];
        
        yOffset = 10+imgHeight+10;
        xOffset = 10;
        infoLabel = [[WXUILabel alloc] init];
        infoLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset-20, 10);
        [infoLabel setTextAlignment:NSTextAlignmentLeft];
        [infoLabel setTextColor:WXColorWithInteger(0xb2b2b2)];
        [infoLabel setFont:WXFont(12.0)];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:infoLabel];
    }
    return self;
}

-(void)load{
    
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 10;
}

@end
