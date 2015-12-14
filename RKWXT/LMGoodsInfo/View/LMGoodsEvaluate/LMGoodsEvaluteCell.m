//
//  LMGoodsEvaluteCell.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsEvaluteCell.h"
#import "WXRemotionImgBtn.h"

@interface LMGoodsEvaluteCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *timeLabel;
    WXUILabel *InfoLabel;
}
@end

@implementation LMGoodsEvaluteCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 9;
        CGFloat yOffset = 7;
        CGFloat imgWidth = 40;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [imgView setBorderRadian:imgWidth/2 width:0.5 color:[UIColor clearColor]];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+4;
        yOffset += 4;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 18;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:WXFont(10.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        yOffset += labelHeight;
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTextColor:WXColorWithInteger(0xfafafa)];
        [timeLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:timeLabel];
        
        yOffset = imgHeight+2*10;
        InfoLabel = [[WXUILabel alloc] init];
        InfoLabel.frame = CGRectMake(7, yOffset, IPHONE_SCREEN_WIDTH-2*7, 10);
        [InfoLabel setBackgroundColor:[UIColor clearColor]];
        [InfoLabel setTextAlignment:NSTextAlignmentLeft];
        [InfoLabel setTextColor:WXColorWithInteger(0x000000)];
        [InfoLabel setFont:WXFont(12.0)];
        [InfoLabel setNumberOfLines:0];
        [self.contentView addSubview:InfoLabel];
    }
    return self;
}

-(void)load{
    
}

@end
