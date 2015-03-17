//
//  CallHistoryModel.h
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallHistoryEntity.h"

@interface CallRecord : NSObject
@property (nonatomic,readonly)NSArray *callHistoryList;

+ (CallRecord*)sharedCallRecord;
- (BOOL)loadRecord;
- (void)removeCallRecorder;


- (BOOL)addRecord:(NSString*)phoneNumber recordType:(E_CallHistoryType)recordType
        startTime:(NSInteger)startTime duration:(NSInteger)duration;//添加通话记录~
- (BOOL)deleteCallRecord:(NSInteger)recordUID;//删除通话记录~

- (NSArray*)recordForPhoneNumber:(NSString*)phoneNumber;
- (NSArray*)recordForPhoneNumbers:(NSArray*)phoneNumbers;
@end
