//
//  ContactBaseEntity+Detail.m
//  Woxin2.0
//
//  Created by qq on 14-7-30.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "ContactBaseEntity.h"

@implementation ContactBaseEntity (Detail)

- (BOOL)shouldShowInviteButton{
    return NO;
}
- (BOOL)shouldShowNickName{
    return NO;
}
- (NSString*)nickNameShow{
    return nil;
}
- (NSArray *)callHistory{
    return nil;
}

- (NSArray*)contactPhoneArray{
    return nil;
}
@end
