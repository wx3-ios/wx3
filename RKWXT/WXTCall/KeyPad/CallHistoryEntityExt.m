//
//  CallHistoryEntityExt.m
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CallHistoryEntityExt.h"

@interface CallHistoryEntityExt()
{
    NSMutableArray *_recordArray;
}
@end

@implementation CallHistoryEntityExt
@synthesize recordArray = _recordArray;

- (void)dealloc{
//    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _recordArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRecord:(CallHistoryEntity*)entity{
    if(entity){
        [_recordArray addObject:entity];
    }
}

- (CallHistoryEntity*)callHistoryEntity{
    CallHistoryEntity *entity = [_recordArray firstObject];
    return entity;
}

- (BOOL)canMergeRecord:(CallHistoryEntity*)entity{
    CallHistoryEntity *lastEntity = [_recordArray lastObject];
    BOOL ret = [lastEntity canMergeRecord:entity];
    return ret;
}

@end
