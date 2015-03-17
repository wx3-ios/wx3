//
//  WXUnreadSysMsgOBJ.h
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_NotificationName_UnreadSysMessageNumberChanged @"D_NotificationName_UnreadSysMessageNumberChanged"

@interface WXUnreadSysMsgOBJ : NSObject

+ (WXUnreadSysMsgOBJ*)sharedUnreadSysMsgOBJ;

- (NSInteger)unreadNumber;//未读数目
- (void)setUnreadNumber:(NSInteger)number;//设置未读信息数目
- (void)increaseUnreadSysMsg:(NSInteger)number;//增加未读系统信息
- (void)clearUnreadNumber;//清除未读信息数目
@end
