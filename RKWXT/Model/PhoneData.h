//
//  PhoneData.h
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-14.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PhoneType
{
    TYPE_PHONE_NONE = 0,
    TYPE_MOBILE = 1,//手机号码
    TYPE_TELEPHONE = 2//固定电话
};

@interface PhoneData : NSObject


+ (id)dataWithPhone:(NSString *)phone;

//号码
@property (nonatomic, strong) NSString *phone;
//归属地
@property (nonatomic, strong) NSString *area;
//高亮
@property (assign) NSRange colorRange;

@property (assign) enum PhoneType type;

//显示的号码
- (NSString *)displayNumber;

- (NSRange)displayRange;

@end
