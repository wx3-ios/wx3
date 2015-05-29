//
//  SysMsgItem.h
//  Woxin2.0
//
//  Created by le ting on 8/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    E_SysMessageType_Normal = 2,//
}E_SysMessageType;

@interface SysMsgItem : NSObject
@property (nonatomic,assign)NSInteger primaryID;//key
@property (nonatomic,assign)NSInteger msgID;//消息ID
@property (nonatomic,assign)E_SysMessageType msgType;//消息类型~
@property (nonatomic,assign)NSInteger subShopID;//分店ID
@property (nonatomic,retain)NSString *subShopName;//分店名称
@property (nonatomic,assign)NSInteger sendTime;//消息发送时间
@property (nonatomic,assign)NSInteger recTime;//接受时间
@property (nonatomic,retain)NSString *pushTitle;//推送时的title
@property (nonatomic,retain)NSString *msgTitle;//消息的title
@property (nonatomic,retain)NSString *abstract;//消息概要
@property (nonatomic,retain)NSString *imageURL;//图片的URL
@property (nonatomic,retain)NSString *messageURL;//消息的URL

+ (SysMsgItem*)sysMsgItemWithSqlDic:(NSDictionary*)dic;
+ (SysMsgItem*)sysMsgItemWithPushDic:(NSDictionary*)dic;
@end
