//
//  WXTCallHistoryCell.m
//  RKWXT
//
//  Created by SHB on 15/3/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTCallHistoryCell.h"
#import "CallHistoryEntityExt.h"
#import "CallHistoryEntity.h"
#import "ContactBaseEntity.h"
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
        [_userPhone setTextColor:[UIColor grayColor]];
        [_userPhone setFont:WXTFont(12.0)];
        [self.contentView addSubview:_userPhone];
        
        xOffset = self.bounds.size.width*2/3-20;
        CGFloat callTimeLabelWidth = 80;
        _callTime = [[UILabel alloc] init];
        _callTime.frame = CGRectMake(xOffset-5-10, (44-nameLabelHeight)/2, callTimeLabelWidth, nameLabelHeight);
        [_callTime setBackgroundColor:[UIColor clearColor]];
        [_callTime setFont:WXTFont(13.0)];
        [_callTime setTextColor:[UIColor grayColor]];
        [_callTime setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_callTime];
        
        xOffset += callTimeLabelWidth;
        linLabel = [[UILabel alloc] init];
        linLabel.frame = CGRectMake(xOffset, 0, 0.5, 44);
        [linLabel setBackgroundColor:[UIColor grayColor]];
        //        [self.contentView addSubview:linLabel];
        
        UIImage *callImg = [UIImage imageNamed:@"callHistoryBtnImg.png"];
        callBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(xOffset+14, (44-callImg.size.height)/2, callImg.size.width, callImg.size.height);
        [callBtn setBackgroundImage:callImg forState:UIControlStateNormal];
        [self.contentView addSubview:callBtn];
        
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xOffset - 30, 0, self.bounds.size.width-xOffset+30, 44);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(callHistory) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
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
    CallHistoryEntityExt *entityExt = self.cellInfo;
    CallHistoryEntity * entity = entityExt.callHistoryEntity;
    ContactBaseEntity * contactEntity = entityExt.contacterEntity;
    
//    NSString *name = [contactEntity nameShow];
    if(!entity.name || [entity.name isEqualToString:@"我信"]){
        entity.name = entity.phoneNumber;
    }
//
    NSArray *array = [contactEntity contactPhoneArray];
    ContactPhone *phone = nil;
    if([array count] > 0){
        phone = [self phoneNumberIsWoxinUser:entity.phoneNumber withContactPhoneArray:array];
    }
    
    [_nameLabel setText:entity.name];
    
    NSString *prePhone = [UtilTool callPhoneNumberRemovePreWith:entity.phoneNumber];
    [_userPhone setText:prePhone];
    NSString *startTime = entity.callStartTime;
    //    NSString *timeStr = [startTime YMRSFMString];
    [_callTime setText:startTime];
}

-(void)callHistory{
    CallHistoryEntityExt *entityExt = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(callHistoryName:andPhone:)]){
        [_delegate callHistoryName:entityExt.callHistoryEntity.name andPhone:entityExt.callHistoryEntity.phoneNumber];
    }
}

//判断是否是我信用户
-(ContactPhone*)phoneNumberIsWoxinUser:(NSString*)callNumber withContactPhoneArray:(NSArray*)numArr{
    ContactPhone *contactPhone = nil;
    for(int i = 0;i < [numArr count]; i++){
        ContactPhone *contact = [numArr objectAtIndex:i];
        if([callNumber isEqualToString:contact.phone]){
            contactPhone = [numArr objectAtIndex:i];
        }
    }
    
    return contactPhone;
}


@end
