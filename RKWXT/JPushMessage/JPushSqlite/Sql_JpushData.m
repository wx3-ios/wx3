//
//  Sql_JpushData.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "Sql_JpushData.h"
#import "T_Sqlite.h"

@implementation Sql_JpushData{
    T_Sqlite *fmdb;
}

-(BOOL)insertData:(NSString *)content withAbs:(NSString *)abstract withImg:(NSString *)mesImg{
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@' , '%@') VALUES ('%@' , '%@' , '%@' , '%@')",@"JPUSHMESSAGE",JPushContent,JPushAbs,JPushImg,JPushTime,content,abstract,mesImg,[self jpushTime]];
    fmdb = [[T_Sqlite alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb execSql:sql1];
    return succeed;
}

-(NSString*)jpushTime{
    NSInteger time = [UtilTool timeChange];
    return [NSString stringWithFormat:@"%ld",(long)time];
}

@end
