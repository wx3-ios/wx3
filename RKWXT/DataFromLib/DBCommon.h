//
//  DBCommon.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_DBCommon_h
#define RKWXT_DBCommon_h


#define kWXTCallTable                       @"CREATE TABLE IF NOT EXISTS Call (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,telephone TEXT, date TEXT, type INTEGER)"
#define kWXTCall_Column_Name                @"name"
#define kWXTCall_Column_Telephone           @"telephone"
#define kWXTCall_Column_Date                @"date"
#define kWXTCall_Column_Type                @"type"
#define kWXTInsertCallHistory               @"INSERT INTO Call(name,telephone,date,type) values('%@','%@','%@','%i')"
#define kWXTQueryCallHistory                @"SELECT * FROM Call ORDER BY date DESC LIMIT 0,50"
#define kWXTDelCallHistory                  @"delete from Call where telephone=%@"
#define kWXTPlacePath                       [NSString stringWithFormat:@"%@/place.sqlite",DOC_PATH]                
#define kWXTPlaceTable                      @"place"
#define kWXTInsertPlace                     @"INSERT INTO place (phone,area) VALUES (?,?)"
#define kWXTSelectCount                     @"SELECT count(*) FROM %@"
#endif
