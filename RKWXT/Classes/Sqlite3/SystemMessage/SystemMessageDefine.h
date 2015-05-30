//
//  SystemMessageDefine.h
//  SQLite
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#ifndef SQLite_SystemMessageDefine_h
#define SQLite_SystemMessageDefine_h

//推送类型
#define kMsgPushType @"PUSHTYPE"
//消息类型 0：纯文本 1：富文本
#define kMsgType @"MSGTYPE"
//消息的ID
#define kMsgID @"MSGID"
//消息是否已经准备好了~
#define kMsgDidReady @"MSGDIDREADY"
//消息标题
#define kMsgTitle @"MSGTITLE"
//消息内容
#define kMsgContent @"MSGCONTENT"
//消息图片的URL
#define kMsgImageURL @"IMAGEURL"
//消息的全地址
#define kMsgURL @"MSGURL"
//消息发送时间
#define kMsgSendTime @"SENDTIME"
//消息接收时间
#define kMsgRecTime @"RECTIME"
//是否已读
#define kMsgRead @"MSGREAD"
//商家标签
#define kBusinessID @"BUSINESSID"

//四个预留字段~ 两个txt的 两个int的
#define kReservedTxt_0 @"RESERVEDTXT_0"
#define kReservedTxt_1 @"RESERVEDTXT_1"
#define kReservedInt_0 @"RESERVEDINT_0"
#define kReservedInt_1 @"RESERVEDINT_1"

#endif
