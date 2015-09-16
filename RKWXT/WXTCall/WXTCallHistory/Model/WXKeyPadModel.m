//
//  WXKeyPadModel.m
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXKeyPadModel.h"
#import "CallRecord.h"
#import "CallHistoryEntityExt.h"
#import "StrangerEntity.h"
#import "SysContacterEntityEx.h"
#import "WXTDatabase.h"

@interface WXKeyPadModel()
{
    NSMutableArray *_callHistoryList;
    NSMutableArray *_contacterFilter;
    NSArray * _list; //通话记录
}
@end

@implementation WXKeyPadModel

- (void)dealloc{
    _delegate = nil;
    [self removeOBS];
}

- (id)init{
    if(self = [super init]){
        _callHistoryList = [[NSMutableArray alloc] init];
        _contacterFilter = [[NSMutableArray alloc] init];
        [self loadHistory];
        [self addOBS];
    }
    return self;
}

- (void)loadHistory{
    [_callHistoryList removeAllObjects];
    
    _list = [CallRecord sharedCallRecord].callHistoryList;
    CallHistoryEntityExt *entityExt = nil;
    for(CallHistoryEntity *entity in _list){
        NSString *phoneNumber = entity.phoneNumber;
        if(!phoneNumber || [phoneNumber length] < 6){
            continue;
        }
        
        if(entity.historyType == E_CallHistoryType_MakingReaded_Invalid){
            continue;
        }
        if(entityExt){
            if([entityExt canMergeRecord:entity]){
                [entityExt addRecord:entity];
            }else{
                entityExt = nil;
            }
        }
        
        if(!entityExt){
            entityExt = [[CallHistoryEntityExt alloc] init] ;
            [entityExt addRecord:entity];
            [_callHistoryList addObject:entityExt];
            WXContacterEntity *entity = [[WXContactMonitor sharedWXContactMonitor] entityForPhonNumber:phoneNumber];
            if(entity){
                [entityExt setContacterEntity:entity];
            }else{
                ContacterEntity *entity = [[AddressBook sharedAddressBook] contacterEntityForNumber:phoneNumber];
                if(entity){
                    [entityExt setContacterEntity:entity];
                }else{
                    StrangerEntity *stranger =  [[StrangerEntity alloc] init];
                    [stranger setPhoneNumber:phoneNumber];
                    [entityExt setContacterEntity:stranger];
                }
            }
        }
    }
}

- (void)searchContacter:(NSString*)searchString{
    [_contacterFilter removeAllObjects];
    if(!searchString || [searchString length] == 0){
        return;
    }
    NSArray *list = [AddressBook sharedAddressBook].contactList;
    for(ContacterEntity *entity in list){
        NSArray *phoneNumbers = entity.phoneNumbers;
        for(NSString *phone in phoneNumbers){
            if([phone rangeOfString:searchString].location != NSNotFound){
                SysContacterEntityEx *sysContacterEntityEx = [[SysContacterEntityEx alloc] init] ;
                [sysContacterEntityEx setContactEntity:entity];
                [sysContacterEntityEx setPhoneMatched:phone];
                [_contacterFilter addObject:sysContacterEntityEx];
            }
        }
    }
//    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:@"callHistoryHasLoaded" object:nil userInfo:nil];
    
//    for(CallHistoryEntity *entity in _list){
//        NSString *phoneNumber = entity.phoneNumber;
//        if([phoneNumber rangeOfString:searchString].location != NSNotFound){
//            SysContacterEntityEx *sysContacterEntityEx = [[SysContacterEntityEx alloc] init] ;
//            [sysContacterEntityEx setCallHistoryEntity:entity];
//            [sysContacterEntityEx setPhoneMatched:phoneNumber];
//            [_contacterFilter addObject:sysContacterEntityEx];
//        }
//    }
}

#pragma mark 删除通话记录

- (void)deleteCallRecords:(CallHistoryEntityExt*)ext{
    for(CallHistoryEntity *record in ext.recordArray){
        [[CallRecord sharedCallRecord] deleteCallRecord:record.UID];
    }
}

- (void)deleteCallRecordsAtRow:(NSInteger)row{
    CallHistoryEntityExt *entity = [self.callHistoryList objectAtIndex:row];
    [self deleteCallRecords:entity];
    [_callHistoryList removeObjectAtIndex:row];
    if ([_callHistoryList count] == 0){
        if (_delegate && [_delegate respondsToSelector:@selector(callRecordHasCleared)]){
            [_delegate callRecordHasCleared];
        }
    }
}

- (void)clearAllRecords{
	for (CallHistoryEntityExt *ext in _callHistoryList) {
		[self deleteCallRecords:ext];
	}
	[_callHistoryList removeAllObjects];
}


#pragma mark 查找~

- (CallHistoryEntityExt*)callHistoryExtAtRow:(NSInteger)row{
    NSInteger callHistoryCount = [_callHistoryList count];
    if(row >= callHistoryCount){
        KFLog_Normal(YES, @"无效的号码");
        return nil;
    }
    CallHistoryEntityExt *entity = [_callHistoryList objectAtIndex:row];
    return entity;
}

- (NSString*)callHistoryPhoneAtRow:(NSInteger)row{
    CallHistoryEntityExt *entity = [self callHistoryExtAtRow:row];
    return entity.callHistoryEntity.phoneNumber;
}

- (SysContacterEntityEx*)contactEntityExAtRow:(NSInteger)row{
    NSInteger contacterCount = [_contacterFilter count];
    if(row >= contacterCount){
        KFLog_Normal(YES, @"无效的号码");
        return nil;
    }
    SysContacterEntityEx *entity = [_contacterFilter objectAtIndex:row];
    return entity;
}

- (NSString*)contactPhoneAtRow:(NSInteger)row{
    SysContacterEntityEx *entity = [self contactEntityExAtRow:row];
    return entity.phoneMatched;
}

- (ContactBaseEntity*)callhistoryContactEntityAtRow:(NSInteger)row{
    CallHistoryEntityExt *entity = [self callHistoryExtAtRow:row];
    ContactBaseEntity *contactEntity = entity.contacterEntity;
    if(!contactEntity){
        KFLog_Normal(YES, @"陌生人~");
        contactEntity = [[StrangerEntity alloc] init] ;
        [(StrangerEntity*)contactEntity setPhoneNumber:entity.callHistoryEntity.phoneNumber];
    }
    return contactEntity;
}

- (ContactBaseEntity*)searchContactEntityAtRow:(NSInteger)row{
    SysContacterEntityEx *entity = [_contacterFilter objectAtIndex:row];
    return entity.contactEntity;
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(callRecordLoadFinished:) name:D_Notification_Name_CallRecordLoadFinished object:nil];
    [notificationCenter addObserver:self selector:@selector(callRecordChanged:) name:D_Notification_Name_CallRecordAdded object:nil];
}

- (void)callRecordLoadFinished:(NSNotification*)notification{
    [self loadHistory];
    if(_delegate && [_delegate respondsToSelector:@selector(callHistoryChanged)]){
        [_delegate callHistoryChanged];
    }
}

- (void)callRecordChanged:(NSNotification*)notification{
    [self loadHistory];
    if(_delegate && [_delegate respondsToSelector:@selector(callHistoryChanged)]){
        [_delegate callHistoryChanged];
    }
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
