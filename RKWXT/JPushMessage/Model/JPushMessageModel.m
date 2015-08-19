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
#import <AudioToolbox/AudioToolbox.h>
#import "WXTURLFeedOBJ+NewData.h"

@interface JPushMessageModel(){
    NSMutableArray *_jpushMsgArr;
    NSMutableArray *_proArr;
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
        _proArr = [[NSMutableArray alloc] init];
    }
    return self;
}

//收到新消息后，点击icon无法获取到新消息，那么要从服务器获取最新的一条消息
-(void)loadJPushMessageFromService{
    [self loadJPushData];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    if([userObj.sellerID integerValue] <= 1){
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInteger:kMerchantID], @"sid", nil];
    __block JPushMessageModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadJPushMessage httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
        }else{
            [blockSelf parseJPushMessageWithDic:[retData.data objectForKey:@"data"]];
        }
    }];
}

-(void)parseJPushMessageWithDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    JPushMsgEntity *entity = [JPushMsgEntity initWithJPushMessageWithDic:dic];
    for(JPushMsgEntity *ent in _jpushMsgArr){
        if(ent.push_id == entity.push_id && ent.push_id != 0){
            return;
        }
    }
    entity.content = [dic objectForKey:@"push_title"];
    [_jpushMsgArr addObject:entity];
    [_proArr addObject:entity];
    
    Sql_JpushData *jpush = [[Sql_JpushData alloc] init];
    [jpush insertData:entity.content withAbs:entity.abstract withImg:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.msgURL] withPushID:[NSString stringWithFormat:@"%ld",(long)entity.push_id]];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_SystemMessageDetected object:nil];
}

//应用内
-(void)initJPushWithDic:(NSDictionary *)dic{
    if(!dic){
        return;
    }
    [_jpushMsgArr removeAllObjects];
    JPushMsgEntity *entity = [JPushMsgEntity initWithJPushMessageWithDic:dic];
    entity.content = [[dic objectForKey:@"aps"] objectForKey:@"alert"];
    [_jpushMsgArr addObject:entity];
    
    for(JPushMsgEntity *ent in _proArr){
        if(ent.push_id == entity.push_id && ent.push_id != 0){
            return;
        }
    }
    [_proArr addObject:entity];
    Sql_JpushData *jpush = [[Sql_JpushData alloc] init];
    [jpush insertData:entity.content withAbs:entity.abstract withImg:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.msgURL] withPushID:[NSString stringWithFormat:@"%ld",(long)entity.push_id]];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_SystemMessageDetected object:nil];
//    [self sound];
}

//锁屏
-(void)initJPushWithCloseDic:(NSDictionary *)dic{
    if(!dic){
        return;
    }
    [_jpushMsgArr removeAllObjects];
    JPushMsgEntity *entity = [JPushMsgEntity initWithJPushCloseMessageWithDic:dic];
    entity.content = [dic objectForKey:@"title"];
    [_jpushMsgArr addObject:entity];
    
    for(JPushMsgEntity *ent in _proArr){
        if(ent.push_id == entity.push_id && ent.push_id != 0){
            return;
        }
    }
    [_proArr addObject:entity];
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

-(void)deleteJPushWithPushID:(NSInteger)pushID{
    fmdb = [[T_Sqlite alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    
    BOOL succeed = [fmdb deleteTestList:pushID];
    if(succeed){
        for(JPushMsgEntity *entity in _jpushMsgArr){
            if(entity.push_id == pushID){
                [_jpushMsgArr removeObject:entity];
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_JPushMessage_DeleteSucceed object:nil];
    }
}

-(void)sound{
    NSString *string = [NSString stringWithFormat:@"message"];
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

@end
