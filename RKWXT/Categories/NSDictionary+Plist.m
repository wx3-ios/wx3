//
//  NSDictionary+Plist.m
//  GjtCall
//  解决NSDictionary中含有null时  writeToFile 失败的问题
//  Created by jjyo.kwan on 14-6-22.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "NSDictionary+Plist.h"

@implementation NSDictionary (Plist)

- (BOOL)writeToPlistFile:(NSString *)path
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [data writeToFile:path atomically:YES];
}

+ (NSDictionary *)dictionaryWithContentsOfPlistFile:(NSString *)path
{
    NSData * data = [NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
