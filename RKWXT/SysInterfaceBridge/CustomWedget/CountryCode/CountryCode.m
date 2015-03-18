//
//  ContryCode.m
//  TalkingFlower
//
//  Created by Elty on 13-12-7.
//  Copyright (c) 2013年 Elty. All rights reserved.
//
#import "CountryCode.h"
#import "TxtparseOBJ.h"

enum
{
    //英文描述
    E_ENDes = 0,
    //中文描述
    E_CNDes,
    //缩写
    E_Abbreviation,
    //国家码
    E_CountryCode,
    //时区
    E_TimeZone,
    
    E_CountryElement_Invalid,
};

@implementation CountryOBJ

- (void)dealloc{
//    [super dealloc];
}

- (BOOL)isAbbreviation:(NSString*)abbreviation{
    if(!abbreviation){
        return NO;
    }
    return [abbreviation isEqualToString:abbreviation];
}

- (NSString*)description{
    return [NSString stringWithFormat:@"cnDes = %@, enDes= %@, abbreviation= %@, countryCode = %@, timeZone=%.1f",_cnDes,_enDes,_abbreviation,_countryCode,_timeZone];
}

@end

@interface CountryCode()
{
    NSMutableArray *_countryOBJArray;
}
@end

@implementation CountryCode
@synthesize countryOBJList = _countryOBJArray;

- (void)dealloc{
//    [super dealloc];
}

+ (CountryCode*)sharedCountryCode{
    static dispatch_once_t onceToken;
    static CountryCode *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CountryCode alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        _countryOBJArray = [[NSMutableArray alloc] init];
        [self loadCountryOBJS];
    }
    return self;
}

- (void)loadCountryOBJS{
    [_countryOBJArray removeAllObjects];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryOBJ" ofType:nil];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray *countryDatas = [TxtparseOBJ parseDataFrom:string itemSeparator:@"\n" elementSeparator:@"\t"];
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (NSArray *countryOBJ in countryDatas) {
        if([countryOBJ count] != E_CountryElement_Invalid){
            continue;
        }
        NSString *enDes = [countryOBJ objectAtIndex:E_ENDes];
        NSString *CNDes = [countryOBJ objectAtIndex:E_CNDes];
        NSString *abbreviation = [countryOBJ objectAtIndex:E_Abbreviation];
        NSString *countryCode = [NSString stringWithFormat:@"+%@", [countryOBJ objectAtIndex:E_CountryCode]];
        NSString *timeZoneStr = [countryOBJ objectAtIndex:E_TimeZone];
        CGFloat timeZone = [timeZoneStr floatValue];
        
        CountryOBJ *obj = [[CountryOBJ alloc] init];
        obj.enDes = enDes;
        obj.cnDes = CNDes;
        obj.abbreviation = abbreviation;
        obj.countryCode = countryCode;
        obj.timeZone = timeZone;
        
        [_countryOBJArray addObject:obj];
    }
//    [pool drain];
}

- (NSInteger)indexOfCountryCode:(NSString*)countryCode{
    for(CountryOBJ *countryOBJ in _countryOBJArray){
        if([countryOBJ.countryCode isEqualToString:countryCode]){
            return [_countryOBJArray indexOfObject:countryOBJ];
        }
    }
    return NSNotFound;
}

- (NSInteger)indexCountryOBJOf:(NSString*)abbreviation{
    for(CountryOBJ *countryOBJ in _countryOBJArray){
        if([countryOBJ.abbreviation isEqualToString:abbreviation]){
            return [_countryOBJArray indexOfObject:countryOBJ];
        }
    }
    return NSNotFound;
}

- (NSString*)countryCodeOfAbbreviation:(NSString*)abbreviation{
    NSInteger index = [self indexCountryOBJOf:abbreviation];
    if(NSNotFound == index){
        return nil;
    }
    CountryOBJ *obj = [_countryOBJArray objectAtIndex:index];
    return obj.countryCode;
}

@end
