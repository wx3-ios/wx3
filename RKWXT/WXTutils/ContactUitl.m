//
//  ContactUitl.h
//  Okboo
//
//  Created by jjyo.kwan on 12-8-15.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import "ContactUitl.h"
#import "Tools.h"
#import "NSString+Helper.h" 
#import "ChineseToPinyin.h"


@implementation ContactUitl

- (id)init
{
    if(self = [super init])
    {
        //_contactArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

+ (NSString *)cleanTokenForNumber:(NSString *)number
{
    NSArray *tokens = @[@"+86", @"-", @"(", @")", @" ", @" "];
    NSString *result = number;
    for (NSString *token in tokens) {
        result = [result stringByReplacingOccurrencesOfString:token withString:@""];
    }
    if (result.length > 11) {
         result = [result stringByReplacingOccurrencesOfString:@"86" withString:@""];
    }
    return result;
}


+ (ContactUitl *)shareInstance
{
    static ContactUitl *instance = nil;
    if(!instance)
    {
        instance = [[ContactUitl alloc]init];
        //[instance loadAddressBook];
    }
    return instance;
}


+ (BOOL)isAuthorized
{
    if (sysVersion > 6.0f) {
        ABAuthorizationStatus ab = ABAddressBookGetAuthorizationStatus ();
        if (ab == kABAuthorizationStatusDenied) {
            return NO;
        }
    }
    return YES;
}


- (ContactData *)queryContactFromPhone:(NSString *)phone
{
    return [_contactDictionary objectForKey:phone];
}

- (NSString *)getFullNameByRecord:(ABRecordRef)record
{
    //以下的属性都是唯一的，即一个人只有一个FirstName，一个Organization。。。
    CFStringRef firstName = ABRecordCopyValue(record,kABPersonFirstNameProperty);
    CFStringRef lastName =  ABRecordCopyValue(record,kABPersonLastNameProperty);
    
    NSString *first = firstName == NULL ? @"" : (__bridge NSString *)firstName;
    NSString *last = lastName == NULL ? @"" : (__bridge NSString *)lastName;

    NSString *fullName = [NSString stringWithFormat:@"%@%@", last, first];
//    fullName = [fullName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    (firstName == NULL) ? : CFRelease(firstName);
    (lastName == NULL) ? : CFRelease(lastName);
    return fullName;
}

- (NSData *)getPersonPhotoData:(ABRecordRef)record
{
    if (ABPersonHasImageData(record)) {        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        CFDataRef data = version >= 4.1 ? ABPersonCopyImageDataWithFormat(record,kABPersonImageFormatThumbnail) : ABPersonCopyImageData(record);
        NSData *photoData = [[NSData alloc]initWithData:(__bridge NSData *)data];
        CFRelease(data);
        return photoData;
    }
    return nil;
}

- (UIImage *)getPersonPhoto:(ABRecordRef)record
{
    
    return nil;
}


- (NSArray *)getPhoneArray:(ABRecordRef)record
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    //有些属性不是唯一的，比如一个人有多个电话：手机，主电话，传真。。。
    //所有ABMutableMultiValueRef这样的引用的东西都是这样一个元组（id，label，value）
    ABMutableMultiValueRef multiPhone = ABRecordCopyValue(record, kABPersonPhoneProperty);
    for (CFIndex i = 0; i < ABMultiValueGetCount(multiPhone); i++) {
        //CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(multiPhone, i);
        CFStringRef numberRef = ABMultiValueCopyValueAtIndex(multiPhone, i);
        NSString *phone = (__bridge NSString *)numberRef;
        
        phone = [ContactUitl cleanTokenForNumber:phone];
        if ([phone isMobileNumber] || [phone isTelephoneNumber])
        {
            [array addObject:phone];
        }
        
        CFRelease(numberRef);
    }
    CFRelease(multiPhone);
    
    return array;
}



- (void)loadAddressBook
{
    
    if (_isLoad) {
        return;
    }
    
    _isLoad = YES;
    
    NSLog(@"loadLocalAddressBook");
    //Pinyin *pinyin = [[Pinyin alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    //添加自定义联系人
    //[self addCustomContact:array];
    //get all people info from the address book
    
    ABAddressBookRef addressBook;
    
    if(sysVersion > 6.0f)
    {
        
        CFErrorRef myError = NULL;
        addressBook = ABAddressBookCreateWithOptions(NULL, &myError);
        if (myError != NULL) {
            //NSLog(@"ABAddressBook error = %@", myError);
            return;
        }
        
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
    }
    else{
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    
    if (addressBook == NULL) {
        return;
    }
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);//这是个数组的引用
    for(int i = 0; i < CFArrayGetCount(people); i++){
        
        //parse each person of addressbook
        ABRecordRef record = CFArrayGetValueAtIndex(people, i);//取出一条记录
        
        [self addContact:record toArray:array];
    }
    CFRelease(people);
    CFRelease(addressBook);
    
    _contactArray = [array sortedArrayUsingSelector:@selector(compareName:)];


    /*
     设置联系人的字典。。方便查找
     */
    //[_contactDictionary removeAllObjects];
    _contactDictionary = [[NSMutableDictionary alloc]init];
    for (ContactData *contact in _contactArray) {
        for (PhoneData *data in contact.phoneArray) {
            [_contactDictionary setObject:contact forKey:data.phone];
        }
    }
//    DDLogDebug(@"loadAddressBook finish! contact count = %d", _contactArray.count);
    [NOTIFY_CENTER postNotificationName:NOTIFY_CONTACT_UPDATE object:nil];
}

- (BOOL)addContact:(ABRecordRef)record toArray:(NSMutableArray *)array
{
    //如果没有电话号码。。返回
    NSArray *phones = [self getPhoneArray:record];
    if (phones.count == 0) {
        return NO;
    }
    
    NSString *fullName = [self getFullNameByRecord:record];
    UIImage *photo ;//= [self getPersonPhoto:record];
    
    ABRecordID ROWID = ABRecordGetRecordID(record);
   
    
    NSMutableArray *phoneArray = [NSMutableArray array];
    for( NSString *phone in phones)
    {
        [phoneArray addObject:[PhoneData dataWithPhone:phone]];
    }
    
    ContactData *contact = [[ContactData alloc]init];
    contact.ROWID = ROWID;
    contact.name = fullName;
    contact.photo = photo;
    
    contact.phoneArray = phoneArray;
    contact.defaultPhoneData = phoneArray[0];
    [self fitIndexsForContact:contact];
    
    [array addObject:contact];
    
    return YES;
}

//建立拼音,首字母索引
- (void)fitIndexsForContact:(ContactData *)contact
{
    NSString *fullName = contact.name;
    //汉语转PY
    NSString *key = nil;
    NSMutableString *namePinYin = nil;
    NSMutableString *namePY = nil;
    if (fullName != nil && fullName.length > 0) {
        namePinYin = [[NSMutableString alloc]init];
        namePY = [[NSMutableString alloc]init];
        for (int i = 0 ; i < fullName.length; i++) {
            NSString *oneText = [fullName substringWithRange:NSMakeRange(i, 1)];
            NSString *py = [ChineseToPinyin pinyinFromChiniseString:oneText];
            
            if (py.length > 0) {
                py = [py capitalizedString];//返回每个单词首字母大写的字符串
            }
            else{
                py = CONTACT_ALPHA_POUND;
            }
            
            [namePinYin appendString:py];
            [namePY appendString:[py substringToIndex:1]];
            
            if (i == 0) {
                char c = [namePY characterAtIndex:0];
                
                key = (c > 'Z' || c < 'A') ? CONTACT_ALPHA_POUND : [[NSString alloc]initWithString:namePY];
            }
        }
    }
    else{
        key = CONTACT_ALPHA_POUND;
    }
    
    contact.alpha = key;
    contact.namePY = namePY;
    contact.namePinYin = namePinYin;
    if (fullName) {
        contact.english = [[fullName uppercaseString] isEqualToString:namePY];
    }
}


- (void)addContact:(ABRecordRef)record
{
//    DDLogDebug(@"addContact ----------->");
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_contactArray];
    if ([self addContact:record toArray:array])
    {
        _contactArray = [array sortedArrayUsingSelector:@selector(compareName:)];
        
        /*
         设置联系人的字典。。方便查找
         */
        //[_contactDictionary removeAllObjects];
        _contactDictionary = [[NSMutableDictionary alloc]init];
        for (ContactData *contact in _contactArray) {
            for (PhoneData *data in contact.phoneArray) {
                [_contactDictionary setObject:contact forKey:data.phone];
            }
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REFLASH_CONTACT object:nil];
        
    }
    
}


- (void)addCustomContact:(NSMutableArray *)array
{

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CustomContact" withExtension:@"plist"];
    NSArray *customs = [NSArray arrayWithContentsOfURL:url];
    for (NSDictionary *dict in customs) {
        ContactData *cd = [[ContactData alloc]init];
        
        cd.name = dict[@"name"];
        cd.indexs = dict[@"indexs"];
        cd.alpha = CONTACT_ALPHA_START;
        cd.namePinYin = dict[@"pinyin"];
        cd.namePY = dict[@"PY"];
        
        NSArray *phones = dict[@"phones"];
        NSMutableArray *phoneArray = [NSMutableArray array];
        for (NSString *phone in phones) {
            PhoneData *data = [PhoneData dataWithPhone:phone];
            [phoneArray addObject:data];
        }
        cd.phoneArray = phoneArray;
        cd.defaultPhoneData = phoneArray[0];
        
        [array addObject:cd];
        
        
        if (!_kefu && [cd.name rangeOfString:@"客服"].length > 0) {
            _kefu = cd;
        }
    }

}


- (NSArray *)allContacts
{
    if (_contactArray == nil) {
        [self loadAddressBook];
    }
    return _contactArray;
}




@end
