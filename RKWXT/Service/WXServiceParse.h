//
//  WXServiceParse.h
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "it_lib.h"
@interface WXServiceParse : NSObject

+ (id)sharedWXServiceParse;
- (void)parseMessageID:(SS_UINT32)messageID pParam:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
      notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject;
@end
