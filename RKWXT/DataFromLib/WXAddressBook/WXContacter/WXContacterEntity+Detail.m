//
//  WXContacterEntity+Detail.m
//  Woxin2.0
//
//  Created by qq on 14-7-30.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "WXContacterEntity.h"
//#import "CallRecord.h"

@implementation WXContacterEntity (Detail)

- (BOOL)shouldShowInviteButton{
    return NO;
}

- (BOOL)shouldShowNickName{
    return YES;
}
- (NSString*)nickNameShow{
    return self.nickName;
}

- (NSArray*)contactPhoneArray{
    NSMutableArray *contactPhoneArray = [NSMutableArray array];
    
//    ContactPhone *contactPhone = [[[ContactPhone alloc] init] autorelease];
//    [contactPhone setPhone:self.bindID];
//    [contactPhone setIsWX:YES];
//    [contactPhoneArray addObject:contactPhone];
    return contactPhoneArray;
}

//- (NSArray *)callHistory{
//    return [[CallRecord sharedCallRecord] recordForPhoneNumber:self.bindID];
//}

@end
