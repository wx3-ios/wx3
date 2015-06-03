//
//  WXSysMsgUnreadV.h
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"

@protocol WXSysMsgUnreadVDelegate;
@interface WXSysMsgUnreadV : WXUIView
@property (nonatomic,assign)id<WXSysMsgUnreadVDelegate>delegate;

- (void)showSysPushMsgUnread;
@end

@protocol WXSysMsgUnreadVDelegate <NSObject>
- (void)toSysPushMsgView;
@end
