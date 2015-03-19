//
//  ContactUitl.h
//  Okboo
//
//  Created by jjyo.kwan on 12-8-15.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "ContactData.h"

#define CONTACT_ALPHA_START   @"★"
#define CONTACT_ALPHA_POUND   @"#"
#define NOTIFY_CONTACT_UPDATE @"NotifyContactUpdate"

@interface ContactUitl : NSObject
{
    
    @private
    BOOL _isLoad;
}


//@property (nonatomic, strong) NSArray *contactArray;
@property(nonatomic, strong, readonly) NSMutableDictionary *contactDictionary;
@property(nonatomic, strong, readonly) NSArray *contactArray;
@property(nonatomic, strong, readonly) NSDictionary *areaDictionar;
@property(nonatomic, strong, readonly) ContactData *kefu;

@property(nonatomic, getter = isQueryFinish, readonly) BOOL queryFinish;//归属查询完毕

//是否有读取联系人的权限
+ (BOOL)isAuthorized;

+ (ContactUitl *)shareInstance;

+ (NSString *)cleanTokenForNumber:(NSString *)number;


- (void)fitIndexsForContact:(ContactData *)contact;
- (ContactData *)queryContactFromPhone:(NSString *)phone;

- (NSArray *)allContacts;

- (void)addContact:(ABRecordRef)record;


- (void)loadAddressBook;



@end
