//
//  ContactData.h
//  BoBoCall
//
//  Created by jjyo.kwan on 13-6-15.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneData.h"

@interface ContactData : NSObject

@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *phoneArray;
@property (nonatomic, strong) NSString *alpha;//首字母
@property (nonatomic, strong) NSString *namePY;//名称拼音缩写
@property (nonatomic, strong) NSString *namePinYin;//名称拼音
@property (nonatomic, strong) NSString *indexs;

@property (assign) NSRange rangeName;
@property (assign) NSRange rangeNamePY;
@property (assign) NSRange rangeNamePinYin;

//属性
@property (nonatomic, strong) NSMutableDictionary *attribute;

@property (nonatomic, assign, getter = isEnglish) BOOL english;

//默认显示号码
@property (assign, nonatomic) PhoneData *defaultPhoneData;
@property (assign, nonatomic) PhoneData *searchPhoneData;


- (NSComparisonResult)compareName:(ContactData *)contact;

- (NSComparisonResult)compareRange:(ContactData *)contact;

- (PhoneData *)phoneDataFromPhone:(NSString *)phone;



- (BOOL)compareKeywords:(NSString *)searchText;

- (BOOL)matchKeywords:(NSString *)regexText;

@end
