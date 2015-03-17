//
//  WXUserDefault.h
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXUserdefaultDefine.h"


@interface WXUserDefault : NSObject

+ (id)sharedWXUserDefault;

- (NSInteger)integerValueForKey:(NSString*)key;
- (BOOL)boolValueForKey:(NSString*)key;
- (NSString*)textValueForKey:(NSString*)key;
- (NSDictionary*)dicValueForKey:(NSString*)key;
- (CGFloat)floatValueForKey:(NSString*)key;

- (void)setInteger:(NSInteger)value forKey:(NSString*)key;
- (void)setBool:(BOOL)value forKey:(NSString*)key;
- (void)setFloat:(float)value forkey:(NSString*)key;
- (void)setObject:(id)object forKey:(NSString*)key;

- (void)removeObjectForKey:(NSString*)key;
- (NSArray*)allKeys;
- (BOOL)hasKey:(NSString*)key;
@end
