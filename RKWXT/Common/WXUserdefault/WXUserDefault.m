//
//  WXUserDefault.m
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUserDefault.h"

@implementation WXUserDefault

+ (id)sharedWXUserDefault{
    static dispatch_once_t predicate;
    static WXUserDefault *sharedUserDefault = nil;
    dispatch_once(&predicate, ^{
        sharedUserDefault = [[WXUserDefault alloc] init];
    });
    return sharedUserDefault;
}

- (NSInteger)integerValueForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:key];
}

- (BOOL)boolValueForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

- (NSString*)textValueForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key];
}


- (NSDictionary*)dicValueForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults dictionaryForKey:key];
}

- (CGFloat)floatValueForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
}
- (void)setBool:(BOOL)value forKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (void)setFloat:(float)value forkey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:value forKey:key];
    [userDefaults synchronize];
}

- (void)setObject:(id)object forKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}

- (void)removeObjectForKey:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

- (NSArray*)allKeys{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults dictionaryRepresentation] allKeys];
}

- (BOOL)hasKey:(NSString*)key{
    NSArray *allKeys = [self allKeys];
    NSInteger index = [allKeys indexOfObject:key];
    return index != NSNotFound;
}
@end
