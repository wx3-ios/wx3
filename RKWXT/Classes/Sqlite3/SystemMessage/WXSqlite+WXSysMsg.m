//
//  WXSqlite+WXSysMsg.m
//  SQLite
//
//  Created by le ting on 5/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXSqliteItem.h"
#import "WXSqlite.h"
#import "SystemMessageDefine.h"

#define kWXSystemMessageTableName @"WXSystemMessageTable"

typedef enum{
    E_SysMsgItem_UID = 0,
    E_SysMsgItem_PushType,
    E_SysMsgItem_MsgType,
    E_SYSTEM_MSG_MSGID,
    E_SYSTEM_MSG_DidReady,
    E_SysMsgItem_Title,
    E_SysMsgItem_Content,
    E_SysMsgItem_ImageURL,
    E_SysMsgItem_MsgURL,
    E_SysMsgItem_SendTime,
    E_SysMsgItem_RecTime,
    E_SysMsgItem_Read,
    E_SysMsgItem_BusinessID,
    
    E_SysMsgItem_ReservedTxt0,
    E_SysMsgItem_ReservedTxt1,
    E_SysMsgItem_ReservedInt0,
    E_SysMsgItem_ReservedInt1,
    
    E_SysMsgItem_Invalid,
    
}E_SysMsgItem;

const static S_WXSqliteItem sqliteItemArray[E_SysMsgItem_Invalid] = {
    {kPrimaryKey,E_SQLITE_DATA_INT,1},
    {kMsgPushType,E_SQLITE_DATA_INT,0},
    {kMsgType,E_SQLITE_DATA_INT,0},
    {kMsgID,E_SQLITE_DATA_INT,0},
    {kMsgDidReady,E_SQLITE_DATA_INT,0},
    {kMsgTitle,E_SQLITE_DATA_TXT,0},
    {kMsgContent,E_SQLITE_DATA_TXT,0},
    {kMsgImageURL,E_SQLITE_DATA_TXT,0},
    {kMsgURL,E_SQLITE_DATA_TXT,0},
    {kMsgSendTime,E_SQLITE_DATA_INT,0},
    {kMsgRecTime,E_SQLITE_DATA_INT,0},
    {kMsgRead,E_SQLITE_DATA_INT,0},
    {kBusinessID,E_SQLITE_DATA_INT,0},
    //以下为预留字段
    {kReservedTxt_0,E_SQLITE_DATA_TXT,0},
    {kReservedTxt_1,E_SQLITE_DATA_TXT,0},
    {kReservedInt_0,E_SQLITE_DATA_INT,0},
    {kReservedInt_1,E_SQLITE_DATA_INT,0},
};

typedef enum {
    //纯文本
    E_SYSTEM_MSG_TXT = 0,
    //富文本
    E_SYSTEM_MSG_RICHTXT,
    
    E_SYSTEM_MSG_INVALID,
}E_SYSTEM_MSG_TYPE;

@implementation WXSqlite (WXSysMsg)

- (NSString*)systemMessageTableName{
    return kWXSystemMessageTableName;
}
//获取初始化的sqliteItem
- (WXSqliteItem*)sysMsgSqliteItemFor:(E_SysMsgItem)colIndex{
    S_WXSqliteItem sItem = sqliteItemArray[colIndex];
    WXSqliteItem *item = [WXSqliteItem itemWithSqliteItemStruct:sItem];
    return item;
}

- (NSArray *)sysMsgSqliteItemArray{
    NSMutableArray *itemArray = [NSMutableArray array];
    for(E_SysMsgItem eItem = E_SysMsgItem_UID; eItem < E_SysMsgItem_Invalid; eItem++){
        WXSqliteItem *item = [self sysMsgSqliteItemFor:eItem];
        [itemArray addObject:item];
    }
    return itemArray;
}

- (BOOL)createSystemMessageTable{
    NSArray *itemArray = [self sysMsgSqliteItemArray];
    return [self createSqliteTable:[self systemMessageTableName] itemArray:itemArray];
}

