//
//  LMSearchHistorySql.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBNAME        @"LMSearchHistory.sqlite"
#define RecordName    @"RecordName"
#define RecordTime    @"RecordTime"
#define RecordID      @"RecordID"
#define Other         @"Other"

@interface LMSearchHistorySql : NSObject{
    sqlite3 *db;
    NSMutableArray *all;
}
@property (retain,nonatomic) NSMutableArray *all;

-(void)createOrOpendb;
-(void)createTable;
-(BOOL)execSql:(NSString *)sql;
-(BOOL)deleteLMSearchHistoryList:(NSString*)recordName;
-(BOOL)deleteAll;
-(NSMutableArray *)selectAll;

@end
