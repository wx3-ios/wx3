//
//  SystemMesageEntity.m
//  SQLite
//
//  Created by le ting on 5/5/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SystemMessageEntity.h"

@implementation SystemMessageEntity
@synthesize msgUID = _msgUID;
@synthesize msgPushType = _msgPushType;
@synthesize msgType = _msgType;
@synthesize msgID = _msgID;
@synthesize msgDidReady = _msgDidReady;
@synthesize title = _title;
@synthesize content = _content;
@synthesize imageURL = _imageURL;
@synthesize msgURL = _msgURL;
@synthesize sendTime = _sendTime;
@synthesize recTime = _recTime;
@synthesize isRead = _isRead;

- (void)dealloc{
//    [super dealloc];
}

//暂时这么做
- (BOOL)isAllNumbers:(NSString*)str{
    BOOL ret = YES;
    if(str){
        NSInteger len = str.length;
        if(len > 0){
            for(NSInteger i = 0; i < len; i++){
                unichar c = [str characterAtIndex:i];
                if(!(c >= '0' && c <= '9')){
                    ret = NO;
                    break;
                }
            }
        }
    }
    return ret;
}

//消息的链接是否已经完善
- (BOOL)isMSgURLComplete{
    return ![self isAllNumbers:_msgURL];
}

//图片的连接是否已经完善
- (BOOL)isImageURLComplete{
    return ![self isAllNumbers:_imageURL];
}

- (BOOL)isPushMessageAlreadyReady{
    return _msgDidReady;
}

@end
