//
//  AddressBook.h
//  Woxin2.0
//
//  Created by le ting on 7/10/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContacterEntity.h"

@interface AddressBook : NSObject
@property (nonatomic,readonly)NSArray *contactList;

+ (AddressBook*)sharedAddressBook;
//加载通讯录~
- (void)loadContact;
//上传通讯录~
- (void)uploadSysContacters;
- (ContacterEntity*)contacterEntityForRecordID:(NSInteger)recordID;//通过recordID获取实体~
- (ContacterEntity*)contacterEntityForNumber:(NSString*)phone;//通过号码获取实体
@end
