//
//  LMGoodsMoreEvaluateCell.m
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsMoreEvaluateCell.h"
#import "WXRemotionImgBtn.h"
#import "LMGoodsEvaluateEntity.h"

@interface LMGoodsMoreEvaluateCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *timeLabel;
    WXUILabel *desLabel;
}
@end

@implementation LMGoodsMoreEvaluateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat imgWidth = 40;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [imgView setBorderRadian:imgWidth/2 width:1.0 color:[UIColor clearColor]];
        [imgView setUserInteractionEnabled:YES];
        [self.contentView addSubview:imgView];
        
        xOffset += +imgWidth+10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelHieght = 18;
        yOffset += 4;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHieght);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameLabelHieght+3;
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHieght-2);
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTextColor:WXColorWithInteger(0xb2b2b2)];
        [timeLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:timeLabel];
        
        yOffset = imgHeight+2*10;
        xOffset = 10;
        desLabel = [[WXUILabel alloc] init];
        desLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, 10);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentLeft];
        [desLabel setTextColor:WXColorWithInteger(0x000000)];
        [desLabel setFont:WXFont(14.0)];
        [desLabel setNumberOfLines:0];
        [self.contentView addSubview:desLabel];
    }
    return self;
}

-(void)load{
    LMGoodsEvaluateEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.userHeadImg];
    [imgView load];
    [nameLabel setText:entity.nickName];
    [timeLabel setText:[UtilTool getDateTimeFor:entity.addTime type:2]];
    [desLabel setText:entity.content];
    
    CGRect rect = desLabel.frame;
    rect.size.height = [entity.content stringHeight:WXFont(14.0) width:IPHONE_SCREEN_WIDTH-2*10];
    [desLabel setFrame:rect];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    LMGoodsEvaluateEntity *entity = cellInfo;
    CGFloat height = [entity.content stringHeight:WXFont(14.0) width:IPHONE_SCREEN_WIDTH-2*10];
    return height+64;
}

@end
