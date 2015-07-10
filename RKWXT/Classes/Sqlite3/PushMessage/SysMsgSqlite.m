//
//  SysMsgSqlite.m
//  Woxin2.0
//
//  Created by le ting on 8/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgSqlite.h"
#import "SysMessageDef.h"
#import "SqliteDef.h"
#import "WXSqliteItem.h"
#import "WXSqlite.h"
#import "SysMsgItem.h"

typedef enum {
    E_SystemMessage_PrimaryKey = 0,//key
    E_SystemMessage_ID = 1,//消息ID
    E_SystemMessage_MsgType,//消息类型
    E_SystemMessage_SubShopID,//分店ID
    E_SystemMessage_SubShopName,//分店名称
    E_SystemMessage_SendTime,//消息发送时间
    E_SystemMessage_RecTime,//消息接收时间
    E_SystemMessage_PushTitle,//推送的Title
    E_SystemMessage_MsgTitle,//消息的title
    E_SystemMessage_Abstract,//消息摘要
    E_SystemMessage_ImageURL,//图片的URL
    E_SystemMessage_MessageURL,//消息的URL
    
    E_SystemMessage_Invalid,
}E_SystemMessage;

const static S_WXSqliteItem sysMsgItemArray [E_SystemMessage_Invalid] = {
    {kPrimaryKey,E_SQLITE_DATA_INT,1},
    {kSysMessageUID,E_SQLITE_DATA_INT,0},
    {kSysMessageType,E_SQLITE_DATA_INT,0},
    {kSysMessageSendTime,E_SQLITE_DATA_INT,0},
    {kSysMessageRecTime,E_SQLITE_DATA_INT,0},
    {kSysMessagePushTitle,E_SQLITE_DATA_TXT,0},
    {kSysMessageTitle,E_SQLITE_DATA_TXT,0},
    {kSysMessageAbstract,E_SQLITE_DATA_TXT,0},
    {kSysMessageImageURL,E_SQLITE_DATA_TXT,0},
    {kSysMessageURL,E_SQLITE_DATA_TXT,0},
};

#define kSystemMessageDB @"kSystemMessageDB"
@implementation SysMsgSqlite

+ (SysMsgSqlite*)sharedSystemMessageSqlite{
    static dispatch_once_t onceToken;
    static SysMsgSqlite *sharedSqlite;
    dispatch_once(&onceToken, ^{
        sharedSqlite = [[SysMsgSqlite alloc] init];
        if([sharedSqlite createSysMsgTable]){
            KFLog_Normal(YES, @"创建推送表单成功");
        }else{
            KFLog_Normal(YES, @"创建推送表单失败");
        }
    });
    return sharedSqlite;
}

- (NSString*)currentSysMessageSqlName{
    return kSystemMessageDB;
}

//获取初始化的sqliteItem
- (WXSqliteItem*)sysMsgSqlFor:(E_SystemMessage)colIndex{
    S_WXSqliteItem sItem = sysMsgItemArray[colIndex];
    WXSqliteItem *item = [WXSqliteItem itemWithSqliteItemStruct:sItem];
    return item;
}

- (NSArray *)sysMsgSqlItemArray{
    NSMutableArray *itemArray = [NSMutableArray array];
    for(E_SystemMessage eItem = E_SystemMessage_ID; eItem < E_SystemMessage_Invalid; eItem++){
        WXSqliteItem *item = [self sysMsgSqlFor:eItem];
        [itemArray addObject:item];
    }
    return itemArray;
}

- (BOOL)createSysMsgTable{
    NSArray *itemArray = [self sysMsgSqlItemArray];
    return [[WXSqlite sharedSqlite] createSqliteTable:[self currentSysMessageSqlName] itemArray:itemArray];
}

- (WXSqliteItem*)sqliteItemWithInteger:(NSInteger)number sysMsgItemIndex:(E_SystemMessage)index{
    WXSqliteItem *sqlItem = [self sysMsgSqlFor:index];
    sqlItem.data = [NSNumber numberWithInt:(int)number];
    return sqlItem;
}

- (WXSqliteItem*)sqliteItemWithTxt:(NSString*)txt sysMsgItemIndex:(E_SystemMessage)index{
    WXSqliteItem *sqlItem = [self sysMsgSqlFor:index];
    if(!txt){
        txt = @"";
    }
    sqlItem.data = txt;
    return sqlItem;
}

