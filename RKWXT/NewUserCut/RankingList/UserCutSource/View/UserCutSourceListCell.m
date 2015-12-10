//
//  UserCutSourceListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceListCell.h"
#import "WXRemotionImgBtn.h"
#import "UserCutSourceEntity.h"

@interface UserCutSourceListCell(){
    WXUILabel *timeLabel;
    WXRemotionImgBtn *imgView;
    WXUILabel *moneyLabel;
    WXUILabel *textLabel;
}
@end

@implementation UserCutSourceListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = IPHONE_SCREEN_WIDTH/3;
        CGFloat labelHeight = 16;
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(0, (UserCutSourceListCellHeight-labelHeight)/2, xOffset-3, labelHeight);
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:WXFont(12.0)];
        [timeLabel setTextColor:WXColorWithInteger(0xababab)];
        [self.contentView addSubview:timeLabel];
        
        CGFloat imgWidth = 35;
        CGFloat imgHeight = imgWidth;
        WXUILabel *upLineLabel = [[WXUILabel alloc] init];
        upLineLabel.frame = CGRectMake(xOffset+imgWidth/2, 0, 0.5, (UserCutSourceListCellHeight-imgHeight)/2);
        [upLineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:upLineLabel];
        
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (UserCutSourceListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setBorderRadian:imgWidth/2 width:1.0 color:[UIColor clearColor]];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        WXUILabel *downLineLabel = [[WXUILabel alloc] init];
        downLineLabel.frame = CGRectMake(xOffset+imgWidth/2, imgView.frame.origin.y+imgHeight, 0.5, (UserCutSourceListCellHeight-imgHeight)/2);
        [downLineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:downLineLabel];
        
        xOffset += imgWidth+5;
        moneyLabel = [[WXUILabel alloc] init];
        moneyLabel.frame = CGRectMake(xOffset, imgView.frame.origin.y, IPHONE_SCREEN_WIDTH-xOffset, labelHeight);
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [moneyLabel setFont:WXFont(15.0)];
        [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:moneyLabel];
        
        textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, imgView.frame.origin.y+labelHeight+2, IPHONE_SCREEN_WIDTH-xOffset, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setTextColor:WXColorWithInteger(0xababab)];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    UserCutSourceEntity *entity = self.cellInfo;
    [timeLabel setText:entity.grade];
    
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfo.png"];
    [imgView setImage:iconImg];
    if(![entity.imgUrl isEqualToString:@""] && entity.imgUrl){
        [imgView setCpxViewInfo:entity.imgUrl];
        [imgView load];
    }
    [moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.money]];
    
    
    NSString *name = nil;
    name = [NSString stringWithFormat:@"%ld",(long)entity.wxID];
    if(![entity.nickName isEqualToString:@""] && entity.nickName){
        name = entity.nickName;
    }
    [textLabel setText:[NSString stringWithFormat:@"来自%@的分成",name]];
}

@end
