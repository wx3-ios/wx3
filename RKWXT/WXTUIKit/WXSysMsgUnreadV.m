//
//  WXSysMsgUnreadV.m
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXSysMsgUnreadV.h"
#import "WXUnreadSysMsgOBJ.h"
#import "JPushDef.h"

#define D_Notification_Name_RewardPacketDetected @"D_Notification_Name_RewardPacketDetected" //检测到一个红包推送


@interface WXSysMsgUnreadV()
{
    WXUIImageView *_unreadNumberImgV;
    WXUILabel *_unreadLabel;
}
@end

@implementation WXSysMsgUnreadV

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIImage *btnImg = [UIImage imageNamed:@"sysPushMessageIcon.png"];
        CGSize btnSize = btnImg.size;
        [button setImage:btnImg forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toUnreadSysMsg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImage *image = [UIImage imageNamed:@"unreadBg.png"];
        CGSize imgSize = image.size;
        _unreadNumberImgV = [[WXUIImageView alloc] initWithImage:image];
        CGRect unreadViewRect = CGRectMake(-imgSize.width*0.3 + (frame.size.width-btnSize.width)/2.0, (frame.size.height-btnSize.height)/2.0-imgSize.height*0.3, imgSize.width, imgSize.height);
        [_unreadNumberImgV setFrame:unreadViewRect];
        [button addSubview:_unreadNumberImgV];
        
        _unreadLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [_unreadLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_unreadNumberImgV addSubview:_unreadLabel];
        
        [self addOBS];
    }
    return self;
}

- (void)setUnreadNumber:(NSInteger)number{
    [_unreadNumberImgV setHidden:number <= 0];
    if(number > 0){
        NSString *text = [NSString stringWithFormat:@"%d",(int)number];
        
        CGSize textSize = [text stringSize:_unreadLabel.font];
        [_unreadLabel setText:text];
        
        CGSize unreadViewSize = _unreadNumberImgV.frame.size;
        CGFloat xOffset = (unreadViewSize.width - textSize.width)*0.5;
        CGFloat yOffset = (unreadViewSize.height - textSize.height)*0.5;
        [_unreadLabel setFrame:CGRectMake(xOffset, yOffset, textSize.width, textSize.height)];
    }
}

- (void)showSysPushMsgUnread{
    NSInteger unreadNumber = [[WXUnreadSysMsgOBJ sharedUnreadSysMsgOBJ] unreadNumber];
    [self setUnreadNumber:unreadNumber];
}

- (void)toUnreadSysMsg{
    if(_delegate && [_delegate respondsToSelector:@selector(toSysPushMsgView)]){
        [_delegate toSysPushMsgView];
    }
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(incomeMsgPush) name:D_Notification_Name_SystemMessageDetected object:nil];
    [notificationCenter addObserver:self selector:@selector(unreadSystemMessageNumberChanged) name:D_NotificationName_UnreadSysMessageNumberChanged object:nil];
}

- (void)unreadSystemMessageNumberChanged{
    [self showSysPushMsgUnread];
}

- (void)incomeMsgPush{
    [[WXUnreadSysMsgOBJ sharedUnreadSysMsgOBJ] increaseUnreadSysMsg:1];
    [self showSysPushMsgUnread];
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
