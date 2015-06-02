//
//  InsertAddress.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "InsertAddress.h"
#import "AddSqlite.h"

@implementation InsertAddress{
    AddSqlite *fmdb;
}

-(BOOL)insertData:(NSString *)name withUserPhone:(NSString *)userPhone withAddress:(NSString *)address withAddStatus:(NSString *)bSel{
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@' , '%@') VALUES ('%@' , '%@' , '%@' , '%@')",@"NEWADDRESSLIST",Address_UserName,Address_UserPhone,Address_Add,Address_BSel,name,userPhone,address,bSel];
    
    fmdb = [[AddSqlite alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb execSql:sql1];
    return succeed;
}

@end
