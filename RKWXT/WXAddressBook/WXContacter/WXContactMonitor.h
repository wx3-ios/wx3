//
//  WXContactMonitor.h
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXContacterEntity.h"

@interface WXContactMonitor : NSObject
@property (nonatomic,readonly)NSArray *wxContactList;
+ (WXContactMonitor*)sharedWXContactMonitor;
//加载我信用户~
- (void)loadWXContacter;
//清除我信用户
- (void)removeWXContacter;

#pragma mark 查找~
- (BOOL)isPhoneNumberWX:(NSString*)phoneNumber;
- (WXContacterEntity*)entityForPhonNumber:(NSString*)phoneNumber;//通过recordID查找我信用户信息
- (WXContacterEntity*)entityForRecordID:(NSInteger)recordID;//通过recordID查找我信的用户信息
- (WXContacterEntity*)entityForRID:(NSString*)rID;//通过rID查找我信的用户信息
@end
