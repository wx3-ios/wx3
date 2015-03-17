//
//  WXLibDB.h
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXLibDB : NSObject

+ (WXLibDB*)sharedWXLibDB;
//加载lib数据
- (void)loadLibDB;
//清空lib数据
- (void)removeLibDB;
//切换分店ID
- (void)changeSubShop;
@end