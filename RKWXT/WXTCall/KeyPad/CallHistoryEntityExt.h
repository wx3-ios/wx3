//
//  CallHistoryEntityExt.h
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallHistoryEntity.h"
@class ContactBaseEntity;
@interface CallHistoryEntityExt : NSObject
@property (nonatomic,retain)ContactBaseEntity *contacterEntity;
@property (nonatomic,readonly)CallHistoryEntity *callHistoryEntity;
@property (nonatomic,readonly)NSArray *recordArray;

- (void)addRecord:(CallHistoryEntity*)entity;
- (BOOL)canMergeRecord:(CallHistoryEntity*)entity;
@end
