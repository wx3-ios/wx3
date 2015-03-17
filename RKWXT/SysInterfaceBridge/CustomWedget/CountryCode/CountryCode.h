//
//  ContryCode.h
//  TalkingFlower
//
//  Created by Elty on 13-12-7.
//  Copyright (c) 2013年 Elty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryOBJ : NSObject

@property (nonatomic,retain)NSString *cnDes;
@property (nonatomic,retain)NSString *enDes;
@property (nonatomic,retain)NSString *abbreviation;
@property (nonatomic,retain)NSString *countryCode;  //带'+'
@property (nonatomic,assign)CGFloat timeZone;
@end

@interface CountryCode : NSObject
@property (nonatomic,readonly)NSArray *countryOBJList;

+ (CountryCode*)sharedCountryCode;


- (NSInteger)indexOfCountryCode:(NSString*)countryCode;
- (NSString*)countryCodeOfAbbreviation:(NSString*)abbreviation;
@end