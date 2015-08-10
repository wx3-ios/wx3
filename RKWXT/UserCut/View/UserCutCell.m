//
//  UserCutCell.m
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserCutCell.h"
#import "UserCutEntity.h"

@interface UserCutCell(){
    WXUILabel *_money;
    WXUILabel *_info;
    WXUILabel *_date;
}
@end

@implementation UserCutCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = UserCutCellHeight-2*10;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (UserCutCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"Icon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 11;
        CGFloat textWidth = 150;
        CGFloat textHeight = 18;
        _money = [[WXUILabel alloc] init];
        _money.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setTextColor:WXColorWithInteger(0x000000)];
        [_money setFont:WXFont(15.0)];
        [self.contentView addSubview:_money];
        
        yOffset += textHeight+4;
        _info = [[WXUILabel alloc] init];
        _info.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_info setBackgroundColor:[UIColor clearColor]];
        [_info setTextAlignment:NSTextAlignmentLeft];
        [_info setTextColor:WXColorWithInteger(0x979797)];
        [_info setFont:WXFont(12.0)];
        [self.contentView addSubview:_info];
        
        CGFloat xGap = 10;
        CGFloat yGap = 11;
        CGFloat dateWidth = 70;
        CGFloat dateHeight = 10;
        _date = [[WXUILabel alloc] init];
        _date.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-dateWidth, yGap, dateWidth, dateHeight);
        [_date setBackgroundColor:[UIColor clearColor]];
        [_date setTextAlignment:NSTextAlignmentRight];
        [_date setTextColor:WXColorWithInteger(0x979797)];
        [_date setFont:WXFont(10.0)];
        [self.contentView addSubview:_date];
    }
    return self;
}

-(void)load{
    UserCutEntity *entity = self.cellInfo;
    [_money setText:[NSString stringWithFormat:@"您已获得%.2f元分成",entity.money]];
    [_info setText:[NSString stringWithFormat:@"来自我信ID为%ld的分成",(long)entity.userID]];
    [_date setText:[UtilTool getDateTimeFor:entity.date type:2]];
}

@end
