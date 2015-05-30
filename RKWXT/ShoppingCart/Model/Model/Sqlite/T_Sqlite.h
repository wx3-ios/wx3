//
//  T_Sqlite.h
//  Woxin3.0
//
//  Created by SHB on 15/1/28.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "T_MenuEntity.h"

#define DBNAME        @"tmenu.sqlite"
#define GoodsNumber   @"STOREGOODSNUM"
#define GoodsID       @"STOREGOODSID"
#define ColorText     @"STOREGOODSCOLOR"

@interface T_Sqlite : NSObject{
    sqlite3 *db;
    NSMutableArray *all;
}
@property (retain,nonatomic) NSMutableArray *all;

-(void)createOrOpendb;
-(void)createTable;
-(BOOL)execSql:(NSString *)sql;
-(BOOL)deleteTestList:(T_MenuEntity *)deletList;
-(NSMutableArray *)selectAll;

@end
