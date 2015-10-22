//
//  ClassifyInsertData.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyInsertData.h"
#import "ClassifySqlEntity.h"
#import "ClassifySql.h"

@implementation ClassifyInsertData{
    ClassifySql *fmdb;
}

-(BOOL)insertData:(NSString *)recordName with:(NSString *)other{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@') VALUES ('%@' , '%@' , '%@')",@"CLASSIFY",RecordName,RecordTime,Other,recordName,[self insertSearchHistoryTime],other];
    fmdb = [[ClassifySql alloc] init];
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