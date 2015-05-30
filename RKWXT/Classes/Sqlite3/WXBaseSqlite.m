//
//  WXBaseSqlite.m
//  CallTesting
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXBaseSqlite.h"

@implementation WXBaseSqlite

+ (id)shared{
    static dispatch_once_t onceToken;
    static WXBaseSqlite *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

+ (dispatch_queue_t)sharedSqliteDispatchQueue{
    static dispatch_once_t onceToken;
    static dispatch_queue_t dispatchQueue = nil;
    dispatch_once(&onceToken, ^{
        dispatchQueue = dispatch_queue_create("wx.sqlite.queue", NULL);
    });
    return dispatchQueue;
}

@end
