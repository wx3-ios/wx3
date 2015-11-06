//
//  AreaInsertData.m
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AreaInsertData.h"
#import "AreaEntity.h"
#import "AreaDataSql.h"

@implementation AreaInsertData{
    AreaDataSql *fmdb;
}

-(BOOL)insertAreaData:(NSInteger)areaID withAreaName:(NSString *)areaName with:(NSInteger)areaPresent andOther1:(NSString *)other1 andOther2:(NSString *)other2{
    NSString *areaIDStr = [NSString stringWithFormat:@"%ld",(long)areaID];
    NSString *areaPresentIDStr = [NSString stringWithFormat:@"%ld",(long)areaPresent];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@' , '%@' , '%@') VALUES ('%@' , '%@' , '%@' , '%@' , '%@')",@"AREA",AREAID,AREANAME,AREAPRESENT,Other1,Other2,areaIDStr,areaName,areaPresentIDStr,other1,other2];
    fmdb = [[AreaDataSql alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb execSql:sql];
    return succeed;
}

@end
