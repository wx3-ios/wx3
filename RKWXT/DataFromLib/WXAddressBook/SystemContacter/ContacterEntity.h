//
//  ContacterEntity.h
//  CallTesting
//
//  Created by le ting on 5/19/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "ContactBaseEntity.h"

@interface ContacterEntity : NSObject
//定位联系人
@property (nonatomic,assign)NSInteger recordID;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSArray *phoneNumbers;
@property (nonatomic,retain)NSDate *createTime;
@property (nonatomic,retain)NSDate *modifyTime;
@property (nonatomic,retain)UIImage *icon;
@property (nonatomic,assign)BOOL bUpdated;

+ (id)contacterEntityWithABPerson:(ABRecordRef)person;
- (BOOL)uploadSysContacter;
- (BOOL)matchingString:(NSString *)string;
@end