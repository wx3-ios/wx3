//
//  LMSearchHistoryModel.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchHistoryModel.h"
#import "LMSearchHistorySql.h"
#import "LMSearchHistoryEntity.h"

@interface LMSearchHistoryModel(){
    LMSearchHistorySql *fmdb;
    NSMutableArray *_listArr;
}
@end

@implementation LMSearchHistoryModel
@synthesize listArr = _listArr;

-(id)init{
    self = [super init];
    if(self){
        _listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadLMSearchHistoryList{
    fmdb = [[LMSearchHistorySql alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    [_listArr removeAllObjects];
    NSArray *arr = [fmdb selectAll];
    for(int i = [arr count]-1; i >= 0; i--){
        LMSearchHistorySql *entity = [arr objectAtIndex:i];
        if(entity){
            [_listArr addObject:entity];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LMSearchHistoryLoadSucceed object:nil];
}

-(void)deleteLMSearchRecordWith:(NSString *)recordName{
    if(!fmdb){
        fmdb = [[LMSearchHistorySql alloc] init];
    }
    [fmdb createOrOpendb];
    [fmdb createTable];
    
    BOOL succeed = [fmdb deleteLMSearchHistoryList:recordName];
    if(succeed){
        for(LMSearchHistoryEntity *entity in _listArr){
            if(entity.recordName == recordName){
                [_listArr removeObject:entity];
                break;
            }
        }
    }
}

-(void)deleteAll{
    if(!fmdb){
        fmdb = [[LMSearchHistorySql alloc] init];
    }
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb deleteAll];
    if(succeed){
        [_listArr removeAllObjects];
    }
}

@end
