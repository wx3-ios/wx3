//
//  DBCommon.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_DBCommon_h
#define RKWXT_DBCommon_h

#define kWXTCallTable                       @"CREATE TABLE IF NOT EXISTS Call (ID INTEGER PRIMARY KEY AUTOINCREMENT, telephone TEXT, date TEXT, type INTEGER)"
#define kWXTInsertCallHistory               @"INSERT INTO Call(telephone,date,type) values(%@,%@,%@)"
#define kWXTQueryCallHistory                @"select * from call"

#endif
