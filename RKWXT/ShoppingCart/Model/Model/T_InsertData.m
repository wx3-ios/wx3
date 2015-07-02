//
//  T_InsertData.m
//  Woxin3.0
//
//  Created by SHB on 15/1/28.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_InsertData.h"
#import "T_MenuEntity.h"
#import "T_Sqlite.h"

@implementation T_InsertData{
    T_Sqlite *fmdb;
}

-(BOOL)insertData:(NSString *)imgUrl withGoodsID:(NSString *)goodsID withColorType:(NSString *)colorText{
//    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@') VALUES ('%@' , '%@' , '%@')",@"NEWMENUSTORE",GoodsNumber,GoodsID,ColorText,imgUrl,goodsID,colorText];
//    
//    fmdb = [[T_Sqlite alloc] init];
//    [fmdb createOrOpendb];
//    [fmdb createTable];
//    BOOL succeed = [fmdb execSql:sql1];
//    return succeed;
    return YES;
}

@end
