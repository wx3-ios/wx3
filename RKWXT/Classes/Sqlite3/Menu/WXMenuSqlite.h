//
//  WXMenuSqlite.h
//  Woxin2.0
//
//  Created by le ting on 8/8/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface WXMenuSqlite : NSObject

+ (WXMenuSqlite*)sharedMenuSqlite;

- (NSInteger)insertMenuItem:(MenuItem*)menuItem;//增加
- (BOOL)saveMenuItem:(MenuItem*)menuItem;//保存
- (BOOL)updateMenuItem:(MenuItem*)menuItem;//改
- (BOOL)deleteMenuArray:(NSInteger*)UIDArray rowNumber:(NSInteger)number;//删除
- (NSArray*)loadAllMenu;//加载
@end