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
@class EGODatabase;
#define kPhoneNumberCount (11)
//ip电话前缀
static const char *s_ipPre[] ={
    "12593",
    "17951",
    "17900",
    "17901",
    "17908",
    "17909",
    "17911",
    "17931",
    "19389",
    "10131",
    "286",
    "818",
    "858",
};

@interface ContacterEntity : ContactBaseEntity
@property (nonatomic)ABRecordRef person;
@property (nonatomic,retain)NSString * lastName;
@property (nonatomic,retain)NSString *fullName;
@property (nonatomic,assign)NSInteger recordID;
@property (nonatomic,retain)NSArray *phoneNumbers;
@property (nonatomic,retain)NSDate *createTime;
@property (nonatomic,retain)NSDate *modifyTime;
@property (nonatomic,retain)UIImage *icon;
@property (nonatomic,assign)BOOL bUpdated;
@property (nonatomic, strong) EGODatabase * database;

+ (id)contacterEntityWithABPerson:(ABRecordRef)person;
-(BOOL)createBookDatabase;
- (BOOL)uploadSysContacter;
- (BOOL)matchingString:(NSString *)string;
@end