//
//  TelNOOBJ.h
//  Woxin2.0
//
//  Created by le ting on 7/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TelNOOBJ : NSObject
+ (TelNOOBJ*)sharedTelNOOBJ;

//直接加国家码,不需要增加额外的东西
- (NSString*)addCountryCode:(NSString*)countryCode toTelNumber:(NSString*)telNumber;

//如果不带国家码参数的话 则就是默认为保存的国家码~ 目前为+86
- (NSString*)telNumberFromOrigin:(NSString*)phone;
//检测当前号码是否合法~
- (BOOL)checkPhoneValid:(NSString*)phone;
@end
