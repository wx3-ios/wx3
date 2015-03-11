//
//  PhoneData.m
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-14.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import "PhoneData.h"
#import "NSString+Helper.h"

@interface PhoneData()

//自动分段号码
@property (nonatomic, strong) NSString *splitNumber;

@end

@implementation PhoneData

+ (id)dataWithPhone:(NSString *)phone
{
    PhoneData *data = [[PhoneData alloc]init];
    data.phone = phone;
    
    if ([phone isMobileNumber])
    {
        data.type = TYPE_MOBILE;
    }
    else if([phone isTelephoneNumber])
    {
        data.type = TYPE_TELEPHONE;
    }
    
    return data;
}


- (void)setPhone:(NSString *)phone
{
    if (_phone == phone) {
        return;
    }
    _phone = phone;
    self.splitNumber = nil;
}


- (NSString *)displayNumber
{
    if (_splitNumber) {
        return _splitNumber;
    }
    
    if (_type == TYPE_MOBILE)
    {
        self.splitNumber = [NSString stringWithFormat:@"%@ %@ %@", [_phone substringToIndex:3], [_phone substringWithRange:NSMakeRange(3, 4)], [_phone substringFromIndex:7]];
    }
    else if (_type == TYPE_TELEPHONE)
    {
        int index = ([_phone characterAtIndex:1] <= '2') ? 3 : 4;
        self.splitNumber = [NSString stringWithFormat:@"%@ %@", [_phone substringToIndex:index], [_phone substringFromIndex:index]];
    }
    else
    {
        self.splitNumber = _phone;
    }
    
    return _splitNumber;
}

- (NSRange)displayRange
{
    if (_colorRange.length == 0) {
        return _colorRange;
    }
    NSRange range = NSMakeRange(0, 0);
    int start = _colorRange.location;
    int length = _colorRange.length;
    int end = start + length;
    if(_type == TYPE_MOBILE)
    {
        if(end > 7)end += 2;
        else if(end > 3) end += 1;
        if(start > 7) start += 2;
        else if(start > 3) start += 1;
        
    }
    else if(_type == TYPE_TELEPHONE)
    {
        int idx = ([_phone characterAtIndex:1] <= '2') ? 3 : 4;
        if(start >= idx) start += 1;
        if(end >= idx) end += 1;
    }
    range.location = start;
    range.length = end - start;
    return range;
}

@end
