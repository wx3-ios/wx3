//  AddressBook.m
//  Woxin2.0
//
//  Created by le ting on 7/10/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import "ServiceMonitor.h"
#import "ServiceCommon.h"

@interface AddressBook()
{
    ABAddressBookRef _addressBookRef;
    NSMutableArray *_contactList;
    dispatch_queue_t _loadRecordImageQueue;
}
@end

@implementation AddressBook
@synthesize contactList = _contactList;

- (void)dealloc{
    if(_addressBookRef){
        CFRelease(_addressBookRef);
    }
//    dispatch_release(_loadRecordImageQueue);
	[self removeOBS];
//    [super dealloc];
}

+ (AddressBook*)sharedAddressBook{
    static dispatch_once_t onceToken;
    static AddressBook *sharedAddressBook = nil;
    dispatch_once(&onceToken, ^{
        sharedAddressBook = [[AddressBook alloc] init];
    });
    return sharedAddressBook;
}

- (id)init{
    if(self = [super init]){
        _contactList = [[NSMutableArray alloc] init];
        _loadRecordImageQueue = dispatch_queue_create("loadRecordImageQueue", 0);
        [self registerAddressBookChanged];
		[self addOBS];
    }
    return self;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(hasLogin:) name:D_Notification_Name_LoginSucceed object:nil];
}

- (void)hasLogin:(NSNotification*)notification{
	[self uploadSysContacters:_contactList];
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadContactInfo{
    [self loadContact];
}

- (ABAddressBookRef)addressBook
{
    //注意:这个函数可能会在多线程上调用,必须要做线程加锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(isIOS6 || isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
            _addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
#endif
        }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
            _addressBookRef = ABAddressBookCreate();
#endif
        }
    });
    return _addressBookRef;
}

- (void)registerAddressBookChanged{
    ABAddressBookRegisterExternalChangeCallback([self addressBook], MyAddressBookExternalChangeCallback, self);
}

void MyAddressBookExternalChangeCallback (ABAddressBookRef addressBook, CFDictionaryRef info, void *context){
    KFLog_Normal(YES, @"addressBookChanged");
    ABAddressBookRevert(addressBook);
    AddressBook *sharedAddressBook = (__bridge AddressBook*)context;
    [sharedAddressBook loadContactInfo];
}

- (void)unregisterAddressBookChanged{
    ABAddressBookUnregisterExternalChangeCallback([self addressBook], MyAddressBookExternalChangeCallback, self);
}

- (void)loadContact{
	//先删除所有的联系人~
	[_contactList removeAllObjects];
    __block NSMutableArray *contactList = _contactList;
    __block AddressBook *selfAddressBook = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		@synchronized(selfAddressBook){
			NSMutableArray *tempArray = [NSMutableArray array];
			NSArray *allPerson = [[NSArray alloc] initWithArray:[selfAddressBook getAllPeopleContact]];
			NSInteger count = [allPerson count];
			for(int i = 0; i < count; i++){
				ABRecordRef person = (__bridge ABRecordRef)[allPerson objectAtIndex:i];
				ContacterEntity *entity = [ContacterEntity contacterEntityWithABPerson:person];
				if(ABPersonHasImageData(person)){
					NSData *imgDate = (__bridge NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
					UIImage *icon = [UIImage imageWithData:imgDate scale:1/4];
					[entity setIcon:icon];
				}
				
				if(entity){
					[tempArray addObject:entity];
				}
			}
			[contactList removeAllObjects];
			[contactList addObjectsFromArray:tempArray];
			[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_AddressBookHasChanged object:nil userInfo:nil];
			if([[ServiceMonitor sharedServiceMonitor] hasLogin]){
				[selfAddressBook uploadSysContacters:tempArray];
			}
		}
    });
}

- (void)uploadSysContacters:(NSArray*)contacters{
    for(ContacterEntity *entity in contacters){
		if (!entity.bUpdated){
			if ([entity uploadSysContacter]){
				[entity setBUpdated:YES];
			}
		}
    }
}

- (void)uploadSysContacters{
    if([_contactList count] == 0){
        [self loadContact];
    }else{
        [self uploadSysContacters:_contactList];
    }
}

- (NSArray*)getAllPeopleContact{
    ABAddressBookRef addressBook = [self addressBook];
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if(accessGranted){
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,CFArrayGetCount(people),people);
        
        CFArraySortValues(peopleMutable,CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*)ABPersonGetSortOrdering);
        
        NSMutableArray  *newArray = [[NSMutableArray alloc] initWithArray:(__bridge NSMutableArray*)peopleMutable];
        CFRelease(people);
        CFRelease(peopleMutable);
        return newArray;
    }else{
        KFLog_Normal(YES, @"没有权限访问通讯录");
        return nil;
    }
}

- (ContacterEntity*)contacterEntityForRecordID:(NSInteger)recordID{
    for(ContacterEntity *entity in _contactList){
        if(entity.recordID == recordID){
            return entity;
        }
    }
    return nil;
}

- (ContacterEntity*)contacterEntityForNumber:(NSString*)phone{
    for(ContacterEntity *entity in _contactList){
        NSArray *phoneNumbers = entity.phoneNumbers;
        for(NSString *phoneNumber in phoneNumbers){
            if([phoneNumber isEqualToString:phone]){
                return entity;
            }
        }
    }
    return nil;
}

@end
