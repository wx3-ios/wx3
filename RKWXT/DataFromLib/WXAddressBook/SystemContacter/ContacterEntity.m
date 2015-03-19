//
//  ContacterEntity.m
//  CallTesting
//
//  Created by le ting on 5/19/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "ContacterEntity.h"
#import "TelNOOBJ.h"
#import "WXService.h"
#import "PinYinSearchOBJ.h"

@implementation ContacterEntity

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

- (void)dealloc{
//    [super dealloc];
}

+ (id)contacterEntityWithABPerson:(ABRecordRef)person{
    return [[self alloc] initWithPerson:person] ;
}

- (id)initWithPerson:(ABRecordRef)person{
    if(self = [super init]){
        //读取联系人号码: 过滤掉没有号码的~
        NSArray *phoneNumbers = [self phoneNumbersFrom:person];
        if(phoneNumbers && [phoneNumbers count] > 0){
            //号码
            self.phoneNumbers = phoneNumbers;
            //姓名
            NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
            if(!name){
                name = [_phoneNumbers objectAtIndex:0];
            }
            [self setName:name];
            //record ID
            ABRecordID recordID = ABRecordGetRecordID(person);
            [self setRecordID:recordID];
            //创建时间
            NSDate *createDate = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
            [self setCreateTime:createDate];
            //修改时间
            [self setModifyTime:(__bridge NSDate*)ABRecordCopyValue(person, kABPersonModificationDateProperty)];
        }else{
            return nil;
        }
    }
    return self;
}

- (NSArray*)phoneNumbersFrom:(ABRecordRef)person{
    ABMutableMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSInteger phoneCount = ABMultiValueGetCount(phoneNumbers);
    NSMutableArray *phoneNumberArray = [NSMutableArray array];
    //如果没有联系人就返回空~
    if(phoneCount > 0){
        for(int i = 0; i < phoneCount; i++){
            NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSString *nakePhone = [self nakedPhone:phone];
            if(nakePhone){
                NSString *phoneWithCountryCode  = [[TelNOOBJ sharedTelNOOBJ] addCountryCode:@"+86" toTelNumber:nakePhone];
                [phoneNumberArray addObject:phoneWithCountryCode];
            }
        }
    }
    CFRelease(phoneNumbers);
    if([phoneNumberArray count] == 0){
        phoneNumberArray = nil;
    }
    return phoneNumberArray;
}


- (NSString*)removeIPPreFromPhoneNumber:(NSString*)phone{
    NSInteger ipPreCount = sizeof(s_ipPre)/sizeof(const char*);
    NSInteger len = [phone length];
    NSString *newPhone = phone;
    if(len > kPhoneNumberCount){
        for(NSInteger i = 0; i < ipPreCount; i++){
            const char *aIPPre = s_ipPre[i];
            NSString *ipPreStr = [NSString stringWithFormat:@"%s",aIPPre];
            if([newPhone hasPrefix:ipPreStr]){
                NSInteger ipPreLen = [ipPreStr length];
                newPhone = [newPhone substringWithRange:NSMakeRange(ipPreLen, len-ipPreLen)];
                break;
            }
        }
    }
    return newPhone;
}

- (NSString*)nakedPhone:(NSString*)phone{
    NSMutableString *nakePhone = [NSMutableString string];
    NSInteger len = [phone length];
    NSInteger index = 0;
    if(len > 0){
        //首字母
        const char head = (const char)[phone characterAtIndex:0];
        if(head == '+'){
            index ++;
            [nakePhone appendFormat:@"%c",head];
        }
        
        while (index < len) {
            const char character = (const char)[phone characterAtIndex:index];
            if(character >= '0' && character <= '9'){
                [nakePhone appendFormat:@"%c",character];
            }
            index ++;
        }
    }
    NSString *newPhone = [self removeIPPreFromPhoneNumber:nakePhone];
    if(newPhone && [newPhone length] > 0){
        return newPhone;
    }
    return nil;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"CLASS=%@,recordID=%d,name=%@,phone=%@,createTime=%@,modifyTime=%@,phone=%@",[self class],
            (int)_recordID,_name,_phoneNumbers,_createTime,_modifyTime,_phoneNumbers];
}


#pragma mark UI

- (NSArray*)matchWXContacter{
    NSMutableArray *mutArray = [NSMutableArray array];
    for(NSString *phone in _phoneNumbers){
        WXContacterEntity *wxContacter = [[WXContactMonitor sharedWXContactMonitor] entityForPhonNumber:phone];
        if(wxContacter){
            [mutArray addObject:wxContacter];
        }
    }
    return mutArray;
}

- (NSString*)nameShow{
    NSString *name = self.name;
    if(!name){
        name = [_phoneNumbers objectAtIndex:0];
    }
    
    NSArray *mutWXList = [self matchWXContacter];
    for(WXContacterEntity *entity in mutWXList){
        NSString *nickName = entity.nickName;
        if(nickName && nickName.length > 0){
            name = nickName;
            break;
        }
    }
    
    return name;
}

- (UIImage*)iconShow{
    UIImage *icon = _icon;
    NSArray *mutWXList = [self matchWXContacter];
    for(WXContacterEntity *entity in mutWXList){
        NSString *iconPath = entity.iconPath;
        if(iconPath && [iconPath length] > 0){
            UIImage *nickIcon = [UIImage imageWithContentsOfFile:iconPath];
            if(nickIcon){
                icon = nickIcon;
                break;
            }
        }
    }
    return icon;
}

//- (E_ContactRightView)rightViewType{
//    E_ContactRightView rightView = E_ContactRightView_None;
//    if([[self matchWXContacter] count] > 0){
//        rightView = E_ContactRightView_ShowWXIcon;
//    }
//    return rightView;
//}

- (BOOL)matchingString:(NSString *)string{
    if(!string || [string length] == 0){
        return NO;
    }
    
    if(_name && [PinYinSearchOBJ isIncludeString:string inString:_name]){
        return YES;
    }
    
    for(NSString *phoneNumber in _phoneNumbers){
        if([PinYinSearchOBJ isIncludeString:string inString:phoneNumber]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)uploadSysContacter{
    for(NSString *phone in _phoneNumbers){
        
        NSInteger ret = [[WXService sharedService] updateContacter:_recordID name:_name phone:phone createTime:[_createTime timeIntervalSince1970] modifyTime:[_modifyTime timeIntervalSince1970]];
        if(ret != 0){
            KFLog_Normal(YES, @"上传通讯录失败~ret=%d",(int)ret);
            return NO;
        }
    }
    return YES;
}

@end
