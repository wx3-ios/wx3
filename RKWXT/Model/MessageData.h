//
//  MessageData.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-11.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageStatus)
{
    MessageStatusNew,//未读新消息
    MessageStatusRead,//已读的消息
};

@interface MessageData : NSObject

@property (assign) NSInteger ROWID;
@property (nonatomic, strong) NSString *uid;//用户ID
@property (nonatomic, strong) NSString *obj;//类别
@property (nonatomic, strong) NSString *title;//标题.内容
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDate *date;
@property (assign) NSInteger status;//状态 0|1 未读|已读

@property (assign) NSInteger groupCount;

@end
