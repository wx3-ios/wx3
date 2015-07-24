//
//  JPushMsgEntity.h
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushMsgEntity : NSObject
@property (nonatomic,strong) NSString *content;  //消息头
@property (nonatomic,strong) NSString *abstract;  //摘要
@property (nonatomic,strong) NSString *msgURL;
@property (nonatomic,assign) NSInteger push_id;
@property (nonatomic,strong) NSString *pushTime;

+(JPushMsgEntity*)initWithJPushMessageWithDic:(NSDictionary*)dic;
+(JPushMsgEntity*)initWithJPushCloseMessageWithDic:(NSDictionary*)dic;

@end