- (NSArray*)sqlItemArrayWithPushType:(NSInteger)pushType systemMessageType:(NSInteger)msgType msgID:(NSInteger)msgID
                          msgDidload:(BOOL)msgDidload title:(NSString*)title
                             content:(NSString*)content imageURL:(NSString*)imageURL
                              msgURL:(NSString*)msgURL sendTime:(NSInteger)sendTime
                             recTime:(NSInteger)recTime isRead:(NSInteger)isRead{
    NSMutableArray *itemArray = [NSMutableArray array];
    WXSqliteItem *item = [self sysMsgSqliteItemFor:E_SysMsgItem_PushType];
    item.data = [NSNumber numberWithInt:(int)pushType];
    [itemArray addObject:item];
    
    item = [self sysMsgSqliteItemFor:E_SysMsgItem_MsgType];
    item.data = [NSNumber numberWithInt:(int)msgType];
    [itemArray addObject:item];
    
    item = [self sysMsgSqliteItemFor:E_SYSTEM_MSG_MSGID];
    item.data = [NSNumber numberWithInt:(int)msgID];
    [itemArray addObject:item];
    
    item = [self sysMsgSqliteItemFor:E_SYSTEM_MSG_DidReady];
    item.data = [NSNumber numberWithInt:msgDidload];
    [itemArray addObject:item];
    
    if(title){
        item = [self sysMsgSqliteItemFor:E_SysMsgItem_Title];
        item.data = title;
        [itemArray addObject:item];
    }
    
    if(content){
        item = [self sysMsgSqliteItemFor:E_SysMsgItem_Content];
        item.data = content;
        [itemArray addObject:item];
    }
    
    if(imageURL){
        item = [self sysMsgSqliteItemFor:E_SysMsgItem_ImageURL];
        item.data = imageURL;
        [itemArray addObject:item];
    }
    
    if(msgURL){
        item = [self sysMsgSqliteItemFor:E_SysMsgItem_MsgURL];
        item.data = msgURL;
        [itemArray addObject:item];
    }
    
    item = [self sysMsgSqliteItemFor:E_SysMsgItem_SendTime];
    item.data = [NSNumber numberWithInt:(int)sendTime];
    [itemArray addObject:item];
    
    item = [self sysMsgSqliteItemFor:E_SysMsgItem_RecTime];
    item.data = [NSNumber numberWithInt:(int)recTime];
    [itemArray addObject:item];
    
    item = [self sysMsgSqliteItemFor:E_SysMsgItem_Read];
    item.data = [NSNumber numberWithInt:(int)isRead];
    [itemArray addObject:item];
    
    return itemArray;
}

- (BOOL)insertPushType:(NSInteger)pushType systemMessageType:(NSInteger)msgType msgID:(NSInteger)msgID
                     msgDidload:(BOOL)msgDidload title:(NSString*)title
                        content:(NSString*)content imageURL:(NSString*)imageURL
                         msgURL:(NSString*)msgURL sendTime:(NSInteger)sendTime
               recTime:(NSInteger)recTime isRead:(NSInteger)isRead{
    NSArray *itemArray = [self sqlItemArrayWithPushType:pushType systemMessageType:msgType msgID:msgID msgDidload:msgDidload title:title content:content imageURL:imageURL msgURL:msgURL sendTime:sendTime recTime:recTime isRead:isRead];
    return [self insertTable:[self systemMessageTableName] itemDataArray:itemArray];
}

- (BOOL)updatePushType:(NSInteger)pushType systemMessageType:(NSInteger)msgType
                 msgID:(NSInteger)msgID msgDidload:(BOOL)msgDidload
                 title:(NSString*)title content:(NSString*)content
              imageURL:(NSString*)imageURL msgURL:(NSString*)msgURL
              sendTime:(NSInteger)sendTime recTime:(NSInteger)recTime
                isRead:(NSInteger)isRead wherePrimaryID:(NSInteger)primaryID{
    NSArray *itemArray = [self sqlItemArrayWithPushType:pushType systemMessageType:msgType msgID:msgID msgDidload:msgDidload title:title content:content imageURL:imageURL msgURL:msgURL sendTime:sendTime recTime:recTime isRead:isRead];
    
    WXSqliteItem *item = [self sysMsgSqliteItemFor:E_SysMsgItem_UID];
    item.data = [NSNumber numberWithInt:(int)primaryID];
    
    return [self updateData:[self systemMessageTableName] primaryItem:item itemArray:itemArray];
}

- (NSArray*)loadAllSysMsgData{
    NSArray *itemArray = [self sysMsgSqliteItemArray];
    return [self loadData:[self systemMessageTableName] itemArray:itemArray];
}
@end
