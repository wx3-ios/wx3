//
//  ZoneCodeOBJ.h
//  Woxin2.0
//
//  Created by Elty on 11/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	E_ZoneCodeMathCode_Complete = 0,//完全匹配
	E_ZoneCodeMathCode_Part,//部分匹配 只有区号匹配
	E_ZoneCodeMathCode_None,//都不匹配
}E_ZoneCodeMathCode;

@interface ZoneCodeOBJ : NSObject
@property (nonatomic,assign)NSArray *zoneCodeList;

+ (ZoneCodeOBJ*)sharedZoneCodeOBJ;
/*返回值~ 
 0：返回nil的时候没有对应的区号ID
 1：返回 ErrorID为E_ZoneCodeMathCode_Complete的时候完全匹配~
 2：返回 ErrorID为E_ZoneCodeMathCode_Part的时候 部分匹配~ 只是号码的长度不匹配~
 */
- (WXError*)checkValidForPhone:(NSString*)phone;
@end
