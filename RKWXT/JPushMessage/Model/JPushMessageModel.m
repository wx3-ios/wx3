//
//  JPushMessageModel.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushMessageModel.h"
#import "JPushMsgEntity.h"
#import "Sql_JpushData.h"
#import "JPushDef.h"
#import "T_Sqlite.h"

@interface JPushMessageModel(){
    NSMutableArray *_jpushMsgArr;
    T_Sqlite *fmdb;
}
@end

@implementation JPushMessageModel

+(JPushMessageModel*)shareJPushModel{
    static dispatch_once_t onceToken;
    static JPushMessageModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[JPushMessageModel alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if(self){
        _jpushMsgArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initJPushWithDic:(NSDictionary *)dic{
    if(!dic){
        return;
    }
    [_jpushMsgArr removeAllObjects];
    JPushMsgEntity *entity = [JPushMsgEntity initWithJPushMessageWithDic:dic];
    entity.content = [[dic objectForKey:@"aps"] objectForKey:@"alert"];
    [_jpushMsgArr addObject:entity];
    
    Sql_JpushData *jpush = [[Sql_JpushData alloc] init];
    [jpush insertData:entity.content withAbs:entity.abstract withImg:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.msgURL] withPushID:[NSString stringWithFormat:@"%ld",(long)entity.push_id]];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_SystemMessageDetected object:nil];
}

-(void)loadJPushData{
    fmdb = [[T_Sqlite alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    [_jpushMsgArr removeAllObjects];
    NSArray *arr = [fmdb selectAll];
    for(int i = [arr count]-1; i >= 0; i--){
        JPushMsgEntity *entity = [arr objectAtIndex:i];
        if(entity){
            [_jpushMsgArr addObject:entity];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_JPushMessage_LoadSucceed object:nil];
}

@end
