//
//  WXErrror.m
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXError.h"

@implementation WXError

- (void)dealloc{
//    [super dealloc];
}

+ (id)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage{
    WXError *error = [[WXError alloc] init] ;
    if(error){
        [error setErrorCode:code];
        [error setErrorMessage:errorMessage];
    }
    return error;
}

@end
