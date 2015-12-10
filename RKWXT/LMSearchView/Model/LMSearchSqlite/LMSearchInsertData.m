//
//  LMSearchInsertData.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchInsertData.h"
#import "LMSearchHistoryEntity.h"
#import "LMSearchHistorySql.h"

@implementation LMSearchInsertData{
    LMSearchHistorySql *fmdb;
}

-(BOOL)insertData:(NSString *)recordName withRecordID:(NSString *)recordID with:(NSString *)other{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@' , '%@') VALUES ('%@' , '%@' , '%@' , '%@')",@"LMSEARCHHISTORY",RecordName,RecordTime,RecordID,Other,recordName,[self insertSearchHistoryTime],recordID,other];
    fmdb = [[LMSearchHistorySql alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb execSql:sql];
    return succeed;
}

-(NSString*)insertSearchHistoryTime{
    NSInteger nowTime = [UtilTool timeChange];
    return [NSString stringWithFormat:@"%ld",(long)nowTime];
}

@end