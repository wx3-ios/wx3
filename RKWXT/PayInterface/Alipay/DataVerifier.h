//
//  DataVerifier.h
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataVerifier

- (NSString *)algorithmName;
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;

@end

id<DataVerifier> CreateRSADataVerifier(NSString *publicKey);
