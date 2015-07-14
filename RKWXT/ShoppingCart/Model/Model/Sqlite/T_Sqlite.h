//
//  T_Sqlite.h
//  Woxin3.0
//
//  Created by SHB on 15/1/28.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "JPushMsgEntity.h"

#define DBNAME        @"JPush.sqlite"
#define JPushContent  @"JPushContent"
#define JPushAbs      @"JPushAbs"
#define JPushImg      @"JPushImg"
#define JPushTime     @"JPushTime"
#define JPushID       @"JPushID"

@interface T_Sqlite : NSObject{
    sqlite3 *db;
    NSMutableArray *all;
}
@property (retain,nonatomic) NSMutableArray *all;

-(void)createOrOpendb;
-(void)createTable;
-(BOOL)execSql:(NSString *)sql;
-(BOOL)deleteTestList:(NSInteger)pushID;
-(NSMutableArray *)selectAll;

@end
