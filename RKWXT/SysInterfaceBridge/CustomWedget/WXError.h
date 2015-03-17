//
//  WXErrror.h
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXError : NSObject
@property (nonatomic,assign)NSInteger errorCode;
@property (nonatomic,retain)NSString *errorMessage;
@property (nonatomic,retain)id errorInfo;

+ (id)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage;
@end
