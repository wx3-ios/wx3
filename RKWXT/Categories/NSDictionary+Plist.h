//
//  NSDictionary+Plist.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-22.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Plist)

- (BOOL)writeToPlistFile:(NSString *)path;

+ (NSDictionary *)dictionaryWithContentsOfPlistFile:(NSString *)path;

@end
