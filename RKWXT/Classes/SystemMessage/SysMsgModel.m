//
//  SysMsgModel.m
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgModel.h"
#import "SysMsgSqlite.h"
#import "SysMsgDef.h"
#import "it_lib.h"

@interface SysMsgModel(){
    NSMutableArray *_sysMsgList;
}
@end

@implementation SysMsgModel
@synthesize sysMsgList = _sysMsgList;

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _sysMsgList = [[NSMutableArray alloc] init];
        [self loadSystemMessageItemList];
        [self addOBS];
    }
    return self;
}

- (void)loadSystemMessageItemList{
    [_sysMsgList removeAllObjects];
    NSArray *list = [[SysMsgSqlite sharedSystemMessageSqlite] loadAllSysMessageData];
    if(!list || [list count] > 0){
        [self insertNewSysMsgItemList:list];
    }
}

- (NSArray*)insertNewSysMsgItemList:(NSArray *)itemList{
    if(!itemList || [itemList count] == 0){
        KFLog_Normal(YES, @"插入空数据");
        return nil;
    }
    NSArray *newArray = [itemList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SysMsgItem *item1 = obj1;
        SysMsgItem *item2 = obj2;
        NSInteger dif = item2.sendTime - item1.sendTime;
        if(dif < 0){
            return NSOrderedAscending;
        }else if(dif == 0){
            return NSOrderedSame;
        }else{
            return NSOrderedDescending;
        }
    }];
    if(newArray){
        [_sysMsgList insertObjects:newArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [newArray count])]];
    }
    return newArray;
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(incomePush:) name:D_Notification_Name_SystemMessageDetected object:nil];
}

- (void)incomePush:(NSNotification*)notification{
    NSArray *itemList = notification.object;
    NSArray *insertItemList = [self insertNewSysMsgItemList:itemList];
    if(insertItemList && [insertItemList count] > 0){
        if(_delegate && [_delegate respondsToSelector:@selector(incomePushList:)]){
            [_delegate incomePushList:insertItemList];
        }
    }
}
- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end