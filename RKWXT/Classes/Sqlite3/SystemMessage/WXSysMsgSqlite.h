//
//  WXSysMsgSqlite.h
//  SQLite
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemMessageEntity.h"
#import "WXBaseSqlite.h"


@interface WXSysMsgSqlite : WXBaseSqlite

//加载所有的数据
- (NSArray*)loadAllSystemMessage;
//插入数据
- (NSInteger)insertSysMessage:(SystemMessageEntity*)entity;
//更新数据
- (BOOL)updateSysMessage:(SystemMessageEntity*)entity;
@end
