//
//  SysMsgTimeCell.m
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgTimeCell.h"
#import "SysMsgItem.h"
#import "NSString+Size.h"
#import "SysMsgUIDef.h"

#define kSysMsgTimeCellYGap (15.0)
#define kSysMsgTimeLabelFontSize (10.0)

@interface SysMsgTimeCell()
{
    WXUITextField *_timeLabel;
}
@end

@implementation SysMsgTimeCell

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		[self setBackgroundColor:[UIColor clearColor]];
		CGRect rect = self.bounds;
		rect.origin.y = kSysMsgTimeCellYGap;
		rect.size.height = kSysMsgTimeCellHeight - kSysMsgTimeCellYGap*2;
        _timeLabel = [[WXUITextField alloc] initWithFrame:rect];
        [_timeLabel setTextColor:WXColorWithInteger(0xffffff)];
		[_timeLabel setEnabled:NO];
		[_timeLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_timeLabel setFont:WXFont(kSysMsgTimeLabelFontSize)];
        [_timeLabel setTextAlignment:UITextAlignmentCenter];
		[_timeLabel setBorderRadian:6.0 width:0 color:[UIColor clearColor]];
		[_timeLabel setBackgroundColor:WXColorWithInteger(0xd2d2d2)];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)load{
    [super load];
    
    SysMsgItem *item = self.cellInfo;
    NSInteger sendTime = item.sendTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sendTime];
	NSString *timeStr = [date YMRSFMString];
    [_timeLabel setText:timeStr];
	
	CGFloat cellWidth = IPHONE_SCREEN_WIDTH-kSysMessageBorderXGap*2;
	CGSize timeSize = [timeStr stringSize:WXFont(kSysMsgTimeLabelFontSize)];
	CGRect rect = _timeLabel.frame;
	CGFloat gap = 8;
	rect.size.width = timeSize.width + gap*2;
	rect.origin.x = (cellWidth-rect.size.width)*0.5;
	[_timeLabel setFrame:rect];
}

@end