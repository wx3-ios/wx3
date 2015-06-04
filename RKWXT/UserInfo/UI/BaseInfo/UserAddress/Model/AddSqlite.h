//
//  AddSqlite.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class AddressEntity;

#define DBNAME        @"address.sqlite"
#define Address_UserName   @"AddressUserName"
#define Address_UserPhone      @"AddressUserPhone"
#define Address_Add     @"AddressAdd"
#define Address_BSel   @"AddressBSel"

@interface AddSqlite : NSObject{
    sqlite3 *db;
    NSMutableArray *all;
}
@property (retain,nonatomic) NSMutableArray *all;

-(void)createOrOpendb;
-(void)createTable;
-(BOOL)execSql:(NSString *)sql;
-(BOOL)deleteTestList:(AddressEntity *)deletList;
-(BOOL)changeTestListWith:(NSString*)userName phone:(NSString*)userPhone address:(NSString*)addStr sel:(NSString*)bsel;
-(NSMutableArray *)selectAll;

@end
