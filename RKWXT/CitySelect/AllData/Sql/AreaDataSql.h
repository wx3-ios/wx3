//
//  AreaDataSql.h
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBNAME        @"area.sqlite"
#define AREAID        @"AREAID"
#define AREANAME      @"AREANAME"
#define AREAPRESENT   @"AREAPRESENT"

#define Other1        @"Other1"
#define Other2        @"Other2"

@interface AreaDataSql : NSObject{
    sqlite3 *db;
    NSMutableArray *all;
}
@property (retain,nonatomic) NSMutableArray *all;

-(void)createOrOpendb;
-(void)createTable;
-(BOOL)execSql:(NSString *)sql;
-(BOOL)deleteAreaDataList:(NSString*)areaID;
-(BOOL)deleteAll;
-(NSMutableArray *)selectAll;

@end
