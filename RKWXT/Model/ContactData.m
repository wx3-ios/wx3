//
//  ContactData.m
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-15.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import "ContactData.h"
#import "RegexKitLite.h"
#import "NSString+Helper.h"

@implementation ContactData


- (NSComparisonResult)compareName:(ContactData *)contact
{
    return [self.name localizedStandardCompare:contact.name];
}

//按照搜索的范围排序
- (NSComparisonResult)compareRange:(ContactData *)contact
{
    
    if (_rangeNamePY.length > 0 || contact.rangeNamePY.length > 0)
    {
        
        return _rangeNamePY.length < contact.rangeNamePY.length;
    }
    else if(_rangeNamePinYin.length > 0 || contact.rangeNamePinYin.length > 0)
    {
        
        return _rangeNamePinYin.length < contact.rangeNamePinYin.length;
    }
    
    return [self.alpha localizedStandardCompare:contact.alpha];
}

- (PhoneData *)phoneDataFromPhone:(NSString *)phone
{
    for (PhoneData *data in _phoneArray) {
        if ([phone isEqualToString:data.phone]) {
            return data;
        }
    }
    return nil;
}




- (BOOL)compareKeywords:(NSString *)regexText
{
    if (regexText == nil || regexText.length == 0) {
        return NO;
    }
    
    self.searchPhoneData = self.defaultPhoneData;
    
    BOOL matchPone = NO;
    //number text
    for (PhoneData *data in _phoneArray)
    {
        NSRange range = [data.phone rangeOfRegex:regexText];
        data.colorRange = range;
        if (range.length > 0)
        {
            matchPone = YES;
            self.searchPhoneData = data;
            break;
        }
        
    }

    //只能开头开始匹配
    _rangeName = [_name rangeOfString:regexText];
    _rangeNamePinYin = [_namePinYin rangeOfString:[regexText capitalizedString]];
    _rangeNamePY = [_namePY rangeOfString:[regexText uppercaseString]];
    
    
    BOOL match = matchPone || _rangeName.length > 0 || _rangeNamePinYin.length > 0 || _rangeNamePY.length > 0;
    return match;
}


//keypad中使用
- (BOOL)matchKeywords:(NSString *)regexText
{
    
    //NSLog(@"========== %@ ==========", _name);
    self.searchPhoneData = self.defaultPhoneData;
    BOOL matchPone = NO;
    for (PhoneData *data in _phoneArray)
    {
        NSRange range = [data.phone rangeOfRegex:regexText];
        if (range.length > 0)
        {
            matchPone = YES;
            data.colorRange = range;
            self.searchPhoneData = data;
            break;
        }
        else{
            data.colorRange = NSMakeRange(0, 0);
        }
    }
    
    //只能开头开始匹配
    NSString *startRegex = [NSString stringWithFormat:@"^%@", regexText];
    _rangeName = [_name rangeOfRegex:startRegex];
    
    _rangeNamePY = [_namePY rangeOfRegex:startRegex];
    
    _rangeNamePinYin = [_namePinYin rangeOfRegex:startRegex];
    
    BOOL match = matchPone || _rangeName.length > 0 || _rangeNamePinYin.length > 0 || _rangeNamePY.length > 0;
    return match;
    
}



@end
