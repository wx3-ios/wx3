//
//  AliRecordListCell.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AliRecordListCell.h"
#import "WithdrawalsRecordEntity.h"

@interface AliRecordListCell(){
    WXUILabel *_phoneLabel;
    WXUILabel *_statusLabel;
    WXUILabel *_timeLabel;
    WXUILabel *_moneyLabel;
}
@end

@implementation AliRecordListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat yOffset = 10;
        CGFloat labelWidth = 110;
        CGFloat labelHeight = 16;
        _phoneLabel = [[WXUILabel alloc] init];
        _phoneLabel.frame = CGRectMake(xOffset, yOffset, labelWidth+45, labelHeight);
        [_phoneLabel setBackgroundColor:[UIColor clearColor]];
        [_phoneLabel setTextAlignment:NSTextAlignmentLeft];
        [_phoneLabel setTextColor:WXColorWithInteger(0x000000)];
        [_phoneLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_phoneLabel];
        
        CGFloat yGap = yOffset+labelHeight+10;
        _statusLabel = [[WXUILabel alloc] init];
        _statusLabel.frame = CGRectMake(xOffset, yGap, labelWidth, labelHeight);
        [_statusLabel setTextAlignment:NSTextAlignmentLeft];
        [_statusLabel setTextColor:WXColorWithInteger(0x8c8c8c)];
        [_statusLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_statusLabel];
        
        _timeLabel = [[WXUILabel alloc] init];
        _timeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, yOffset, labelWidth, labelHeight);
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setTextColor:WXColorWithInteger(0x8c8c8c)];
        [_timeLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_timeLabel];
        
        _moneyLabel = [[WXUILabel alloc] init];
        _moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, yGap, labelWidth, labelHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentRight];
        [_moneyLabel setTextColor:WXColorWithInteger(0xf36f25)];
        [_moneyLabel setFont:WXFont(18.0)];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}

-(void)load{
    WithdrawalsRecordEntity *entity = self.cellInfo;
    [_phoneLabel setText:entity.phoneStr];
    
    if(entity.ali_type == AliMoney_Type_Submit){
        [_statusLabel setText:@"审核中"];
        [_timeLabel setText:[NSString stringWithFormat:@"%@",[UtilTool getDateTimeFor:entity.addTime type:2]]];
    }
    if(entity.ali_type == AliMoney_Type_Complete){
        [_statusLabel setText:@"已处理"];
        [_timeLabel setText:[NSString stringWithFormat:@"%@",[UtilTool getDateTimeFor:entity.completeTime type:2]]];
    }
    if(entity.ali_type == AliMoney_Type_Failed){
        [_statusLabel setText:@"提现失败"];
        [_timeLabel setText:[NSString stringWithFormat:@"%@",[UtilTool getDateTimeFor:entity.completeTime type:2]]];
    }
    [_moneyLabel setText:[NSString stringWithFormat:@"-%.2f",entity.money]];
}

@end
