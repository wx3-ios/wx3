//
//  WXUnreadSysMsgOBJ.m
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUnreadSysMsgOBJ.h"

@implementation WXUnreadSysMsgOBJ

+ (WXUnreadSysMsgOBJ*)sharedUnreadSysMsgOBJ{
    static dispatch_once_t predicate;
    static WXUnreadSysMsgOBJ *sharedUnreadSysMsgOBJ = nil;
    dispatch_once(&predicate, ^{
        sharedUnreadSysMsgOBJ = [[WXUnreadSysMsgOBJ alloc] init];
    });
    return sharedUnreadSysMsgOBJ;
}

- (NSInteger)unreadNumber{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    return [userDefault integerValueForKey:D_WXUserdefault_Key_iUnreadSysMsg];
}

- (void)setUnreadNumber:(NSInteger)number{
    if(number < 0){
        KFLog_Normal(YES, @"系统推送信息未读数目错误");
    }else{
        WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
        [userDefault setInteger:number forKey:D_WXUserdefault_Key_iUnreadSysMsg];
    }
}

- (void)increaseUnreadSysMsg:(NSInteger)number{
    NSInteger unread = [self unreadNumber];
    unread += number;
    [self setUnreadNumber:unread];
}

- (void)clearUnreadNumber{
    [self setUnreadNumber:0];
}
@end
