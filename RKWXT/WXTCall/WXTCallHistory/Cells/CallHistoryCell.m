//
//  CallHistoryCell.m
//  Woxin2.0
//
//  Created by le ting on 7/31/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CallHistoryCell.h"
#import "NSString+Size.h"
#import "CallHistoryEntityExt.h"
#import "NSDate+Compare.h"

@interface CallHistoryCell()
{
    WXUIView *_bgView;
    WXUILabel *_nameLabel;
    WXUILabel *_startTimeLabel;
    WXUIImageView *_wxUserImgView;
    WXUIImageView *_callHistoryTypeImgView;
}
@end

@implementation CallHistoryCell

- (void)dealloc{
//    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *nameFont = WXFont(16.0);
        UIFont *timeFont = WXFont(12.0);
        CGFloat nameHeight = [NSString stringHeightOfFont:nameFont];
        CGFloat timeHeight = [NSString stringHeightOfFont:timeFont];
        
        _bgView = [[WXUIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, kCallHistoryCellHeight)];
        [self.contentView addSubview:_bgView];
		
        CGFloat xGap = 10.0;
        CGFloat xOffset = xGap;
		_callHistoryTypeImgView = [[WXUIImageView alloc] initWithFrame:CGRectMake(xOffset, (kCallHistoryCellHeight - timeHeight)*0.5, timeHeight, timeHeight)];
		[_callHistoryTypeImgView setContentMode:UIViewContentModeCenter];
		[_bgView addSubview:_callHistoryTypeImgView];
		xOffset += timeHeight + xGap;
		CGFloat yGap = (kCallHistoryCellHeight - nameHeight - timeHeight)/3;
		CGFloat yOffset = yGap;
        _nameLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 150.0, nameHeight)];
        [_nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [_nameLabel setTextAlignment:UITextAlignmentLeft];
        [_nameLabel setFont:nameFont];
        [_bgView addSubview:_nameLabel];
        
        _wxUserImgView = [[WXUIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_wxUserImgView setHidden:YES];
        [_wxUserImgView setImage:[UIImage imageNamed:@"wxFriend.png"]];
        [_bgView addSubview:_wxUserImgView];
        
        yOffset += nameHeight + yGap;
        CGFloat timeLength = [@"24:10" sizeWithFont:[UIFont systemFontOfSize:12.0]].width;
        _startTimeLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, timeLength, timeHeight)];
        [_startTimeLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [_startTimeLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_startTimeLabel setTextColor:WXColorWithInteger(0x969696)];
        [_bgView addSubview:_startTimeLabel];
    }
    return self;
}

//- (void)load{
//    [super load];
//    CallHistoryEntityExt *entityExt = self.cellInfo;
//    CallHistoryEntity *entity = entityExt.callHistoryEntity;
//    ContactBaseEntity *contactEntity = entityExt.contacterEntity;
//    
//    NSString *name = [contactEntity nameShow];
//    if(!name){
//        name = entity.phoneNumber;
//    }
//    [_nameLabel setText:name];
//    CGSize nameSize = [self sizeOfString:name font:[UIFont systemFontOfSize:16.0]];
//    [_nameLabel setFrame:CGRectMake(34, 8, nameSize.width, 19)];
//    
//    
//    NSArray *array = [contactEntity contactPhoneArray];
//    ContactPhone *phone = nil;
//    if([array count] > 0){
//        phone = [self phoneNumberIsWoxinUser:entity.phoneNumber withContactPhoneArray:array];
//    }
//    BOOL isWxUser = phone.isWX;
//    if(isWxUser){
//        [_wxUserImgView setHidden:NO];
//    }
//    CGFloat xGap = 34+nameSize.width+4;
//    [_wxUserImgView setFrame:CGRectMake(xGap, 8, 15, 15)];
//    
//    
//    NSDate *startTime = entity.startTime;
//    NSString *timeStr = [startTime YMRSFMString];
//    [_startTimeLabel setText:timeStr];
//    CGFloat timeWidth = [timeStr sizeWithFont:_startTimeLabel.font].width;
//    CGRect rect = _startTimeLabel.frame;
//    rect.size.width = timeWidth;
//    [_startTimeLabel setFrame:rect];
//    UIColor *textColor = WXColorWithInteger(0x323232);
//    UIImage *icon = nil;
//    switch (entity.historyType) {
//        case E_CallHistoryType_IncommingUnread:
//            textColor = WXColorWithInteger(0xff5566);
//            icon = [UIImage imageNamed:@"incomeCallHst.png"];
//            break;
//        case E_CallHistoryType_MakingUnread:
//            textColor = WXColorWithInteger(0xff5566);
//            icon = [UIImage imageNamed:@"makeCallHst.png"];
//            break;
//        case E_CallHistoryType_IncommingReaded:
//            icon = [UIImage imageNamed:@"incomeCallHst.png"];
//            break;
//        case E_CallHistoryType_MakingReaded:
//            icon = [UIImage imageNamed:@"makeCallHst.png"];
//            break;
//        default:
//            break;
//    }
//    [_callHistoryTypeImgView setImage:icon];
//    [_nameLabel setTextColor:textColor];
//}

//判断是否是我信用户
//-(ContactPhone*)phoneNumberIsWoxinUser:(NSString*)callNumber withContactPhoneArray:(NSArray*)numArr{
//    ContactPhone *contactPhone = nil;
//    for(int i = 0;i < [numArr count]; i++){
//        ContactPhone *contact = [numArr objectAtIndex:i];
//        if([callNumber isEqualToString:contact.phone]){
//            contactPhone = [numArr objectAtIndex:i];
//        }
//    }
//    
//    return contactPhone;
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
}

- (CGSize)sizeOfString:(NSString *)txt font:(UIFont *)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
}

@end
