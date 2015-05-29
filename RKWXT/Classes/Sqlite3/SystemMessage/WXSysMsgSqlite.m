//
//  WXSysMsgSqlite.m
//  SQLite
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXSysMsgSqlite.h"
#import "WXSqlite.h"
#import "SystemMessageDefine.h"

@implementation WXSysMsgSqlite

+ (id)shared{
    static dispatch_once_t onceToken;
    static WXSysMsgSqlite *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        [[WXSqlite sharedSqlite] createSystemMessageTable];
        sharedInstance = [[WXSysMsgSqlite alloc] init];
    });
    return sharedInstance;
}

- (NSArray*)systemMessageEntityFrom:(NSArray*)msgDicArray{
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dic in msgDicArray){
        SystemMessageEntity *entity = [[SystemMessageEntity alloc] init];
        NSNumber *idPrimaryKey = [dic objectForKey:kPrimaryKey];
        if(idPrimaryKey){
            entity.msgUID = [idPrimaryKey integerValue];
        }
        
        NSNumber *idPushType = [dic objectForKey:kMsgPushType];
        if(idPushType){
            entity.msgPushType = [idPushType integerValue];
        }
        
        NSNumber *idMsgType = [dic objectForKey:kMsgType];
        if(idMsgType){
            entity.msgType = (int)[idMsgType integerValue];
        }
        
        NSNumber *idMsgID = [dic objectForKey:kMsgID];
        if(idMsgID){
            entity.msgID = [idMsgID integerValue];
        }
        
        NSNumber *idMsgAlreadyReady = [dic objectForKey:kMsgDidReady];
        if(idMsgAlreadyReady){
            entity.msgDidReady = [idMsgAlreadyReady integerValue];
        }
        
        entity.title = [dic  objectForKey:kMsgTitle];
        entity.content = [dic objectForKey:kMsgContent];
        entity.imageURL = [dic objectForKey:kMsgImageURL];
        entity.msgURL = [dic objectForKey:kMsgURL];
        NSNumber *idSendTime = [dic objectForKey:kMsgSendTime];
        if(idSendTime){
            entity.sendTime  = [idSendTime integerValue];
        }
        NSNumber *idRecTime = [dic objectForKey:kMsgRecTime];
        if(idRecTime){
           entity.recTime = [idRecTime integerValue];
        }
        NSNumber *idIsRead = [dic objectForKey:kMsgRead];
        if(idIsRead){
            entity.isRead = [idIsRead integerValue];
        }
        [array addObject:entity];
    }
    return array;
}

- (NSArray*)loadAllSystemMessage{
    NSArray *msgDicArray = [[WXSqlite sharedSqlite] loadAllSysMsgData];
    return [self systemMessageEntityFrom:msgDicArray];
}

- (NSInteger)insertSysMessage:(SystemMessageEntity*)entity{
    NSInteger msgUID = [[WXSqlite sharedSqlite] insertPushType:entity.msgPushType systemMessageType:entity.msgType msgID:entity.msgID msgDidload:entity.msgDidReady title:entity.title content:entity.content imageURL:entity.imageURL msgURL:entity.msgURL sendTime:entity.sendTime recTime:entity.recTime isRead:entity.isRead];
    return msgUID;
}

//更新数据
- (BOOL)updateSysMessage:(SystemMessageEntity*)entity{
    return  [[WXSqlite sharedSqlite] updatePushType:entity.msgPushType systemMessageType:entity.msgType msgID:entity.msgID msgDidload:entity.msgDidReady title:entity.title content:entity.content imageURL:entity.imageURL msgURL:entity.msgURL sendTime:entity.sendTime recTime:entity.recTime isRead:entity.isRead wherePrimaryID:entity.msgUID];
}

@end
