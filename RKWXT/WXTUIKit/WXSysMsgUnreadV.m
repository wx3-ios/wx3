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
        UIImage *btnImg = [UIImage imageNamed:@"sysPushMessageIcon.png"];
        CGSize btnSize = btnImg.size;
        
        WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(20, 2, 60, 40);
        [leftBtn setImage:btnImg forState:UIControlStateNormal];
        [leftBtn setTitle:@"消息" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(toUnreadSysMsg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
        CGPoint startImageViewCenter = leftBtn.imageView.center;
        CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
        
        UIImage *image = [UIImage imageNamed:@"unreadBg.png"];
        CGSize imgSize = image.size;
        _unreadNumberImgV = [[WXUIImageView alloc] initWithImage:image];
        CGRect unreadViewRect = CGRectMake(-imgSize.width*0.3 + (frame.size.width-btnSize.width)/2.0-5, (frame.size.height-btnSize.height)/2.0-imgSize.height*0.3-10, imgSize.width, imgSize.height);
        [_unreadNumberImgV setFrame:unreadViewRect];
        [leftBtn addSubview:_unreadNumberImgV];
        
        _unreadLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [_unreadLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_unreadNumberImgV addSubview:_unreadLabel];
        
        [self addOBS];
    }
    return self;
}

- (void)setUnreadNumber:(NSInteger)number{
    number = 1;
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
