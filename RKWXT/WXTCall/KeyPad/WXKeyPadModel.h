//
//  WXKeyPadModel.h
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WXKeyPadModelDelegate;
@class ContactBaseEntity;
@interface WXKeyPadModel : NSObject
@property (nonatomic,readonly)NSMutableArray *callHistoryList;
@property (nonatomic,readonly)NSMutableArray * callHistory;
@property (nonatomic,readonly)NSArray *contacterFilter;
@property (nonatomic,assign)id<WXKeyPadModelDelegate>delegate;

- (void)searchContacter:(NSString*)searchString;
//查找~
- (NSString*)callHistoryPhoneAtRow:(NSInteger)row;
- (NSString*)contactPhoneAtRow:(NSInteger)row;
- (ContactBaseEntity*)callhistoryContactEntityAtRow:(NSInteger)row;
- (ContactBaseEntity*)searchContactEntityAtRow:(NSInteger)row;

//清除通话记录
- (void)deleteCallRecordsAtRow:(NSInteger)row;
- (void)clearAllRecords;
@end

@protocol WXKeyPadModelDelegate <NSObject>
- (void)callHistoryChanged;
- (void)callRecordHasCleared;
@end
