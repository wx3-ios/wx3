//
//  WXBaseSqlite.h
//  CallTesting
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

//所有sqlite实体的父类~
@interface WXBaseSqlite : NSObject

+ (id)shared;
+ (dispatch_queue_t)sharedSqliteDispatchQueue;
@end
