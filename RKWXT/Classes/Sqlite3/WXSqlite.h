//
//  WXSqlite.h
//  SQLite
//
//  Created by le ting on 5/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SqliteDef.h"

@interface WXSqlite : NSObject
{
    sqlite3 *_dataBase;
}

+ (WXSqlite*)sharedSqlite;

//表是否存在
- (BOOL)existTable:(NSString*)tableName;
//删除表格
- (BOOL)removeTable:(NSString*)tableName;

#pragma mark 内部调用
//创建表格
- (BOOL)createSqliteTable:(NSString*)tableName itemArray:(NSArray*)itemArray;
//插入数据 插入单挑数据 返回插入的行
- (NSInteger)insertTable:(NSString*)tableName itemDataArray:(NSArray*)itemArray;
//加载数据
- (NSMutableArray*)loadData:(NSString*)tableName itemArray:(NSArray*)itemArray;
//更新数据
- (BOOL)updateData:(NSString*)tableName primaryItem:(id)primaryItem itemArray:(NSArray*)itemArray;
//删除数据 通用的~
- (BOOL)deleteData:(NSString*)tableName itemDataArray:(NSArray*)itemArray;
//删除row 以primary定位
- (BOOL)deleteTableName:(NSString*)tableName PrimaryIDArray:(NSInteger*)primaryArray rowNumber:(NSInteger)number;
@end


#pragma mark SystemMessage 系统推送消息
@interface WXSqlite (WXSysMsg)

//创建表格
- (BOOL)createSystemMessageTable;
//插入表
- (BOOL)insertPushType:(NSInteger)pushType systemMessageType:(NSInteger)msgType msgID:(NSInteger)msgID
            msgDidload:(BOOL)msgDidload title:(NSString*)title
               content:(NSString*)content imageURL:(NSString*)imageURL
                msgURL:(NSString*)msgURL sendTime:(NSInteger)sendTime
               recTime:(NSInteger)recTime isRead:(NSInteger)isRead;
//插入表
- (BOOL)updatePushType:(NSInteger)pushType systemMessageType:(NSInteger)msgType
                 msgID:(NSInteger)msgID msgDidload:(BOOL)msgDidload
                 title:(NSString*)title content:(NSString*)content
              imageURL:(NSString*)imageURL msgURL:(NSString*)msgURL
              sendTime:(NSInteger)sendTime recTime:(NSInteger)recTime
                isRead:(NSInteger)isRead wherePrimaryID:(NSInteger)primaryID;
//加载表
- (NSArray*)loadAllSysMsgData;
@end

//购物车
@interface WXSqlite (shopCart)

- (BOOL)createShopCartTable;
- (BOOL)insertGoodID:(NSInteger)goodID goodAttribute:(NSString*)attribute goodNumber:(NSInteger)goodNumber;
- (BOOL)updateGoodID:(NSInteger)goodID goodAttribute:(NSString*)attribute  goodNumber:(NSInteger)goodNumber
      wherePrimaryID:(NSInteger)primaryID;
//删除row 以primary定位
- (BOOL)deleteShopCartArray:(NSInteger*)primaryArray rowNumber:(NSInteger)number;
- (NSArray*)loadAllShopCartData;
@end
