//
//  ClassifySql.h
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBNAME        @"Classify.sqlite"
#define RecordName    @"RecordName"
#define RecordTime    @"RecordTime"
#define Other         @"Other"

@interface ClassifySql : NSObject{
    sqlite3 *db;
    NSMutableArray *all;
}
@property (retain,nonatomic) NSMutableArray *all;

-(void)createOrOpendb;
-(void)createTable;
-(BOOL)execSql:(NSString *)sql;
-(BOOL)deleteClassifyHistoryList:(NSString*)recordName;
-(BOOL)deleteAll;
-(NSMutableArray *)selectAll;

@end