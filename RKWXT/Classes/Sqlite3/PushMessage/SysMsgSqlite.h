//
//  SysMsgSqlite.h
//  Woxin2.0
//
//  Created by le ting on 8/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SysMsgItem;
@interface SysMsgSqlite : NSObject

+ (SysMsgSqlite*)sharedSystemMessageSqlite;

- (BOOL)createSysMsgTable;//创建数据
- (NSArray*)loadAllSysMessageData;//加载数据
- (BOOL)deleteSysMsgArray:(NSInteger*)UIDArray rowNumber:(NSInteger)number;//删除数据
- (BOOL)updateSysMsgItem:(SysMsgItem*)sysMsgItem;//更新数据
- (NSInteger)insertSysMsgItem:(SysMsgItem*)menuItem;//插入数据
- (void)insertSysMsgItemArray:(NSArray*)menuItemList;//插入多组数据
@end
