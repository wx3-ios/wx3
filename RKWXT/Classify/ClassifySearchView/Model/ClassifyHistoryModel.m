//
//  ClassifyHistoryModel.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyHistoryModel.h"
#import "ClassifySql.h"
#import "ClassifySqlEntity.h"

@interface ClassifyHistoryModel(){
    ClassifySql *fmdb;
    NSMutableArray *_listArr;
}
@end

@implementation ClassifyHistoryModel
@synthesize listArr = _listArr;

-(id)init{
    self = [super init];
    if(self){
        _listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadClassifyHistoryList{
    fmdb = [[ClassifySql alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    [_listArr removeAllObjects];
    NSArray *arr = [fmdb selectAll];
    for(int i = [arr count]-1; i >= 0; i--){
        ClassifySql *entity = [arr objectAtIndex:i];
        if(entity){
            [_listArr addObject:entity];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_ClassifyHistoryLoadSucceed object:nil];
}

-(void)deleteClassifyRecordWith:(NSString *)recordName{
    if(!fmdb){
        fmdb = [[ClassifySql alloc] init];
    }
    [fmdb createOrOpendb];
    [fmdb createTable];
    
    BOOL succeed = [fmdb deleteClassifyHistoryList:recordName];
    if(succeed){
        for(ClassifySqlEntity *entity in _listArr){
            if(entity.recordName == recordName){
                [_listArr removeObject:entity];
                break;
            }
        }
    }
}

-(void)deleteAll{
    if(!fmdb){
        fmdb = [[ClassifySql alloc] init];
    }
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb deleteAll];
    if(succeed){
        [_listArr removeAllObjects];
    }
}

@end
