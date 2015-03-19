//
//  ContacterEntity+Detail.m
//  Woxin2.0
//
//  Created by qq on 14-7-30.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "ContacterEntity.h"
//#import "CallRecord.h"

@implementation ContacterEntity (Detail)

- (BOOL)shouldShowInviteButton{
    WXContactMonitor *wxContacters = [WXContactMonitor sharedWXContactMonitor];
    for(NSString *phone in self.phoneNumbers){
        if(![wxContacters isPhoneNumberWX:phone]){
            return YES;
        }
    }
    return NO;
}

//- (NSArray *)callHistory{
//    return [[CallRecord sharedCallRecord] recordForPhoneNumbers:self.phoneNumbers];
//}

//- (NSArray*)contactPhoneArray{
//    NSMutableArray *contactPhoneArray = [NSMutableArray array];
//    WXContactMonitor *wxContacters = [WXContactMonitor sharedWXContactMonitor];
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    for(NSString *phone in self.phoneNumbers){
//        ContactPhone *contactPhone = [[[ContactPhone alloc] init] autorelease];
//        [contactPhone setPhone:phone];
//        if([wxContacters isPhoneNumberWX:phone]){
//            [contactPhone setIsWX:YES];
//        }else{
//            [contactPhone setIsWX:NO];
//        }
//        [contactPhoneArray addObject:contactPhone];
//    }
//    [pool drain];
//    return contactPhoneArray;
//}

@end
