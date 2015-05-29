//
//  SysMsgItem.m
//  Woxin2.0
//
//  Created by le ting on 8/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgItem.h"
#import "SqliteDef.h"
#import "SysMessageDef.h"

@implementation SysMsgItem

- (void)dealloc{
//    [super dealloc];
}

+ (SysMsgItem*)sysMsgItemWithSqlDic:(NSDictionary*)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithSysMessageSqlDic:dic];
}

- (id)initWithSysMessageSqlDic:(NSDictionary*)dic{
    if(self = [super init]){
        NSInteger primeryID = [[dic objectForKey:kPrimaryKey] integerValue];
        [self setPrimaryID:primeryID];
        [self setMsgID:[[dic objectForKey:kSysMessageUID] integerValue]];
        [self setMsgType:[[dic objectForKey:kSysMessageType] integerValue]];
        [self setSubShopID:[[dic objectForKey:kSubShopID] integerValue]];
        [self setSubShopName:[dic objectForKey:kSubShopName]];
        [self setSendTime:[[dic objectForKey:kSysMessageSendTime] integerValue]];
        [self setRecTime:[[dic objectForKey:kSysMessageRecTime] integerValue]];
        [self setPushTitle:[dic objectForKey:kSysMessagePushTitle]];
        [self setMsgTitle:[dic objectForKey:kSysMessageTitle]];
        [self setAbstract:[dic objectForKey:kSysMessageAbstract]];
        [self setImageURL:[dic objectForKey:kSysMessageImageURL]];
        [self setMessageURL:[dic objectForKey:kSysMessageURL]];
    }
    return self;
}

+ (SysMsgItem*)sysMsgItemWithPushDic:(NSDictionary*)dic{
    if(!dic){
        return nil;
    }
    return [[self alloc] initWithPushDic:dic];
}

- (id)initWithPushDic:(NSDictionary*)dic{
    if(self = [super init]){
        [self setMsgID:[[dic objectForKey:@"msg_id"] integerValue]];
        [self setMsgType:[[dic objectForKey:@"msg_type"] integerValue]];
        [self setSubShopID:[[dic objectForKey:@"shop_id"] integerValue]];
        [self setSubShopName:[dic objectForKey:@"shop_name"]];
        [self setSendTime:[[dic objectForKey:@"time"] integerValue]];
        [self setPushTitle:[dic objectForKey:@"push_title"]];
        [self setMsgTitle:[dic objectForKey:@"list_title"]];
        [self setAbstract:[dic objectForKey:@"list_abstract"]];
        [self setImageURL:[dic objectForKey:@"list_image_url"]];
        [self setMessageURL:[dic objectForKey:@"list_html_url"]];
        NSInteger secondsSince1970 = [NSDate todayTimeIntervalSince1970];
        [self setRecTime:secondsSince1970];
    }
    return self;
}
@end
