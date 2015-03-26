//
//  WXTCallHistoryCell.m
//  RKWXT
//
//  Created by SHB on 15/3/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTCallHistoryCell.h"
#import "CallHistoryEntity.h"
#import "SysContacterEntityEx.h"
#import "WXKeyPadModel.h"

@interface WXTCallHistoryCell(){
    UILabel *_nameLabel;
    UILabel *_userPhone;
    UILabel *_callTime;
    UILabel *linLabel;
    WXTUIButton *callBtn;
    
    WXKeyPadModel *_model;
}
@end

@implementation WXTCallHistoryCell

-(id)init{
    self = [super init];
    if(self){
        _model = [[WXKeyPadModel alloc] init];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat yOffset = 5;
        CGFloat nameLabelWidth = 140;
        CGFloat nameLabelHeight = 18;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setFont:WXTFont(16.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameLabelHeight;
        _userPhone = [[UILabel alloc] init];
        _userPhone.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [_userPhone setBackgroundColor:[UIColor clearColor]];
        [_userPhone setTextAlignment:NSTextAlignmentLeft];
        [_userPhone setTextColor:[UIColor blackColor]];
        [_userPhone setFont:WXTFont(12.0)];
        [self.contentView addSubview:_userPhone];
        
        xOffset = self.bounds.size.width*2/3-20;
        NSLog(@"self.bounds.size.width = %ld",(long)self.bounds.size.width);
        CGFloat callTimeLabelWidth = 80;
        _callTime = [[UILabel alloc] init];
        _callTime.frame = CGRectMake(xOffset-5, (44-nameLabelHeight)/2, callTimeLabelWidth, nameLabelHeight);
        [_callTime setBackgroundColor:[UIColor clearColor]];
        [_callTime setFont:WXTFont(13.0)];
        [_callTime setTextColor:[UIColor grayColor]];
        [_callTime setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_callTime];
        
        xOffset += callTimeLabelWidth;
        linLabel = [[UILabel alloc] init];
        linLabel.frame = CGRectMake(xOffset, 0, 0.5, 44);
        [linLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:linLabel];
        
        UIImage *callImg = [UIImage imageNamed:@"CallNormal.png"];
        callBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(xOffset+14, (44-callImg.size.height)/2, callImg.size.width, callImg.size.height);
        [callBtn setBackgroundImage:callImg forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callHistory) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect rect = frame;
    if(rect.size.width == 375){
        CGRect callRect = _callTime.frame;
        callRect.origin.x = 220;
        [_callTime setFrame:callRect];
        
        CGRect lineRect = linLabel.frame;
        lineRect.origin.x = 310;
        [linLabel setFrame:lineRect];
        
        CGRect btnRect = callBtn.frame;
        btnRect.origin.x = 336;
        [callBtn setFrame:btnRect];
    }
    if(rect.size.width == 414){
        CGRect callRect = _callTime.frame;
        callRect.origin.x = 250;
        [_callTime setFrame:callRect];
        
        CGRect lineRect = linLabel.frame;
        lineRect.origin.x = 340;
        [linLabel setFrame:lineRect];
        
        CGRect btnRect = callBtn.frame;
        btnRect.origin.x = 366;
        [callBtn setFrame:btnRect];
    }
}

-(void)load{
    CallHistoryEntity *_callHistoryEntity = self.cellInfo;
    [_nameLabel setText:_userName];
    [_userPhone setText:_callHistoryEntity.phoneNumber];
    [_callTime setText:_callHistoryEntity.date];
}

-(void)callHistory{
    CallHistoryEntity *_callHistoryEntity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(callHistoryName:andPhone:)]){
        [_delegate callHistoryName:_userName andPhone:_callHistoryEntity.phoneNumber];
    }
}

@end
