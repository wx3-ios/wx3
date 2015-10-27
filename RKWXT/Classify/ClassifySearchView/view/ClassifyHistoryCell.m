//
//  ClassifyHistoryCell.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyHistoryCell.h"
#import "ClassifySqlEntity.h"

@interface ClassifyHistoryCell(){
    WXUILabel *nameLabel;
    WXUILabel *_timeLabel;
}
@end

@implementation ClassifyHistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 25;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x606062)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        CGFloat timeWidth = 140;
        _timeLabel = [[WXUILabel alloc] init];
        _timeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-timeWidth-xOffset, (44-labelHeight)/2, timeWidth, labelHeight);
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setTextColor:[UIColor grayColor]];
        [_timeLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

-(void)load{
    ClassifySqlEntity *entity = self.cellInfo;
    if([entity isKindOfClass:[NSString class]]){
        [_timeLabel setHidden:YES];
        [nameLabel setText:[NSString stringWithFormat:@"%@  (%ld条)",AlertRecordName,(long)_count]];
        [nameLabel setFont:WXFont(12.0)];
        [nameLabel setTextColor:[UIColor grayColor]];
    }else{
        [_timeLabel setHidden:NO];
        [nameLabel setText:entity.recordName];
        [_timeLabel setFont:WXFont(14.0)];

        NSString *time = [UtilTool getDateTimeFor:entity.recordTime type:1];
        NSString *timerStr = [self dateWithTimeInterval:time];
        [_timeLabel setText:timerStr];
    }
}

-(NSString*)dateWithTimeInterval:(NSString*)timer{
    if(!timer){
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timer];
    NSInteger timeSp = [date timeIntervalSince1970];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSString *timeStr = [date1 YMRSFMString];
    
    return timeStr;
}

@end