- (NSArray*)sqliteArrayWithMsgID:(NSInteger)msgID msgType:(NSInteger)msgType shopID:(NSInteger)shopID shopName:(NSString*)shopName
                        sendTime:(NSInteger)sendTime recTime:(NSInteger)recTime pushTitle:(NSString*)pushTitle msgTitle:(NSString*)msgTitle abstract:(NSString*)abstract imageURL:(NSString*)imageURL messageURL:(NSString*)messageURL{
    NSMutableArray *itemArray = [NSMutableArray array];
    WXSqliteItem *item = [self sqliteItemWithInteger:msgID sysMsgItemIndex:E_SystemMessage_ID];
    [itemArray addObject:item];
    item = [self sqliteItemWithInteger:msgType sysMsgItemIndex:E_SystemMessage_MsgType];
    [itemArray addObject:item];
    item = [self sqliteItemWithInteger:shopID sysMsgItemIndex:E_SystemMessage_SubShopID];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:shopName sysMsgItemIndex:E_SystemMessage_SubShopName];
    [itemArray addObject:item];
    item = [self sqliteItemWithInteger:sendTime sysMsgItemIndex:E_SystemMessage_SendTime];
    [itemArray addObject:item];
    item = [self sqliteItemWithInteger:recTime sysMsgItemIndex:E_SystemMessage_RecTime];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:pushTitle sysMsgItemIndex:E_SystemMessage_PushTitle];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:msgTitle sysMsgItemIndex:E_SystemMessage_MsgTitle];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:abstract sysMsgItemIndex:E_SystemMessage_Abstract];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:imageURL sysMsgItemIndex:E_SystemMessage_ImageURL];
    [itemArray addObject:item];
    item = [self sqliteItemWithTxt:messageURL sysMsgItemIndex:E_SystemMessage_MessageURL];
    [itemArray addObject:item];
    return itemArray;
}

- (NSArray*)sqliteItemFromSysMsgItem:(SysMsgItem*)sysMsgItem{
    NSArray *itemArray = [self sqliteArrayWithMsgID:sysMsgItem.msgID msgType:sysMsgItem.msgType shopID:sysMsgItem.subShopID shopName:sysMsgItem.subShopName sendTime:sysMsgItem.sendTime recTime:sysMsgItem.recTime pushTitle:sysMsgItem.pushTitle msgTitle:sysMsgItem.msgTitle abstract:sysMsgItem.abstract imageURL:sysMsgItem.imageURL messageURL:sysMsgItem.messageURL];
    return itemArray;
}

- (NSInteger)insertSysMsgItem:(SysMsgItem*)menuItem{
    if(!menuItem){
        return -1;
    }
    NSArray *itemArray = [self sqliteItemFromSysMsgItem:menuItem];
    return [[WXSqlite sharedSqlite] insertTable:[self currentSysMessageSqlName] itemDataArray:itemArray];
}

- (void)insertSysMsgItemArray:(NSArray*)menuItemList{
    for(SysMsgItem *item in menuItemList){
        NSInteger index = [self insertSysMsgItem:item];
        if(index < 0){
            KFLog_Normal(YES, @"插入数据失败");
        }
        [item setPrimaryID:index];
    }
}

- (BOOL)updateSysMsgItem:(SysMsgItem*)sysMsgItem{
    NSArray *itemArray = [self sqliteItemFromSysMsgItem:sysMsgItem];
    WXSqliteItem *item = [self sysMsgSqlFor:E_SystemMessage_PrimaryKey];
    item.data = [NSNumber numberWithInteger:sysMsgItem.primaryID];
    return [[WXSqlite sharedSqlite] updateData:[self currentSysMessageSqlName] primaryItem:item itemArray:itemArray];
}

- (BOOL)saveMenuItem:(SysMsgItem*)sysMsgItem{
    if(sysMsgItem.primaryID >= 0){
        return [self updateSysMsgItem:sysMsgItem];
    }else{
        return [self insertSysMsgItem:sysMsgItem];
    }
}

- (BOOL)deleteSysMsgArray:(NSInteger*)UIDArray rowNumber:(NSInteger)number{
    return [[WXSqlite sharedSqlite] deleteTableName:[self currentSysMessageSqlName] PrimaryIDArray:UIDArray rowNumber:number];
}

- (NSArray*)loadAllSysMessageData{
    NSArray *itemArray = [self sysMsgSqlItemArray];
    NSArray * dataArray = [[WXSqlite sharedSqlite] loadData:[self currentSysMessageSqlName] itemArray:itemArray];
    NSMutableArray *mutArray = [NSMutableArray array];
    for(NSDictionary*dic in dataArray){
        SysMsgItem *item = [SysMsgItem sysMsgItemWithSqlDic:dic];
        if(item){
            [mutArray addObject:item];
        }
    }
    return mutArray;
}
@end
