//
//  JPushMessageModel.h
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define K_Notification_JPushMessage_LoadSucceed @"K_Notification_JPushMessage_LoadSucceed"
#define K_Notification_JPushMessage_DeleteSucceed @"K_Notification_JPushMessage_DeleteSucceed"

@interface JPushMessageModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *jpushMsgArr;

+(JPushMessageModel*)shareJPushModel;
-(void)initJPushWithDic:(NSDictionary*)dic;
-(void)loadJPushData;
-(void)deleteJPushWithPushID:(NSInteger)pushID;

@end
