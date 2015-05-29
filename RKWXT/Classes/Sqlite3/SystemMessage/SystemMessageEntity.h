//
//  SystemMesageEntity.h
//  SQLite
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    //纯文本
    E_SystemMessage_Text = 0,
    //富文本
    E_SystemMessage_Rich,
    
    E_SystemMessage_Invalid,
}E_SystemMessageType;

@interface SystemMessageEntity : NSObject
@property (nonatomic,assign)NSInteger msgUID;
@property (nonatomic,assign)NSInteger msgPushType;
@property (nonatomic,assign)E_SystemMessageType msgType;
//消息唯一ID  此版本不用
@property (nonatomic,assign)NSInteger msgID;
//消息是否已经加载 此版本不用
@property (nonatomic,assign)BOOL msgDidReady;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *content;
@property (nonatomic,retain)NSString *imageURL;
@property (nonatomic,retain)NSString *msgURL;
@property (nonatomic,assign)NSInteger sendTime;
@property (nonatomic,assign)NSInteger recTime;
@property (nonatomic,assign)BOOL isRead;

//推送消息时候已经完善~ 是否需要再次从网络中获取（图片除外）
- (BOOL)isPushMessageAlreadyReady;
//消息的链接是否已经完善
- (BOOL)isMSgURLComplete;
//图片的连接是否已经完善
- (BOOL)isImageURLComplete;
@end
