//
//  WXContactMonitor.m
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXContactMonitor.h"
#import "WXService.h"

@interface WXContactMonitor()
{
    NSMutableArray *_wxContactList;
}
@end

@implementation WXContactMonitor
@synthesize wxContactList = _wxContactList;

- (void)dealloc{;
    [self removeOBS];
//    [super dealloc];
}

+ (WXContactMonitor*)sharedWXContactMonitor{
    static dispatch_once_t onceToken;
    static WXContactMonitor *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXContactMonitor alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
        _wxContactList = [[NSMutableArray alloc] init];
        [self addOBS];
    }
    return self;
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(beginLoadWXFriend) name:D_Notification_Name_LoadWXFriendBegin object:nil];
    [notificationCenter addObserver:self selector:@selector(loadWXFriend:) name:D_Notification_Name_LoadAWXFriend object:nil];
    [notificationCenter addObserver:self selector:@selector(loadWXFriendComplete) name:D_Notification_Name_LoadWXFriendEnd object:nil];
    [notificationCenter addObserver:self selector:@selector(increaseWXFriend:) name:D_Notification_Name_IncreaseWXFriend object:nil];
    [notificationCenter addObserver:self selector:@selector(wxFriendChanged:) name:D_Notification_Name_WXFriendChanged object:nil];    
}

- (void)beginLoadWXFriend{
    [_wxContactList removeAllObjects];
}
- (void)loadWXFriend:(NSNotification*)notification{
    NSArray *array = notification.object;
    if(array && [array isKindOfClass:[NSArray class]]){
        WXContacterEntity *entity = [WXContacterEntity wxContacterWithParamArray:array];
        if(entity){
            [_wxContactList addObject:entity];
        }
    }
}

- (void)loadWXFriendComplete{
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_WXAddressBookHasChanged object:nil];
}

- (void)increaseWXFriend:(NSNotification*)notification{
    NSArray *pramArray = notification.object;
    if(pramArray && [pramArray isKindOfClass:[NSArray class]]){
        WXContacterEntity *entity = [WXContacterEntity wxContacterWithParamArray:pramArray];
        if(entity){
            [_wxContactList addObject:entity];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_WXContacterAdded object:entity userInfo:nil];
        }
    }
}

enum{
    E_WXIconChanged_RID = 0,//RID
    E_WXIconChanged_IconPath,//图片地址
    E_WXIconChanged_Phone,//电话号码
};

- (void)wxFriendChanged:(NSNotification*)notification{
    NSArray *pramArray = notification.object;
    if(pramArray && [pramArray isKindOfClass:[NSArray class]]){
        NSString  *rid = [pramArray objectAtIndex:E_WXIconChanged_RID];
        NSString *iconPath = [pramArray objectAtIndex:E_WXIconChanged_IconPath];
        WXContacterEntity *entity = [self entityForRID:rid];
        if(entity){
            entity.iconPath = iconPath;
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_WXContacterHasChanged object:entity];
        }
    }
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 查找~
- (WXContacterEntity*)entityForPhonNumber:(NSString*)phoneNumber{
    for(WXContacterEntity *entity in _wxContactList){
        if([entity.bindID isEqualToString:phoneNumber]){
            return entity;
        }
    }
    return nil;
}

- (WXContacterEntity*)entityForRecordID:(NSInteger)recordID{
    for(WXContacterEntity *entity in _wxContactList){
        if(entity.recordID == recordID){
            return entity;
        }
    }
    return nil;
}
- (WXContacterEntity*)entityForRID:(NSString*)rID{
    for(WXContacterEntity *entity in _wxContactList){
        if([entity.rID isEqualToString:rID]){
            return entity;
        }
    }
    return nil;
}

- (BOOL)isPhoneNumberWX:(NSString*)phoneNumber{
    if(!phoneNumber){
        return NO;
    }
    WXContacterEntity *entity = [self entityForPhonNumber:phoneNumber];
    return entity && entity.wxStatus == E_WXContacterStatus_ISWX;
}

- (void)loadWXContacter{
    [[WXService sharedService] loadWXContacterFromDB];
}

- (void)removeWXContacter{
    [_wxContactList removeAllObjects];
}

@end
